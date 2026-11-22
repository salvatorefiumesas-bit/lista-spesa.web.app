import 'package:flutter_test/flutter_test.dart';
import 'package:lista_spesa/catalogo.dart';
import 'package:lista_spesa/models.dart';
import 'package:lista_spesa/nutrizione.dart';
import 'package:lista_spesa/ricette.dart';

const _cibo = {
  Reparto.fruttaVerdura, Reparto.panetteria, Reparto.carne, Reparto.pesce,
  Reparto.salumiFormaggi, Reparto.gastronomia, Reparto.latticiniUova,
  Reparto.pastaRiso, Reparto.surgelati, Reparto.snackAperitivo,
};

void main() {
  final ids = {for (final p in catalogoBase) p.id};

  test('ogni ingrediente delle ricette è nel catalogo', () {
    final mancanti = {
      for (final r in ricette)
        for (final i in r.ingredienti)
          if (!ids.contains(i.prodottoId)) '${r.id}: ${i.prodottoId}',
    };
    expect(mancanti, isEmpty);
  });

  test('le ricette hanno id unici', () {
    final r = ricette.map((r) => r.id).toList();
    expect(r.toSet().length, r.length);
  });

  test('ogni prodotto alimentare ha le calorie', () {
    final senza = [
      for (final p in catalogoBase)
        if (_cibo.contains(p.reparto) && nutrizioneDi(p.id) == null) p.id,
    ];
    expect(senza, isEmpty);
  });

  test('la tabella calorie non ha prodotti inesistenti', () {
    // ogni ingrediente con calorie (tranne il caffè, che non si mangia)
    for (final r in ricette) {
      for (final i in r.ingredienti) {
        if (i.prodottoId == 'caffe') continue;
        expect(nutrizioneDi(i.prodottoId), isNotNull, reason: '${r.id} ${i.prodottoId}');
      }
    }
  });

  test('calorie a porzione sensate (80–1.400 kcal)', () {
    final strane = [
      for (final r in ricette)
        if (r.kcalPorzione < 80 || r.kcalPorzione > 1400) '${r.nome}: ${r.kcalPorzione}',
    ];
    expect(strane, isEmpty);
  });

  test('esempi di calorie', () {
    final carbonara = ricette.firstWhere((r) => r.id == 'carbonara');
    expect(carbonara.kcalPorzione, inInclusiveRange(550, 800));
    expect(formatoPeso(1500), '1,5 kg');
    expect(formatoPeso(750), '750 g');
    expect(formatoPeso(1000, liquido: true), '1 l');
    expect(formatoKcal(12300), '12.300 kcal');
    final v = Voce(id: 'x', prodottoId: 'pasta', nome: 'Pasta', reparto: Reparto.pastaRiso, emoji: '', creata: 0, grammi: 500);
    expect(kcalDi(v), 1775);
    final u = Voce(id: 'y', prodottoId: 'uova', nome: 'Uova', reparto: Reparto.latticiniUova, emoji: '', creata: 0, quantita: 6);
    expect(grammiDi(u), 330);
  });

  test('stampa riepilogo', () {
    final perCat = <CategoriaRicetta, int>{};
    for (final r in ricette) {
      perCat[r.categoria] = (perCat[r.categoria] ?? 0) + 1;
    }
    // ignore: avoid_print
    print('RICETTE ${ricette.length} $perCat');
    for (final r in ricette.take(400)) {
      // ignore: avoid_print
      print('KCAL ${r.kcalPorzione.toString().padLeft(5)}  ${r.nome}');
    }
  });
}
