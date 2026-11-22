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
  StreamSubscription<Contenuto>? _sub;

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

  /// Riapre il collegamento con il server (tirando giù la lista): invia le
  /// modifiche in attesa e scarica quelle dell'altro telefono.
  Future<void> riconnetti() async {
    if (!inFamiglia) return;
    _archivio!.pausa();
    _archivio!.riprendi();
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  /// In background l'app non ascolta (niente letture inutili); quando torna
  /// aperta riprende e si aggiorna con una sola lettura.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _archivio?.riprendi();
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        _archivio?.pausa();
      default:
        break;
    }
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
    _sub?.cancel();
    if (_archivio != _locale) _archivio?.chiudi();
    _archivio = a;
    if (a is ArchivioFamiglia) {
      // Tolti dalla famiglia o famiglia inesistente: si torna alla lista
      // solo sul telefono.
      a.onAccessoNegato = () {
        if (_archivio == a) esciDallaFamiglia(avvisaServer: false);
      };
    }
    _sub = a.contenuto().listen((c) {
      voci = c.voci;
      _personali = c.prodotti;
      membri = c.nomi;
      statoSync = c.sync;
      notifyListeners();
    });
    a.riprendi();
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
    _archivio!.salvaProdotto(
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
    _archivio!.salvaProdotto(p);
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
      _archivio!.aggiornaVoce(uguale.id, const {}, incremento: quantita);
    } else {
      _archivio!.aggiungiVoce(nuova);
    }
  }

  Future<void> segna(Voce v, bool presa) async =>
      _archivio!.aggiornaVoce(v.id, {
        'presa': presa,
        'presaDa': presa && nome.isNotEmpty ? nome : null,
        'presaIl': presa ? DateTime.now().millisecondsSinceEpoch : null,
      });

  Future<void> cambiaQuantita(Voce v, int q) async =>
      q <= 0 ? elimina(v) : _archivio!.aggiornaVoce(v.id, {'quantita': q});

  Future<void> cambiaNota(Voce v, String nota) async =>
      _archivio!.aggiornaVoce(v.id, {'nota': nota.trim()});

  Future<void> elimina(Voce v) async => _archivio!.eliminaVoce(v.id);

  Future<void> ripristina(Voce v) async => _archivio!.aggiungiVoce(v);

  Future<void> togliPresi() async {
    for (final v in presi) {
      _archivio!.eliminaVoce(v.id);
    }
  }

  // ----------------------------------------------------------------- persona

  Future<void> impostaNome(String n) async {
    nome = n.trim();
    await _prefs.setString('nome', nome);
    if (inFamiglia && uid != null) {
      unawaited(
        _docFamiglia(codiceFamiglia!)
            .update({
              FieldPath(['nomi', uid!]): nome,
            })
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
    // Se per caso il codice esiste già le regole rifiutano la scrittura
    // (sarebbe la famiglia di altri): si riprova con un altro codice.
    Object? errore;
    for (var tentativo = 0; tentativo < 5; tentativo++) {
      final codice = _nuovoCodice();
      try {
        await _docFamiglia(codice).set({
          'codice': codice,
          'versione': 2,
          'membri': [uid],
          'nomi': {uid!: nome},
          'voci': <String, dynamic>{},
          'prodotti': <String, dynamic>{},
          'creata': FieldValue.serverTimestamp(),
        });
        await _entra(codice);
        return null;
      } catch (e) {
        errore = e;
      }
    }
    return 'Non è stato possibile creare la famiglia ($errore)';
  }

  Future<String?> entraInFamiglia(String codiceScritto) async {
    final codice = pulisciCodice(codiceScritto);
    if (!condivisioneDisponibile || uid == null) {
      return 'Condivisione non disponibile';
    }
    if (codice.length != 6) return 'Il codice ha 6 caratteri';
    try {
      // Si entra aggiungendo sé stessi: la lista si può leggere solo dopo.
      await _docFamiglia(codice).update({
        'membri': FieldValue.arrayUnion([uid]),
        FieldPath(['nomi', uid!]): nome,
      });
      await _entra(codice);
      await _togliVecchiAccessi(codice);
      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'not-found' || e.code == 'permission-denied') {
        return 'Codice non trovato: controlla e riprova';
      }
      return 'Non è stato possibile entrare (${e.message})';
    } catch (e) {
      return 'Non è stato possibile entrare ($e)';
    }
  }

  /// Entra nella famiglia portando la lista che c'era solo sul telefono.
  Future<void> _entra(String codice) async {
    codiceFamiglia = codice;
    await _prefs.setString('famiglia', codice);
    final fam = ArchivioFamiglia(codice);
    for (final v in _locale.tutteLeVoci) {
      fam.aggiungiVoce(v);
    }
    for (final p in _locale.tuttiIProdotti) {
      fam.salvaProdotto(p);
    }
    _locale.svuota();
    _collega(fam);
    await fam.invia();
    notifyListeners();
  }

  /// Chi disinstalla e reinstalla l'app riceve un nuovo accesso anonimo:
  /// rientrando con il codice, il vecchio accesso con lo stesso nome resta
  /// nella famiglia e la persona compare due volte. Qui lo si toglie.
  Future<void> _togliVecchiAccessi(String codice) async {
    if (nome.isEmpty || uid == null) return;
    try {
      final doc = await _docFamiglia(codice).get();
      final nomi = Map<String, dynamic>.from(doc.data()?['nomi'] as Map? ?? {});
      final vecchi = [
        for (final e in nomi.entries)
          if (e.key != uid && normalizza('${e.value}') == normalizza(nome))
            e.key,
      ];
      if (vecchi.isNotEmpty) await _rimuovi(codice, vecchi);
    } catch (_) {}
  }

  Future<void> _rimuovi(String codice, List<String> ids) =>
      _docFamiglia(codice).update({
        'membri': FieldValue.arrayRemove(ids),
        for (final id in ids) FieldPath(['nomi', id]): FieldValue.delete(),
      });

  /// Toglie una persona dalla famiglia (es. un vecchio telefono).
  Future<String?> rimuoviMembro(String id) async {
    final c = codiceFamiglia;
    if (c == null || id == uid) return null;
    try {
      await _rimuovi(c, [id]);
      return null;
    } catch (e) {
      return 'Non è stato possibile rimuoverlo ($e)';
    }
  }

  Future<void> esciDallaFamiglia({bool avvisaServer = true}) async {
    final c = codiceFamiglia;
    codiceFamiglia = null;
    await _prefs.remove('famiglia');
    _collega(_locale);
    if (avvisaServer && c != null && uid != null) {
      unawaited(
        _docFamiglia(c)
            .update({
              'membri': FieldValue.arrayRemove([uid]),
              FieldPath(['nomi', uid!]): FieldValue.delete(),
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
