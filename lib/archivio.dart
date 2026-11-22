import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Dove vengono salvati lista e prodotti personali.
abstract class Archivio {
  Stream<List<Voce>> voci();
  Stream<List<Prodotto>> prodotti();
  Future<void> salvaVoce(Voce v);
  Future<void> eliminaVoci(Iterable<String> ids);
  Future<void> salvaProdotto(Prodotto p);
  void chiudi() {}
}

/// Solo su questo telefono (quando la condivisione non è attiva).
class ArchivioLocale extends Archivio {
  ArchivioLocale(this._prefs) {
    _voci = _leggi('voci', Voce.fromMap);
    _prodotti = _leggi('prodotti', Prodotto.fromMap);
  }

  final SharedPreferences _prefs;
  late Map<String, Voce> _voci;
  late Map<String, Prodotto> _prodotti;
  final _vociCtrl = StreamController<List<Voce>>.broadcast();
  final _prodCtrl = StreamController<List<Prodotto>>.broadcast();

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

  @override
  Stream<List<Voce>> voci() async* {
    yield _voci.values.toList();
    yield* _vociCtrl.stream;
  }

  @override
  Stream<List<Prodotto>> prodotti() async* {
    yield _prodotti.values.toList();
    yield* _prodCtrl.stream;
  }

  Future<void> _scriviVoci() async {
    _vociCtrl.add(_voci.values.toList());
    await _prefs.setString(
        'voci', jsonEncode([for (final v in _voci.values) v.toMap()]));
  }

  @override
  Future<void> salvaVoce(Voce v) {
    _voci[v.id] = v;
    return _scriviVoci();
  }

  @override
  Future<void> eliminaVoci(Iterable<String> ids) {
    for (final id in ids) {
      _voci.remove(id);
    }
    return _scriviVoci();
  }

  @override
  Future<void> salvaProdotto(Prodotto p) async {
    _prodotti[p.id] = p;
    _prodCtrl.add(_prodotti.values.toList());
    await _prefs.setString(
        'prodotti', jsonEncode([for (final p in _prodotti.values) p.toMap()]));
  }

  @override
  void chiudi() {
    _vociCtrl.close();
    _prodCtrl.close();
  }
}

/// Condiviso in tempo reale con la famiglia tramite Firestore.
class ArchivioFamiglia extends Archivio {
  ArchivioFamiglia(this.codice);

  final String codice;
  DocumentReference<Map<String, dynamic>> get _fam =>
      FirebaseFirestore.instance.collection('famiglie').doc(codice);

  @override
  Stream<List<Voce>> voci() => _fam
      .collection('voci')
      .snapshots()
      .map((s) => [for (final d in s.docs) Voce.fromMap(d.data())]);

  @override
  Stream<List<Prodotto>> prodotti() => _fam
      .collection('prodotti')
      .snapshots()
      .map((s) => [for (final d in s.docs) Prodotto.fromMap(d.data())]);

  // Non si attende la conferma del server: Firestore salva subito sul
  // telefono e sincronizza appena c'è rete (utile al supermercato).
  @override
  Future<void> salvaVoce(Voce v) async {
    unawaited(_fam.collection('voci').doc(v.id).set(v.toMap()));
  }

  @override
  Future<void> eliminaVoci(Iterable<String> ids) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final id in ids) {
      batch.delete(_fam.collection('voci').doc(id));
    }
    unawaited(batch.commit());
  }

  @override
  Future<void> salvaProdotto(Prodotto p) async {
    unawaited(_fam.collection('prodotti').doc(p.id).set(p.toMap()));
  }
}
