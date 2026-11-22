import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'archivio.dart';
import 'catalogo.dart';
import 'firebase_config.dart';
import 'models.dart';

/// Stato dell'app: lista, catalogo, famiglia.
class Stato extends ChangeNotifier with WidgetsBindingObserver {
  late SharedPreferences _prefs;
  late ArchivioLocale _locale;
  Archivio? _archivio;
  StreamSubscription<List<Voce>>? _subVoci;
  StreamSubscription<List<Prodotto>>? _subProd;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subFam;

  bool pronto = false;
  bool condivisioneDisponibile = false;
  String? erroreFirebase;
  String? uid;

  String nome = '';
  String? codiceFamiglia;
  Map<String, String> membri = {};

  List<Voce> voci = [];
  List<Prodotto> _personali = [];

  bool get inFamiglia =>
      codiceFamiglia != null && _archivio is ArchivioFamiglia;

  StatoSync statoSync = StatoSync.ok;

  /// Riapre il collegamento con il server: invia subito le modifiche in
  /// attesa e scarica quelle dell'altro telefono. Si usa quando l'app torna
  /// in primo piano (il telefono spesso chiude la connessione in background)
  /// e quando si tira giù la lista.
  Future<void> riconnetti() async {
    if (!inFamiglia) return;
    try {
      final fs = FirebaseFirestore.instance;
      await fs.disableNetwork();
      await fs.enableNetwork();
    } catch (_) {}
  }

  /// Quando l'app torna in primo piano riallaccia subito la connessione.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) riconnetti();
  }

  Future<void> avvia() async {
    WidgetsBinding.instance.addObserver(this);
    _prefs = await SharedPreferences.getInstance();
    _locale = ArchivioLocale(_prefs);
    nome = _prefs.getString('nome') ?? '';
    codiceFamiglia = _prefs.getString('famiglia');

    if (firebaseConfigurato) {
      try {
        await Firebase.initializeApp(options: opzioniFirebase);
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          // Sul web (iPhone) il collegamento "streaming" viene spesso
          // rallentato o interrotto dalle reti mobili e da Safari: il
          // long polling è più affidabile e le spunte arrivano subito.
          webExperimentalForceLongPolling: true,
        );
        final auth = FirebaseAuth.instance;
        uid =
            auth.currentUser?.uid ?? (await auth.signInAnonymously()).user?.uid;
        condivisioneDisponibile = uid != null;
      } catch (e) {
        erroreFirebase = '$e';
        condivisioneDisponibile = false;
      }
    }

    _collega(
      condivisioneDisponibile && codiceFamiglia != null
          ? ArchivioFamiglia(codiceFamiglia!)
          : _locale,
    );
    pronto = true;
    notifyListeners();
  }

  void _collega(Archivio a) {
    _subVoci?.cancel();
    _subProd?.cancel();
    _subFam?.cancel();
    if (_archivio != _locale) _archivio?.chiudi();
    _archivio = a;
    _subVoci = a.voci().listen((v) {
      voci = v;
      notifyListeners();
    });
    _subProd = a.prodotti().listen((p) {
      _personali = p;
      notifyListeners();
    });
    if (a is ArchivioFamiglia) {
      a.sync.addListener(() {
        statoSync = a.sync.value;
        notifyListeners();
      });
      _subFam = _docFamiglia(a.codice).snapshots().listen((s) {
        final d = s.data();
        if (d == null) return;
        membri = Map<String, String>.from(d['nomi'] as Map? ?? const {});
        notifyListeners();
      }, onError: (_) {});
    } else {
      membri = {};
    }
  }

  // ---------------------------------------------------------------- catalogo

  /// Catalogo di base + prodotti e marche aggiunti da voi.
  List<Prodotto> get catalogo {
    final pers = {for (final p in _personali) p.id: p};
    final out = <Prodotto>[];
    for (final b in catalogoBase) {
      final extra = pers.remove(b.id);
      out.add(
        extra == null
            ? b
            : b.copyWith(marche: {...b.marche, ...extra.marche}.toList()),
      );
    }
    out.addAll(pers.values);
    return out;
  }

  List<Prodotto> prodottiDi(Reparto r) =>
      catalogo.where((p) => p.reparto == r).toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));

  List<Prodotto> cerca(String q) {
    final t = normalizza(q);
    if (t.isEmpty) return [];
    final perNome = <Prodotto>[];
    final perMarca = <Prodotto>[];
    for (final p in catalogo) {
      if (normalizza(p.nome).contains(t)) {
        perNome.add(p);
      } else if (p.marche.any((m) => normalizza(m).contains(t))) {
        perMarca.add(p);
      }
    }
    // Prima chi si chiama esattamente così, poi chi inizia così, poi i più corti.
    int punti(Prodotto p) {
      final n = normalizza(p.nome);
      return n == t ? 0 : (n.startsWith(t) ? 1 : 2);
    }

    perNome.sort((a, b) {
      final c = punti(a) - punti(b);
      return c != 0 ? c : a.nome.length - b.nome.length;
    });
    return [...perNome, ...perMarca];
  }

  Future<void> aggiungiMarca(Prodotto p, String marca) async {
    final m = marca.trim();
    if (m.isEmpty || p.marche.any((x) => normalizza(x) == normalizza(m))) {
      return;
    }
    final esistente = _personali.where((x) => x.id == p.id).firstOrNull;
    await _archivio!.salvaProdotto(
      Prodotto(
        id: p.id,
        nome: p.nome,
        reparto: p.reparto,
        emoji: p.emoji,
        marche: [...?esistente?.marche, m],
        personale: true,
      ),
    );
  }

  Future<Prodotto> creaProdotto(String nome, Reparto reparto) async {
    final n = nome.trim();
    final esistente = catalogo
        .where((p) => normalizza(p.nome) == normalizza(n))
        .firstOrNull;
    if (esistente != null) return esistente;
    final p = Prodotto(
      id: 'p-${nuovoId()}',
      nome: n[0].toUpperCase() + n.substring(1),
      reparto: reparto,
      emoji: reparto.emoji,
      personale: true,
    );
    await _archivio!.salvaProdotto(p);
    return p;
  }

  // ------------------------------------------------------------------- lista

  /// Prodotti da prendere, raggruppati per reparto nell'ordine del negozio.
  List<(Reparto, List<Voce>)> get daPrendere {
    final out = <(Reparto, List<Voce>)>[];
    for (final r in Reparto.values) {
      final l = voci.where((v) => !v.presa && v.reparto == r).toList()
        ..sort((a, b) {
          final c = a.nome.compareTo(b.nome);
          return c != 0 ? c : (a.marca ?? '').compareTo(b.marca ?? '');
        });
      if (l.isNotEmpty) out.add((r, l));
    }
    return out;
  }

  List<Voce> get presi => voci.where((v) => v.presa).toList()
    ..sort(
      (a, b) => a.reparto.index != b.reparto.index
          ? a.reparto.index - b.reparto.index
          : a.nome.compareTo(b.nome),
    );

  int quantiInLista(Prodotto p) => voci
      .where((v) => !v.presa && (v.prodottoId == p.id || v.nome == p.nome))
      .fold(0, (s, v) => s + v.quantita);

  Future<void> aggiungi(Prodotto p, {String? marca, int quantita = 1}) async {
    final nuova = Voce(
      id: nuovoId(),
      prodottoId: p.id,
      nome: p.nome,
      marca: marca,
      reparto: p.reparto,
      emoji: p.emoji,
      quantita: quantita,
      aggiuntaDa: nome.isEmpty ? null : nome,
      creata: DateTime.now().millisecondsSinceEpoch,
    );
    // Se c'è già lo stesso prodotto della stessa marca, aumenta la quantità.
    final uguale = voci
        .where((v) => !v.presa && v.chiave == nuova.chiave)
        .firstOrNull;
    if (uguale != null) {
      await _archivio!.aggiornaVoce(uguale, {
        'quantita': inFamiglia
            ? FieldValue.increment(quantita)
            : uguale.quantita + quantita,
      });
    } else {
      await _archivio!.salvaVoce(nuova);
    }
  }

  Future<void> segna(Voce v, bool presa) => _archivio!.aggiornaVoce(v, {
    'presa': presa,
    'presaDa': presa && nome.isNotEmpty ? nome : null,
  });

  Future<void> cambiaQuantita(Voce v, int q) =>
      q <= 0 ? elimina(v) : _archivio!.aggiornaVoce(v, {'quantita': q});

  Future<void> cambiaNota(Voce v, String nota) =>
      _archivio!.aggiornaVoce(v, {'nota': nota.trim()});

  Future<void> elimina(Voce v) => _archivio!.eliminaVoci([v.id]);

  Future<void> ripristina(Voce v) => _archivio!.salvaVoce(v);

  Future<void> togliPresi() => _archivio!.eliminaVoci(presi.map((v) => v.id));

  // ----------------------------------------------------------------- persona

  Future<void> impostaNome(String n) async {
    nome = n.trim();
    await _prefs.setString('nome', nome);
    if (inFamiglia && uid != null) {
      unawaited(
        _docFamiglia(codiceFamiglia!)
            .update({'nomi.$uid': nome})
            .catchError((_) {}),
      );
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------- famiglia

  DocumentReference<Map<String, dynamic>> _docFamiglia(String c) =>
      FirebaseFirestore.instance.collection('famiglie').doc(c);

  static String _nuovoCodice() {
    const alfabeto = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(6, (_) => alfabeto[r.nextInt(alfabeto.length)]).join();
  }

  static String pulisciCodice(String c) =>
      c.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');

  /// Crea una famiglia e porta dentro la lista che c'era sul telefono.
  Future<String?> creaFamiglia() async {
    if (!condivisioneDisponibile || uid == null) {
      return 'Condivisione non disponibile';
    }
    try {
      var codice = _nuovoCodice();
      while ((await _docFamiglia(codice).get()).exists) {
        codice = _nuovoCodice();
      }
      await _docFamiglia(codice).set({
        'codice': codice,
        'membri': [uid],
        'nomi': {uid!: nome},
        'creata': FieldValue.serverTimestamp(),
      });
      await _entra(codice, portaListaLocale: true);
      return null;
    } catch (e) {
      return 'Non è stato possibile creare la famiglia ($e)';
    }
  }

  Future<String?> entraInFamiglia(String codiceScritto) async {
    final codice = pulisciCodice(codiceScritto);
    if (!condivisioneDisponibile || uid == null) {
      return 'Condivisione non disponibile';
    }
    if (codice.length != 6) return 'Il codice ha 6 caratteri';
    try {
      final doc = await _docFamiglia(codice).get();
      if (!doc.exists) return 'Codice non trovato: controlla e riprova';
      await _docFamiglia(codice).update({
        'membri': FieldValue.arrayUnion([uid]),
        'nomi.$uid': nome,
      });
      await _entra(codice, portaListaLocale: true);
      return null;
    } catch (e) {
      return 'Non è stato possibile entrare ($e)';
    }
  }

  Future<void> _entra(String codice, {required bool portaListaLocale}) async {
    codiceFamiglia = codice;
    await _prefs.setString('famiglia', codice);
    final fam = ArchivioFamiglia(codice);
    if (portaListaLocale) {
      for (final v in _locale.tutteLeVoci) {
        await fam.salvaVoce(v);
      }
      await _locale.eliminaVoci(_locale.tutteLeVoci.map((v) => v.id));
    }
    _collega(fam);
    notifyListeners();
  }

  Future<void> esciDallaFamiglia() async {
    final c = codiceFamiglia;
    codiceFamiglia = null;
    await _prefs.remove('famiglia');
    _collega(_locale);
    if (c != null && uid != null) {
      unawaited(
        _docFamiglia(c)
            .update({
              'membri': FieldValue.arrayRemove([uid]),
              'nomi.$uid': FieldValue.delete(),
            })
            .catchError((_) {}),
      );
    }
    notifyListeners();
  }

  // ------------------------------------------------------------- preferenze

  bool flag(String k) => _prefs.getBool(k) ?? false;
  Future<void> setFlag(String k, bool v) async {
    await _prefs.setBool(k, v);
    notifyListeners();
  }
}
