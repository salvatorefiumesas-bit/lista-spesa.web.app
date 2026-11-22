import 'models.dart';

/// Valori nutrizionali indicativi (medie delle tabelle di composizione
/// degli alimenti), usati per stimare le calorie.
class Nutrizione {
  const Nutrizione(
    this.kcal,
    this.confezione, {
    this.pezzo,
    this.liquido = false,
  });

  /// Calorie per 100 g (o 100 ml per i liquidi).
  final int kcal;

  /// Peso (o volume) di una confezione tipica, in g o ml.
  final int confezione;

  /// Peso di un singolo pezzo (es. un uovo, una mela), se ha senso.
  final int? pezzo;
  final bool liquido;

  /// Peso di "1" quando si compra a pezzi/confezioni.
  int get unita => pezzo ?? confezione;

  int kcalPer(num grammi) => (kcal * grammi / 100).round();
}

Nutrizione? nutrizioneDi(String? prodottoId) =>
    prodottoId == null ? null : _tabella[prodottoId];

/// Grammi totali di una voce (dal peso scelto o dai pezzi/confezioni).
int? grammiDi(Voce v) {
  if (v.grammi != null) return v.grammi;
  final n = nutrizioneDi(v.prodottoId);
  return n == null ? null : n.unita * v.quantita;
}

int? kcalDi(Voce v) {
  final n = nutrizioneDi(v.prodottoId);
  final g = grammiDi(v);
  return n == null || g == null ? null : n.kcalPer(g);
}

String _migliaia(int n) {
  final s = n.abs().toString();
  final b = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

String formatoKcal(int kcal) => '${_migliaia(kcal)} kcal';

/// 750 g, 1,5 kg, 330 ml, 1 l …
String formatoPeso(int grammi, {bool liquido = false}) {
  final (piccola, grande) = liquido ? ('ml', 'l') : ('g', 'kg');
  if (grammi < 1000) return '$grammi $piccola';
  final v = grammi / 1000;
  final testo = v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(v * 10 == (v * 10).roundToDouble() ? 1 : 2);
  return '${testo.replaceAll('.', ',')} $grande';
}

// Formato: id kcal/100g confezione [pz=peso pezzo] [ml]
final Map<String, Nutrizione> _tabella = _leggi('''
mele 52 1000 pz=180
banane 89 1000 pz=150
arance 47 1000 pz=200
limoni 29 500 pz=100
pomodori 18 1000 pz=150
insalata 15 125
patate 77 1000 pz=200
cipolle 40 1000 pz=150
aglio 149 50 pz=5
carote 41 1000 pz=80
zucchine 17 1000 pz=200
peperoni 26 1000 pz=200
frutta-stagione 50 1000 pz=150
pere 57 1000 pz=180
fragole 32 250
uva 69 500
kiwi 61 500 pz=80
ananas 50 1000
mandarini 53 1000 pz=80
pesche 39 1000 pz=150
albicocche 48 500 pz=40
ciliegie 63 500
anguria 30 4000
melone 34 1200
prugne 46 500 pz=40
mirtilli 57 125
avocado 160 400 pz=200
mango 60 300 pz=300
cocco 354 400
pompelmo 42 300 pz=300
melograno 83 250 pz=250
fichi 74 500 pz=50
cachi 70 1000 pz=200
melanzane 25 1000 pz=300
cetrioli 15 500 pz=250
broccoli 34 500
cavolfiore 25 800
cavolo 25 1000
spinaci 23 500
bietole 19 500
rucola 25 100
lattuga 15 300
radicchio 23 250
finocchi 31 1000 pz=300
sedano 16 400
porri 61 400 pz=200
cipollotti 32 150
carciofi 47 1000 pz=200
asparagi 20 500
fagiolini 31 500
funghi 22 250
zucca 26 1000
pannocchie 86 500 pz=250
patate-dolci 86 1000 pz=300
cime-rapa 22 1000
ravanelli 16 150
barbabietole 43 500
pomodorini 18 500
basilico 23 30
prezzemolo 36 30
erbe 50 30
zenzero 80 100
peperoncino-fresco 40 50 pz=10
verdure-pronte 25 400
pane 270 500
pancarre 265 400
piadine 300 400 pz=100
grissini 410 250
crackers 430 500
fette-biscottate 400 315
pane-integrale 240 500
pane-hamburger 270 300 pz=75
pane-tramezzini 265 400
pangrattato 350 400
focaccia 300 300
base-pizza 280 400 pz=200
pane-carasau 360 250
friselle 380 400
tortillas 310 250 pz=40
gallette 380 130
cornetti 410 300 pz=60
pane-senza-glutine 250 300
bruschette 410 120
pollo 110 400
macinato 200 500
bistecche 150 500 pz=250
salsiccia 300 400 pz=100
hamburger 230 400 pz=100
cotolette 230 400 pz=100
wurstel 270 250 pz=50
petto-tacchino 107 400
fesa-tacchino 107 400
fettine-tacchino 107 400
salsiccia-tacchino 180 400 pz=100
macinato-tacchino 150 400
cosce-tacchino 140 800
spezzatino-tacchino 120 500
arrosto-tacchino 130 800
hamburger-tacchino 160 400 pz=100
wurstel-tacchino 200 250 pz=50
pollo-intero 190 1500
cosce-pollo 180 800 pz=250
ali-pollo 200 600
fettine-pollo 110 400
macinato-pollo 140 400
wurstel-pollo 230 250 pz=50
spiedini 200 400 pz=100
cordon-bleu 250 300 pz=150
crocchette-pollo 260 300
fettine-manzo 130 400
spezzatino-manzo 140 500
arrosto-manzo 150 800
bollito 200 1000
tagliata 160 500
carpaccio 120 200
roast-beef 140 300
macinato-misto 250 500
braciole 200 600 pz=200
lonza 140 500
costine 290 800
filetto-maiale 130 500
pancetta-fresca 450 300
fettine-vitello 110 400
scaloppine 110 400
ossobuco 150 600 pz=300
agnello 230 1000
coniglio 120 1200
polpette 230 400
involtini 200 400 pz=80
fegato 140 400
trippa 90 500
salmone 185 400 pz=200
orata 120 400 pz=400
gamberi 85 300
merluzzo 80 400
cozze 85 1000
tonno-fresco 145 300
pesce-spada 110 300
calamari 70 500
polpo 60 1000
seppie 72 500
alici 100 500
sgombro 170 400 pz=300
sardine 130 500
baccala 95 500
trota 120 300 pz=300
sogliola 85 400
gamberoni 85 400
salmone-affumicato 160 100
surimi 100 200
frutti-mare 75 500
crudo 270 100
cotto 215 100
salame 400 100
mortadella 310 100
bresaola 150 80
grana 390 300
formaggio-fette 300 200 pz=20
fesa-tacchino-affettata 100 100
petto-pollo-affettato 100 100
speck 300 100
pancetta 400 150
guanciale 650 150
coppa 400 100
porchetta 300 150
cotechino 300 500
pecorino 390 200
gorgonzola 330 200
provolone 370 200
scamorza 330 250
fontina 340 200
asiago 360 200
emmental 380 200
edamer 350 200
taleggio 300 200
brie 330 200
feta 260 200
caciocavallo 400 300
grattugiato 390 100
lasagne-pronte 160 600
insalata-riso 160 400
pizza-fresca 250 400
pollo-arrosto 190 1000
hummus 280 200
olive-ascolane 300 250
arancini 220 300 pz=150
zuppe 50 600
piadina-farcita 280 200 pz=200
sushi 150 300
tramezzini 270 240 pz=120
primi-pronti 150 350
secondi-pronti 180 300
latte 46 1000 ml
yogurt 70 125
mozzarella 250 125
burro 750 250
uova 130 330 pz=55
ricotta 150 250
spalmabile 250 150
panna 300 200
latte-senza-lattosio 46 1000 ml
latte-vegetale 40 1000 ml
yogurt-greco 95 170
kefir 60 500 ml
stracchino 280 165
mascarpone 450 250
burrata 300 150
robiola 300 100
fiocchi-latte 100 150
besciamella 120 500
margarina 720 250
formaggini 280 140 pz=20
tofu 120 250
pasta-sfoglia 400 230
pasta 355 500
pasta-fresca 280 250
gnocchi 160 500
riso 350 1000
farina 345 1000
lievito 100 48 pz=16
spaghetti 355 500
penne 355 500
fusilli 355 500
rigatoni 355 500
linguine 355 500
farfalle 355 500
tagliatelle 370 250
sfoglie-lasagne 350 250
pasta-integrale 340 500
pasta-senza-glutine 355 400
pastina 355 500
tortellini 300 250
ravioli 260 250
orecchiette 355 500
couscous 360 500
orzo-perlato 350 500
quinoa 370 400
riso-basmati 350 1000
riso-risotti 350 1000
polenta 360 500
lenticchie 330 500
ceci-secchi 340 500
fagioli-secchi 310 500
passata 30 700
pelati 22 400
sugo 60 400
tonno 190 240 pz=80
olio-evo 899 1000
olio-semi 899 1000
aceto 20 500 ml
maionese 700 225
ketchup 110 500
legumi 100 240
pesto 450 190
ragu 100 400
concentrato 80 200
polpa-pomodoro 25 400
mais-scatola 90 300
piselli-scatola 70 280
fagioli-scatola 100 240
ceci-scatola 120 240
sottoli 150 280
sottaceti 30 300
capperi 30 100
acciughe-olio 200 80
sgombro-scatola 200 125
salmone-scatola 150 200
dado 250 100
senape 120 200
salsa-soia 60 150 ml
salse 300 200
aceto-balsamico 110 250 ml
pepe 250 50
origano 300 20
peperoncino 300 30
spezie 300 30
zafferano 300 1
burro-arachidi 600 350
biscotti 450 350
merendine 420 300 pz=35
cereali 380 375
crema-spalmabile 540 400
marmellata 250 340
zucchero 392 1000
miele 304 500
cioccolato 540 100
muesli 400 375
cacao 360 250
orzo-solubile 350 120
plumcake 400 330 pz=35
crostatine 400 240 pz=40
cornetti-confezionati 420 300 pz=50
preparati-torte 400 400
budino 120 200 pz=100
caramelle 390 150
gomme 230 30
wafer 520 175
barrette-cioccolato 500 50
panettone 380 1000
pandoro 410 1000
colomba 400 1000
zucchero-canna 380 1000
patatine 530 150
frutta-secca 600 200
olive 140 200
taralli 450 250
popcorn 380 100
arachidi 590 200
pistacchi 590 200
mandorle 600 200
salatini 460 150
tortilla-chips 490 200
barrette-cereali 400 150 pz=25
frutta-disidratata 300 200
verdure-surgelate 35 750
minestrone 40 1000
bastoncini 190 450 pz=25
pizza-surgelata 240 350
patatine-surgelate 170 750
gelato 210 500
spinaci-surgelati 25 450
piselli-surgelati 70 450
fagiolini-surgelati 30 450
sofficini 230 270 pz=50
filetti-pesce 80 400
gamberi-surgelati 80 300
fritto-misto 230 400
cotolette-surgelate 230 400 pz=100
lasagne-surgelate 150 600
primi-surgelati 130 550
croissant-surgelati 400 420 pz=70
frutti-bosco-surgelati 45 300
polpette-surgelate 220 400
coni-gelato 280 280 pz=70
ghiaccioli 80 240 pz=60
ghiaccio 0 1000
acqua-naturale 0 1500 ml
acqua-frizzante 0 1500 ml
succhi 45 1000 ml
bibite 42 1500 ml
te-freddo 30 1500 ml
birra 43 660 ml
vino 85 750 ml
aranciata 40 1500 ml
chinotto 40 1500 ml
cola-zero 0 1500 ml
acqua-tonica 35 1000 ml
succo-arancia 45 1000 ml
energy-drink 45 250 ml
sport-drink 25 500 ml
vino-rosso 85 750 ml
vino-bianco 80 750 ml
prosecco 80 750 ml
birra-analcolica 25 330 ml
amari 250 700 ml
aperitivi 120 1000 ml
limoncello 300 700 ml
superalcolici 230 700 ml
latte-bambini 67 500 ml
pappe 380 200
omogeneizzati 90 80 pz=80
biscotti-bimbi 430 360
succhi-bambini 50 125 ml
''');

Map<String, Nutrizione> _leggi(String testo) {
  final out = <String, Nutrizione>{};
  for (final riga in testo.split('\n')) {
    final p = riga.trim().split(RegExp(r'\s+'));
    if (p.length < 3) continue;
    int? pezzo;
    var liquido = false;
    for (final extra in p.skip(3)) {
      if (extra == 'ml') liquido = true;
      if (extra.startsWith('pz=')) pezzo = int.parse(extra.substring(3));
    }
    out[p[0]] = Nutrizione(
      int.parse(p[1]),
      int.parse(p[2]),
      pezzo: pezzo,
      liquido: liquido,
    );
  }
  return out;
}
