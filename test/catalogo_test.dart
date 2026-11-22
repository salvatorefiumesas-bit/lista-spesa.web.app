import 'package:flutter_test/flutter_test.dart';
import 'package:lista_spesa/catalogo.dart';
import 'package:lista_spesa/models.dart';

void main() {
  test('ogni prodotto del catalogo ha un id unico', () {
    final ids = catalogoBase.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('indovina il reparto dei prodotti scritti a mano', () {
    expect(indovinaReparto('deodorante', catalogoBase), Reparto.igienePersonale);
    expect(indovinaReparto('Dash', catalogoBase), Reparto.puliziaCasa);
    expect(indovinaReparto('fettine di manzo', catalogoBase), Reparto.carne);
    expect(indovinaReparto('Caffe', catalogoBase), Reparto.colazioneDolci);
    expect(indovinaReparto('qualcosa di strano', catalogoBase), Reparto.altro);
  });

  test('voci uguali hanno la stessa chiave anche con maiuscole diverse', () {
    Voce v(String nome, String? marca) =>
        Voce(id: nome, nome: nome, marca: marca, reparto: Reparto.altro, emoji: '', creata: 0);
    expect(v('Latte', 'Granarolo').chiave, v('latte', 'granarolo').chiave);
    expect(v('Latte', 'Granarolo').chiave, isNot(v('Latte', null).chiave));
  });

  test('una voce sopravvive al salvataggio', () {
    final v = Voce(
      id: 'x', nome: 'Pasta', marca: 'Barilla', reparto: Reparto.pastaRiso,
      emoji: '🍝', quantita: 3, presa: true, presaDa: 'Salvatore', creata: 5,
    );
    final w = Voce.fromMap(v.toMap());
    expect(w.reparto, Reparto.pastaRiso);
    expect(w.quantita, 3);
    expect(w.presa, isTrue);
    expect(w.presaDa, 'Salvatore');
  });
}
