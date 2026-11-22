import 'catalogo.dart';
import 'models.dart';
import 'nutrizione.dart';

enum CategoriaRicetta {
  primi('Primi', '🍝'),
  secondiCarne('Secondi di carne', '🍖'),
  secondiPesce('Secondi di pesce', '🐟'),
  piattiUnici('Piatti unici e uova', '🍳'),
  zuppe('Zuppe e minestre', '🥣'),
  insalate('Insalatone', '🥗'),
  pizze('Pizze, panini e torte salate', '🍕'),
  contorni('Contorni', '🥦'),
  dolci('Dolci e frutta', '🍰');

  const CategoriaRicetta(this.nome, this.emoji);
  final String nome;
  final String emoji;
}

/// Un ingrediente di una ricetta: prodotto del catalogo e grammi a persona.
class Ingrediente {
  const Ingrediente(this.prodottoId, this.grammi);
  final String prodottoId;
  final int grammi;

  Prodotto get prodotto => catalogoBase.firstWhere((p) => p.id == prodottoId);

  /// Ingredienti che di solito si hanno già in casa: proposti ma non
  /// spuntati quando si aggiunge la ricetta alla lista.
  bool get dispensa => _dispensa.contains(prodottoId);

  int kcal(int persone) =>
      nutrizioneDi(prodottoId)?.kcalPer(grammi * persone) ?? 0;
}

const _dispensa = {
  'olio-evo',
  'olio-semi',
  'pepe',
  'aceto',
  'aceto-balsamico',
  'origano',
  'spezie',
  'peperoncino',
  'zucchero',
  'farina',
  'dado',
  'pangrattato',
  'lievito',
  'salsa-soia',
  'zafferano',
};

class Ricetta {
  const Ricetta({
    required this.id,
    required this.nome,
    required this.emoji,
    required this.categoria,
    required this.minuti,
    required this.ingredienti,
  });

  final String id;
  final String nome;
  final String emoji;
  final CategoriaRicetta categoria;
  final int minuti;
  final List<Ingrediente> ingredienti;

  /// Calorie di una porzione (una persona), condimenti compresi.
  int get kcalPorzione => ingredienti.fold(0, (s, i) => s + i.kcal(1));

  int get grammiPorzione => ingredienti.fold(0, (s, i) => s + i.grammi);
}

/// Dosi a persona, in grammi (ml per i liquidi). 1 uovo ≈ 55 g.
final List<Ricetta> ricette = [
  ..._leggi(CategoriaRicetta.primi, '''
carbonara | Spaghetti alla carbonara | 🍝 | 20 | spaghetti:90, guanciale:35, uova:55, pecorino:15, pepe:1
amatriciana | Bucatini all'amatriciana | 🍝 | 25 | spaghetti:90, guanciale:35, pelati:120, pecorino:15, vino-bianco:10
cacio-pepe | Cacio e pepe | 🧀 | 15 | spaghetti:100, pecorino:40, pepe:2
aglio-olio | Aglio, olio e peperoncino | 🌶️ | 15 | spaghetti:100, aglio:5, olio-evo:15, peperoncino:1, prezzemolo:3
pomodoro-basilico | Pasta al pomodoro e basilico | 🍅 | 20 | penne:90, passata:120, olio-evo:10, basilico:2, grana:10
pesto | Pasta al pesto | 🌿 | 15 | fusilli:90, pesto:40, grana:5
norma | Pasta alla Norma | 🍆 | 35 | rigatoni:90, melanzane:150, passata:100, olio-semi:20, ricotta:25, basilico:2
arrabbiata | Penne all'arrabbiata | 🌶️ | 20 | penne:90, pelati:120, aglio:3, peperoncino:1, olio-evo:10, prezzemolo:2
puttanesca | Spaghetti alla puttanesca | 🫒 | 20 | spaghetti:90, pelati:120, olive:15, capperi:5, acciughe-olio:5, aglio:3, olio-evo:10
pasta-fagioli | Pasta e fagioli | 🫘 | 40 | pasta:60, fagioli-scatola:120, passata:50, carote:20, sedano:15, cipolle:20, pancetta:15, olio-evo:10
pasta-ceci | Pasta e ceci | 🫘 | 35 | pasta:60, ceci-scatola:120, passata:40, aglio:3, erbe:1, olio-evo:10
pasta-patate | Pasta e patate con provola | 🥔 | 40 | pasta:60, patate:150, cipolle:20, pancetta:15, provolone:25, pelati:40, olio-evo:10
vongole | Spaghetti alle vongole | 🐚 | 25 | spaghetti:90, cozze:250, aglio:3, olio-evo:12, prezzemolo:3, vino-bianco:20
scoglio | Spaghetti allo scoglio | 🦐 | 30 | spaghetti:90, frutti-mare:200, pomodorini:100, aglio:3, olio-evo:12, prezzemolo:3, vino-bianco:15
pasta-tonno | Pasta al tonno | 🐟 | 20 | penne:90, tonno:50, passata:100, cipolle:15, capperi:3, olio-evo:8
pasta-zucchine | Pasta con le zucchine | 🥒 | 20 | pasta:90, zucchine:150, cipolle:15, olio-evo:10, grana:10, basilico:2
zucchine-gamberi | Pasta zucchine e gamberi | 🦐 | 25 | pasta:90, zucchine:120, gamberi:80, aglio:3, olio-evo:10, prezzemolo:2
funghi-salsiccia | Pasta funghi e salsiccia | 🍄 | 25 | pasta:90, funghi:100, salsiccia:70, panna:30, aglio:2, olio-evo:5
panna-prosciutto | Pasta panna, prosciutto e piselli | 🥓 | 20 | farfalle:90, cotto:40, panna:50, piselli-surgelati:40, grana:10
pasta-salmone | Pasta al salmone | 🐟 | 20 | farfalle:90, salmone-affumicato:40, panna:50, cipolle:10
pasta-broccoli | Pasta con i broccoli | 🥦 | 25 | pasta:90, broccoli:200, aglio:3, acciughe-olio:5, olio-evo:12, peperoncino:1
cime-rapa | Orecchiette alle cime di rapa | 🥬 | 30 | orecchiette:90, cime-rapa:200, aglio:3, acciughe-olio:5, olio-evo:12
bolognese | Tagliatelle al ragù | 🍝 | 120 | tagliatelle:90, macinato-misto:80, passata:80, carote:15, sedano:10, cipolle:15, vino-rosso:15, olio-evo:8
lasagne | Lasagne alla bolognese | 🍝 | 90 | sfoglie-lasagne:60, macinato-misto:70, passata:80, besciamella:80, grana:15, carote:10, sedano:8, cipolle:10, olio-evo:5
tortellini-panna | Tortellini panna e prosciutto | 🥟 | 15 | tortellini:125, panna:40, cotto:30, grana:10
ravioli-burro | Ravioli burro e salvia | 🥟 | 15 | ravioli:150, burro:15, erbe:2, grana:10
gnocchi-pomodoro | Gnocchi alla sorrentina | 🥔 | 30 | gnocchi:200, passata:100, mozzarella:40, basilico:2, olio-evo:8
gnocchi-gorgonzola | Gnocchi al gorgonzola e noci | 🧀 | 15 | gnocchi:200, gorgonzola:50, panna:30, mandorle:10
milanese | Risotto alla milanese | 🍚 | 30 | riso-risotti:80, burro:15, grana:15, cipolle:15, zafferano:1, dado:5, vino-bianco:15
risotto-funghi | Risotto ai funghi | 🍄 | 30 | riso-risotti:80, funghi:120, cipolle:15, burro:10, grana:15, dado:5, vino-bianco:15
risotto-zucca | Risotto alla zucca | 🎃 | 35 | riso-risotti:80, zucca:150, cipolle:15, burro:10, grana:15, dado:5
risotto-mare | Risotto ai frutti di mare | 🦐 | 35 | riso-risotti:80, frutti-mare:150, aglio:3, olio-evo:10, vino-bianco:15, prezzemolo:3
risotto-asparagi | Risotto agli asparagi | 🥬 | 30 | riso-risotti:80, asparagi:120, cipolle:15, burro:10, grana:15, dado:5
pasta-forno | Pasta al forno | 🧀 | 50 | rigatoni:90, macinato-misto:50, passata:100, mozzarella:50, grana:15, olio-evo:5
pasta-fredda | Insalata di pasta | 🥗 | 20 | fusilli:80, pomodorini:100, mozzarella:50, tonno:40, olive:15, olio-evo:10, basilico:2
pomodorini-burrata | Pasta pomodorini e burrata | 🍅 | 20 | pasta:90, pomodorini:120, burrata:60, olio-evo:10, basilico:2
piselli-pancetta | Pasta piselli e pancetta | 🫛 | 20 | pasta:90, piselli-surgelati:80, pancetta:25, cipolle:15, olio-evo:5, grana:10
pasta-integrale-verdure | Pasta integrale alle verdure | 🥕 | 25 | pasta-integrale:80, zucchine:80, peperoni:60, pomodorini:60, olio-evo:10, basilico:2
pasta-lenticchie | Pasta e lenticchie | 🫘 | 40 | pasta:60, lenticchie:50, carote:20, sedano:15, cipolle:20, pelati:40, olio-evo:10
'''),
  ..._leggi(CategoriaRicetta.secondiCarne, '''
cotoletta | Cotoletta alla milanese | 🍗 | 25 | fettine-vitello:130, uova:30, pangrattato:30, burro:15, limoni:15
pollo-patate | Pollo al forno con patate | 🍗 | 60 | cosce-pollo:250, patate:200, olio-evo:12, erbe:2, aglio:3
pollo-piastra | Petto di pollo alla piastra | 🍗 | 15 | pollo:150, olio-evo:8, limoni:15, erbe:1
pollo-limone | Straccetti di pollo al limone | 🍋 | 20 | fettine-pollo:150, farina:10, burro:10, limoni:30
pollo-curry | Pollo al curry con riso | 🍛 | 30 | fettine-pollo:150, riso-basmati:70, panna:40, cipolle:20, spezie:3, olio-evo:8
scaloppine | Scaloppine al limone | 🍋 | 20 | scaloppine:130, farina:10, burro:15, limoni:25
saltimbocca | Saltimbocca alla romana | 🥩 | 20 | fettine-vitello:130, crudo:30, erbe:2, burro:15, vino-bianco:15
polpette-sugo | Polpette al sugo | 🧆 | 50 | macinato-misto:120, uova:15, pangrattato:15, grana:10, passata:120, olio-evo:8
hamburger-patatine | Hamburger con patatine | 🍔 | 30 | hamburger:150, pane-hamburger:75, patatine-surgelate:150, lattuga:20, pomodori:40, formaggio-fette:20, ketchup:15
arrosto-tacchino | Arrosto di tacchino con patate | 🦃 | 70 | arrosto-tacchino:160, patate:200, olio-evo:12, erbe:2, vino-bianco:15
tacchino-limone | Petto di tacchino al limone | 🦃 | 20 | petto-tacchino:150, farina:8, olio-evo:10, limoni:20
salsiccia-tacchino-friarielli | Salsiccia di tacchino e friarielli | 🌭 | 30 | salsiccia-tacchino:150, cime-rapa:200, aglio:3, olio-evo:10, peperoncino:1
burger-tacchino | Burger di tacchino e insalata | 🦃 | 15 | hamburger-tacchino:150, insalata:60, pomodori:80, olio-evo:8
salsiccia-patate | Salsiccia e patate al forno | 🌭 | 50 | salsiccia:150, patate:200, olio-evo:10, erbe:2
bistecca | Bistecca ai ferri con insalata | 🥩 | 15 | bistecche:200, insalata:80, olio-evo:12
tagliata | Tagliata rucola e grana | 🥩 | 20 | tagliata:200, rucola:40, grana:15, olio-evo:10, aceto-balsamico:5
spezzatino | Spezzatino con piselli | 🍲 | 90 | spezzatino-manzo:180, piselli-surgelati:100, cipolle:30, passata:60, vino-rosso:20, olio-evo:10
brasato | Brasato al vino rosso | 🍷 | 150 | arrosto-manzo:180, carote:40, cipolle:30, sedano:20, vino-rosso:40, olio-evo:10
bollito | Bollito misto con verdure | 🥩 | 150 | bollito:220, carote:50, sedano:30, cipolle:40, patate:100
ossobuco | Ossobuco alla milanese | 🍖 | 100 | ossobuco:300, farina:10, burro:15, vino-bianco:30, carote:20, sedano:15, cipolle:20, limoni:5, prezzemolo:3
braciole | Braciole di maiale ai ferri | 🍖 | 15 | braciole:200, olio-evo:8, erbe:2
lonza-latte | Lonza al latte | 🥛 | 60 | lonza:180, latte:150, burro:10, farina:5
costine | Costine al forno con patate | 🍖 | 70 | costine:220, patate:200, olio-evo:10, erbe:2
involtini | Involtini al sugo | 🥩 | 40 | involtini:180, passata:80, olio-evo:8
cordon-bleu | Cordon bleu con insalata | 🍗 | 15 | cordon-bleu:150, insalata:60, olio-evo:8
coniglio | Coniglio alla cacciatora | 🐇 | 70 | coniglio:250, pelati:100, olive:15, cipolle:30, vino-rosso:30, olio-evo:12, erbe:2
fegato | Fegato alla veneziana | 🧅 | 30 | fegato:150, cipolle:150, burro:10, olio-evo:12, vino-bianco:15
polpettone | Polpettone con patate | 🍖 | 70 | macinato-misto:150, uova:20, pangrattato:15, grana:10, cotto:20, patate:150, olio-evo:10
wurstel-patatine | Würstel e patatine | 🌭 | 20 | wurstel:150, patatine-surgelate:150, senape:10
spiedini-verdure | Spiedini con verdure grigliate | 🍢 | 30 | spiedini:200, zucchine:100, melanzane:100, peperoni:80, olio-evo:12
agnello | Agnello al forno con patate | 🍖 | 80 | agnello:250, patate:200, olio-evo:12, erbe:2, aglio:3
carpaccio | Carpaccio rucola e grana | 🥩 | 10 | carpaccio:120, rucola:30, grana:20, olio-evo:12, limoni:15
vitello-tonnato | Vitello tonnato | 🥩 | 60 | arrosto-manzo:150, tonno:30, maionese:30, capperi:3, acciughe-olio:3
roast-beef | Roast beef con patate | 🥩 | 60 | roast-beef:150, patate:200, olio-evo:10
pollo-arrosto | Pollo arrosto e patate (da rosticceria) | 🍗 | 5 | pollo-arrosto:300, patate:150, olio-evo:8
'''),
  ..._leggi(CategoriaRicetta.secondiPesce, '''
salmone-forno | Salmone al forno con patate | 🐟 | 35 | salmone:180, patate:200, olio-evo:12, limoni:20, erbe:2
orata | Orata al forno | 🐟 | 40 | orata:350, patate:200, pomodorini:80, olive:10, olio-evo:12
merluzzo-umido | Merluzzo in umido | 🐟 | 30 | merluzzo:180, pelati:120, olive:15, capperi:3, aglio:3, olio-evo:10
calamari-fritti | Calamari fritti | 🦑 | 20 | calamari:200, farina:30, olio-semi:25, limoni:15
gamberoni | Gamberoni aglio e prezzemolo | 🦐 | 15 | gamberoni:200, aglio:3, olio-evo:12, prezzemolo:3, limoni:15
pesce-spada | Pesce spada alla griglia | 🐟 | 15 | pesce-spada:180, limoni:15, olio-evo:12, origano:1
tonno-scottato | Tonno scottato | 🐟 | 10 | tonno-fresco:180, salsa-soia:10, olio-evo:8
polpo-patate | Polpo e patate | 🐙 | 60 | polpo:200, patate:200, olio-evo:15, prezzemolo:3, limoni:10, aglio:2
cozze | Cozze alla marinara | 🦪 | 20 | cozze:500, aglio:4, olio-evo:12, prezzemolo:3, pane:50, vino-bianco:20
seppie-piselli | Seppie con piselli | 🦑 | 45 | seppie:200, piselli-surgelati:120, cipolle:20, passata:60, olio-evo:12
baccala | Baccalà in umido | 🐟 | 40 | baccala:200, pelati:120, cipolle:20, olive:10, olio-evo:12
bastoncini-pure | Bastoncini di pesce con purè | 🐟 | 25 | bastoncini:150, patate:200, latte:50, burro:10
trota | Trota al forno | 🐟 | 30 | trota:300, limoni:20, olio-evo:10, erbe:2
alici | Alici gratinate | 🐟 | 25 | alici:200, pangrattato:25, olio-evo:12, prezzemolo:3, aglio:2
platessa | Platessa impanata | 🐟 | 20 | sogliola:180, uova:20, pangrattato:25, olio-semi:15, limoni:10
insalata-mare | Insalata di mare | 🦐 | 30 | frutti-mare:200, sedano:30, carote:20, olio-evo:12, limoni:20, prezzemolo:3
poke | Poke di salmone | 🍣 | 25 | riso:80, salmone:120, avocado:70, cetrioli:50, mais-scatola:30, salsa-soia:10
sgombro-forno | Sgombro al forno | 🐟 | 30 | sgombro:300, pomodorini:80, olio-evo:8, origano:1
zuppa-pesce | Zuppa di pesce | 🍲 | 50 | frutti-mare:150, merluzzo:100, pelati:80, aglio:3, olio-evo:10, pane:40
'''),
  ..._leggi(CategoriaRicetta.piattiUnici, '''
frittata-zucchine | Frittata di zucchine | 🍳 | 20 | uova:110, zucchine:150, grana:15, olio-evo:8
frittata-patate | Frittata di patate e cipolle | 🍳 | 30 | uova:110, patate:150, cipolle:40, olio-evo:15
uova-pomodoro | Uova al pomodoro | 🍳 | 20 | uova:110, passata:150, olio-evo:8, pane:50, basilico:2
parmigiana | Parmigiana di melanzane | 🍆 | 90 | melanzane:250, passata:120, mozzarella:80, grana:20, olio-semi:25, basilico:2
peperoni-ripieni | Peperoni ripieni | 🫑 | 60 | peperoni:250, macinato-misto:70, pangrattato:15, grana:10, uova:15, olio-evo:10
zucchine-ripiene | Zucchine ripiene | 🥒 | 50 | zucchine:250, macinato-misto:60, grana:10, pangrattato:10, uova:15, passata:50, olio-evo:8
polenta-salsiccia | Polenta e salsiccia | 🌽 | 50 | polenta:80, salsiccia:150, passata:100, olio-evo:5
cous-cous | Cous cous di verdure e ceci | 🥘 | 25 | couscous:80, zucchine:80, peperoni:60, melanzane:60, ceci-scatola:50, olio-evo:12
chili | Chili con carne | 🌶️ | 50 | macinato-misto:100, fagioli-scatola:120, pelati:100, cipolle:30, peperoni:50, spezie:2, olio-evo:8, tortillas:40
wrap-pollo | Wrap di pollo | 🌯 | 15 | tortillas:80, fettine-pollo:120, lattuga:30, pomodori:50, formaggio-fette:20, salse:15
mozzarella-carrozza | Mozzarella in carrozza | 🧀 | 20 | pancarre:80, mozzarella:100, uova:55, latte:20, farina:10, olio-semi:20
tofu-verdure | Tofu saltato con verdure e riso | 🥡 | 20 | tofu:150, broccoli:100, carote:50, riso-basmati:60, salsa-soia:15, olio-evo:10
hummus-verdure | Hummus con verdure e pane | 🫘 | 10 | hummus:100, carote:100, cetrioli:100, pane:50
uova-sode-spinaci | Uova sode e spinaci | 🥚 | 15 | uova:110, spinaci:200, olio-evo:10, pane:40
quinoa-verdure | Quinoa con verdure | 🌾 | 25 | quinoa:70, zucchine:80, pomodorini:80, feta:30, olio-evo:10
'''),
  ..._leggi(CategoriaRicetta.zuppe, '''
minestrone | Minestrone | 🥣 | 30 | minestrone:250, pasta:40, olio-evo:8, grana:10
zuppa-lenticchie | Zuppa di lenticchie | 🫘 | 45 | lenticchie:70, carote:20, sedano:15, cipolle:20, pelati:40, olio-evo:10, pane:40
vellutata-zucca | Vellutata di zucca | 🎃 | 35 | zucca:250, patate:80, cipolle:20, panna:20, dado:3, olio-evo:8
passato-verdure | Passato di verdure | 🥕 | 40 | carote:80, patate:100, zucchine:100, cipolle:20, dado:3, olio-evo:8
pastina-brodo | Pastina in brodo | 🍜 | 15 | pastina:40, dado:5, grana:10
tortellini-brodo | Tortellini in brodo | 🥟 | 20 | tortellini:100, dado:5, grana:10
zuppa-legumi | Zuppa di farro e legumi | 🫘 | 50 | orzo-perlato:50, fagioli-scatola:80, ceci-scatola:60, carote:20, sedano:15, cipolle:20, olio-evo:10
vellutata-piselli | Vellutata di piselli | 🫛 | 25 | piselli-surgelati:200, patate:80, cipolle:20, dado:3, olio-evo:8
zuppa-pane | Pappa al pomodoro | 🍅 | 40 | pane:80, passata:200, aglio:3, basilico:3, olio-evo:15
'''),
  ..._leggi(CategoriaRicetta.insalate, '''
caprese | Insalata caprese | 🍅 | 10 | mozzarella:125, pomodori:200, basilico:3, olio-evo:12, origano:1
insalatona-tonno | Insalatona con tonno e uova | 🥗 | 15 | insalata:80, tonno:60, mais-scatola:40, uova:55, pomodori:100, olio-evo:12
greca | Insalata greca | 🫒 | 10 | pomodori:150, cetrioli:100, feta:70, olive:20, cipolle:20, olio-evo:12, origano:1
caesar | Caesar salad | 🥗 | 20 | lattuga:120, fettine-pollo:120, pane:30, grana:15, maionese:20
insalata-riso | Insalata di riso | 🍚 | 25 | riso:80, wurstel:30, tonno:30, emmental:30, sottaceti:30, mais-scatola:20, olio-evo:8
insalata-pollo | Insalata di pollo e avocado | 🥑 | 20 | pollo:120, avocado:70, insalata:60, pomodorini:80, olio-evo:10, limoni:10
insalata-salmone | Insalata con salmone affumicato | 🐟 | 10 | rucola:50, salmone-affumicato:60, avocado:50, limoni:10, olio-evo:10
bresaola-rucola | Bresaola, rucola e grana | 🥩 | 5 | bresaola:80, rucola:40, grana:20, olio-evo:10, limoni:10
'''),
  ..._leggi(CategoriaRicetta.pizze, '''
margherita | Pizza margherita fatta in casa | 🍕 | 30 | base-pizza:200, passata:80, mozzarella:125, olio-evo:8, basilico:2
capricciosa | Pizza capricciosa | 🍕 | 30 | base-pizza:200, passata:80, mozzarella:100, cotto:30, funghi:40, sottoli:30, olive:10, olio-evo:8
pizza-surgelata | Pizza surgelata | 🍕 | 15 | pizza-surgelata:350
torta-spinaci | Torta salata spinaci e ricotta | 🥧 | 50 | pasta-sfoglia:60, spinaci:150, ricotta:60, uova:25, grana:15
quiche | Quiche lorraine | 🥧 | 50 | pasta-sfoglia:60, pancetta:40, uova:40, panna:40, emmental:25
piadina | Piadina crudo e stracchino | 🫓 | 10 | piadine:100, crudo:40, stracchino:50, rucola:15
toast | Toast prosciutto e formaggio | 🥪 | 10 | pancarre:60, cotto:30, formaggio-fette:40, burro:5
focaccia-farcita | Focaccia con mortadella | 🫓 | 5 | focaccia:150, mortadella:50
panino-tacchino | Panino con fesa di tacchino | 🥪 | 5 | pane:100, fesa-tacchino-affettata:60, lattuga:20, pomodori:50, maionese:10
'''),
  ..._leggi(CategoriaRicetta.contorni, '''
patate-forno | Patate al forno | 🥔 | 45 | patate:250, olio-evo:12, erbe:2
pure | Purè di patate | 🥔 | 30 | patate:200, latte:60, burro:15, grana:5
insalata-mista | Insalata mista | 🥗 | 10 | insalata:80, pomodori:80, carote:40, olio-evo:10, aceto:5
verdure-grigliate | Verdure grigliate | 🍆 | 30 | zucchine:100, melanzane:100, peperoni:100, olio-evo:12
spinaci-burro | Spinaci al burro | 🥬 | 15 | spinaci:250, burro:10, grana:5
fagiolini-patate | Fagiolini e patate | 🫛 | 30 | fagiolini:150, patate:150, olio-evo:10
peperonata | Peperonata | 🫑 | 40 | peperoni:250, cipolle:50, pelati:60, olio-evo:12
caponata | Caponata | 🍆 | 60 | melanzane:200, sedano:30, cipolle:30, olive:15, capperi:5, pelati:60, aceto:10, zucchero:5, olio-semi:20
carciofi | Carciofi trifolati | 🥬 | 30 | carciofi:250, aglio:3, prezzemolo:3, olio-evo:12
funghi-trifolati | Funghi trifolati | 🍄 | 20 | funghi:250, aglio:3, prezzemolo:3, olio-evo:12
cavolfiore-gratinato | Cavolfiore gratinato | 🥦 | 40 | cavolfiore:250, besciamella:60, grana:15, pangrattato:5
finocchi-gratinati | Finocchi gratinati | 🥬 | 40 | finocchi:250, besciamella:50, grana:15
patatine | Patatine al forno | 🍟 | 25 | patatine-surgelate:200
broccoli-padella | Broccoli in padella | 🥦 | 20 | broccoli:250, aglio:3, olio-evo:10, peperoncino:1
'''),
  ..._leggi(CategoriaRicetta.dolci, '''
tiramisu | Tiramisù | 🍰 | 30 | mascarpone:60, uova:30, biscotti:35, zucchero:15, cacao:3, caffe:5
torta-mele | Torta di mele | 🍎 | 60 | farina:30, uova:25, zucchero:25, burro:15, mele:80, latte:15, lievito:2
macedonia | Macedonia di frutta | 🍓 | 15 | frutta-stagione:150, banane:50, mele:50, limoni:10, zucchero:5
yogurt-frutta | Yogurt con frutta e miele | 🥣 | 5 | yogurt-greco:170, frutti-bosco-surgelati:80, miele:10
pancake | Pancake | 🥞 | 20 | farina:40, uova:30, latte:60, zucchero:8, burro:5, lievito:2, miele:15
'''),
];

List<Ricetta> _leggi(CategoriaRicetta categoria, String testo) => [
  for (final riga in testo.split('\n'))
    if (riga.trim().isNotEmpty) _ricetta(categoria, riga),
];

Ricetta _ricetta(CategoriaRicetta categoria, String riga) {
  final p = riga.split('|').map((s) => s.trim()).toList();
  return Ricetta(
    id: p[0],
    nome: p[1],
    emoji: p[2],
    categoria: categoria,
    minuti: int.parse(p[3]),
    ingredienti: [
      for (final i in p[4].split(','))
        Ingrediente(i.split(':')[0].trim(), int.parse(i.split(':')[1].trim())),
    ],
  );
}
