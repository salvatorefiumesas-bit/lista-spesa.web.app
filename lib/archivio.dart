import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Tutto ciò che serve alla lista: voci, prodotti personali e nomi.
class Contenuto {
  const Contenuto({
    this.voci = const [],
    this.prodotti = const [],
    this.nomi = const {},
    this.sync = StatoSync.ok,
  });

  final List<Voce> voci;
  final List<Prodotto> prodotti;
  final Map<String, String> nomi;
  final StatoSync sync;
}

enum StatoSync {
  /// Primo collegamento in corso.
  collegamento,

  /// Tutto inviato e aggiornato.
  ok,

  /// Ci sono modifiche fatte qui che non sono ancora arrivate al server.
  invio,

  /// Senza rete: si vede l'ultima copia salvata sul telefono.
  offline,
}

/// Dove vengono salvati lista e prodotti personali.
abstract class Archivio {
  Stream<Contenuto> contenuto();
  void aggiungiVoce(Voce v);

  /// Cambia solo alcuni campi di una voce (e/o ne aumenta la quantità):
  /// due modifiche contemporanee da telefoni diversi non si annullano.
  void aggiornaVoce(
    String id,
    Map<String, dynamic> campi, {
    int incremento = 0,
  });
  void eliminaVoce(String id);
  void salvaProdotto(Prodotto p);

  /// Manda subito le modifiche in attesa.
  Future<void> invia() async {}

  /// App in background: smette di ascoltare (niente letture inutili).
  void pausa() {}

  /// App di nuovo aperta: riprende ad ascoltare.
  void riprendi() {}
  void chiudi() {}
}

// ===================================================================== locale

/// Solo su questo telefono (quando la condivisione non è attiva).
class ArchivioLocale extends Archivio {
  ArchivioLocale(this._prefs) {
    _voci = _leggi('voci', Voce.fromMap);
    _prodotti = _leggi('prodotti', Prodotto.fromMap);
  }

  final SharedPreferences _prefs;
  late Map<String, Voce> _voci;
  late Map<String, Prodotto> _prodotti;
  final _ctrl = StreamController<Contenuto>.broadcast();

  Map<String, T> _leggi<T>(String k, T Function(Map<String, dynamic>) da) {
    try {
      final raw = _prefs.getString(k);
      if (raw == null) return {};
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return {for (final m in list) m['id'] as String: da(m)};
    } catch (_) {
      return {};
    }
  }

  List<Voce> get tutteLeVoci => _voci.values.toList();
  List<Prodotto> get tuttiIProdotti => _prodotti.values.toList();

  Contenuto get _ora => Contenuto(
    voci: _voci.values.toList(),
    prodotti: _prodotti.values.toList(),
  );

  @override
  Stream<Contenuto> contenuto() async* {
    yield _ora;
    yield* _ctrl.stream;
  }

  void _salva() {
    _ctrl.add(_ora);
    _prefs.setString(
      'voci',
      jsonEncode([for (final v in _voci.values) v.toMap()]),
    );
    _prefs.setString(
      'prodotti',
      jsonEncode([for (final p in _prodotti.values) p.toMap()]),
    );
  }

  @override
  void aggiungiVoce(Voce v) {
    _voci[v.id] = v;
    _salva();
  }

  @override
  void aggiornaVoce(
    String id,
    Map<String, dynamic> campi, {
    int incremento = 0,
  }) {
    final v = _voci[id];
    if (v == null) return;
    final m = {...v.toMap(), ...campi};
    m['quantita'] = (m['quantita'] as int) + incremento;
    _voci[id] = Voce.fromMap(m);
    _salva();
  }

  @override
  void eliminaVoce(String id) {
    _voci.remove(id);
    _salva();
  }

  void svuota() {
    _voci.clear();
    _prodotti.clear();
    _salva();
  }

  @override
  void salvaProdotto(Prodotto p) {
    _prodotti[p.id] = p;
    _salva();
  }

  @override
  void chiudi() => _ctrl.close();
}

// =================================================================== famiglia

/// Modifiche a una voce non ancora inviate al server.
class _Attesa {
  Map<String, dynamic>? completa; // voce nuova (o ripristinata)
  final campi = <String, dynamic>{};
  int incremento = 0;
  bool elimina = false;
}

/// Lista condivisa con la famiglia tramite Firestore.
///
/// Per spendere meno letture possibili tutta la lista sta in UN documento
/// (`famiglie/{codice}`): aprire l'app costa 1 lettura qualunque sia il
/// numero di prodotti, ogni modifica dell'altro telefono 1 lettura.
/// In più le modifiche fatte a raffica (es. 3 spunte di fila) partono
/// insieme dopo un attimo, e con l'app in background non si ascolta.
class ArchivioFamiglia extends Archivio {
  ArchivioFamiglia(this.codice);

  final String codice;
  static const _ritardoInvio = Duration(milliseconds: 800);
  static const _pulisciPresiDopo = Duration(hours: 24);

  DocumentReference<Map<String, dynamic>> get _doc =>
      FirebaseFirestore.instance.collection('famiglie').doc(codice);

  final _ctrl = StreamController<Contenuto>.broadcast();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  Map<String, dynamic>? _server;
  StatoSync _sync = StatoSync.collegamento;
  final _attesa = <String, _Attesa>{};
  final _prodottiInAttesa = <String, Map<String, dynamic>>{};
  Timer? _timer;
  bool _migrazioneFatta = false;
  bool _puliziaFatta = false;
  bool _chiuso = false;

  /// Chiamata quando il server rifiuta l'accesso (es. usciti dalla famiglia).
  void Function()? onAccessoNegato;

  @override
  Stream<Contenuto> contenuto() async* {
    yield _calcola();
    yield* _ctrl.stream;
  }

  @override
  void riprendi() {
    if (_sub != null || _chiuso) return;
    _sub = _doc
        .snapshots(includeMetadataChanges: true)
        .listen(
          (s) {
            _server = s.data();
            _sync = s.metadata.hasPendingWrites
                ? StatoSync.invio
                : (s.metadata.isFromCache ? StatoSync.offline : StatoSync.ok);
            if (_server != null && !s.metadata.isFromCache) {
              _migra();
              _pulisci();
            }
            _emetti();
          },
          onError: (Object e) {
            if (e is FirebaseException && e.code == 'permission-denied') {
              onAccessoNegato?.call();
            }
          },
        );
  }

  @override
  void pausa() {
    invia();
    _sub?.cancel();
    _sub = null;
  }

  void _emetti() {
    if (!_ctrl.isClosed) _ctrl.add(_calcola());
  }

  /// Lista vista dal telefono: quella del server + le modifiche in attesa.
  Contenuto _calcola() {
    final d = _server ?? const <String, dynamic>{};
    final voci = <String, Map<String, dynamic>>{};
    (d['voci'] as Map? ?? const {}).forEach((id, m) {
      if (m is Map && m['nome'] != null) {
        voci[id as String] = Map<String, dynamic>.from(m)..['id'] = id;
      }
    });
    _attesa.forEach((id, a) {
      if (a.elimina) {
        voci.remove(id);
        return;
      }
      final base = a.completa ?? voci[id];
      if (base == null) return;
      final m = {...base, ...a.campi};
      m['quantita'] = ((m['quantita'] as num?)?.toInt() ?? 1) + a.incremento;
      voci[id] = m;
    });

    final prodotti = <String, Map<String, dynamic>>{};
    (d['prodotti'] as Map? ?? const {}).forEach((id, m) {
      if (m is Map && m['nome'] != null) {
        prodotti[id as String] = Map<String, dynamic>.from(m)..['id'] = id;
      }
    });
    prodotti.addAll(_prodottiInAttesa);

    return Contenuto(
      voci: [for (final m in voci.values) Voce.fromMap(m)],
      prodotti: [for (final m in prodotti.values) Prodotto.fromMap(m)],
      nomi: Map<String, String>.from(d['nomi'] as Map? ?? const {}),
      sync: _attesa.isNotEmpty || _prodottiInAttesa.isNotEmpty
          ? StatoSync.invio
          : _sync,
    );
  }

  void _programma() {
    _emetti();
    _timer?.cancel();
    _timer = Timer(_ritardoInvio, invia);
  }

  @override
  void aggiungiVoce(Voce v) {
    _attesa[v.id] = _Attesa()..completa = v.toMap();
    _programma();
  }

  @override
  void aggiornaVoce(
    String id,
    Map<String, dynamic> campi, {
    int incremento = 0,
  }) {
    final a = _attesa.putIfAbsent(id, _Attesa.new);
    if (a.elimina) return;
    if (campi.containsKey('quantita')) a.incremento = 0;
    a.campi.addAll(campi);
    a.incremento += incremento;
    _programma();
  }

  @override
  void eliminaVoce(String id) {
    _attesa[id] = _Attesa()..elimina = true;
    _programma();
  }

  @override
  void salvaProdotto(Prodotto p) {
    _prodottiInAttesa[p.id] = p.toMap();
    _programma();
  }

  /// Trasforma le modifiche in attesa in UN solo aggiornamento del documento.
  @override
  Future<void> invia() async {
    _timer?.cancel();
    if (_attesa.isEmpty && _prodottiInAttesa.isEmpty) return;
    final dati = <Object, Object?>{};
    _attesa.forEach((id, a) {
      if (a.elimina) {
        dati[FieldPath(['voci', id])] = FieldValue.delete();
      } else if (a.completa != null) {
        final m = {...a.completa!, ...a.campi}..remove('id');
        m['quantita'] = ((m['quantita'] as num?)?.toInt() ?? 1) + a.incremento;
        dati[FieldPath(['voci', id])] = m;
      } else {
        a.campi.forEach((k, v) => dati[FieldPath(['voci', id, k])] = v);
        if (a.incremento != 0) {
          final q = a.campi['quantita'];
          dati[FieldPath(['voci', id, 'quantita'])] = q is num
              ? q + a.incremento
              : FieldValue.increment(a.incremento);
        }
      }
    });
    _prodottiInAttesa.forEach((id, m) {
      dati[FieldPath(['prodotti', id])] = {...m}..remove('id');
    });
    _attesa.clear();
    _prodottiInAttesa.clear();
    // Firestore applica subito la modifica alla copia sul telefono e la
    // manda al server appena c'è rete: non serve aspettare la risposta.
    unawaited(_doc.update(dati).catchError((_) {}));
  }

  /// Toglie da sola le voci nel carrello da più di un giorno e gli eventuali
  /// resti di voci cancellate, così il documento resta leggero.
  void _pulisci() {
    if (_puliziaFatta) return;
    _puliziaFatta = true;
    final limite = DateTime.now()
        .subtract(_pulisciPresiDopo)
        .millisecondsSinceEpoch;
    final voci = _server?['voci'] as Map? ?? const {};
    voci.forEach((id, m) {
      if (m is! Map) return;
      final vecchia =
          m['presa'] == true && ((m['presaIl'] as num?)?.toInt() ?? 0) < limite;
      if (m['nome'] == null || vecchia) eliminaVoce(id as String);
    });
  }

  /// Le famiglie create con la prima versione dell'app avevano un documento
  /// per ogni voce: li sposta una volta sola dentro il documento famiglia.
  Future<void> _migra() async {
    if (_migrazioneFatta || _server?['versione'] == 2) return;
    _migrazioneFatta = true;
    try {
      final vecchieVoci = await _doc.collection('voci').get();
      final vecchiProdotti = await _doc.collection('prodotti').get();
      final dati = <Object, Object?>{'versione': 2};
      for (final d in vecchieVoci.docs) {
        dati[FieldPath(['voci', d.id])] = {...d.data()}..remove('id');
      }
      for (final d in vecchiProdotti.docs) {
        dati[FieldPath(['prodotti', d.id])] = {...d.data()}..remove('id');
      }
      await _doc.update(dati);
      final batch = FirebaseFirestore.instance.batch();
      for (final d in [...vecchieVoci.docs, ...vecchiProdotti.docs]) {
        batch.delete(d.reference);
      }
      await batch.commit();
    } catch (_) {
      _migrazioneFatta = false;
    }
  }

  @override
  void chiudi() {
    invia();
    _chiuso = true;
    _sub?.cancel();
    _ctrl.close();
  }
}
