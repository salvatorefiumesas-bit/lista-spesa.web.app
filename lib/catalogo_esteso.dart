import 'models.dart';

/// Altri prodotti del catalogo, scritti in forma compatta:
/// `id | Nome | emoji | Marca 1, Marca 2, …` (le marche sono facoltative).
final List<Prodotto> catalogoEsteso = [
  ..._leggi(Reparto.fruttaVerdura, '''
pere | Pere | 🍐
fragole | Fragole | 🍓
uva | Uva | 🍇
kiwi | Kiwi | 🥝 | Zespri
ananas | Ananas | 🍍 | Del Monte, Dole
mandarini | Mandarini e clementine | 🍊
pesche | Pesche e nettarine | 🍑
albicocche | Albicocche | 🍑
ciliegie | Ciliegie | 🍒
anguria | Anguria | 🍉
melone | Melone | 🍈
prugne | Prugne | 🫐
mirtilli | Mirtilli e frutti di bosco | 🫐
avocado | Avocado | 🥑
mango | Mango | 🥭
cocco | Cocco | 🥥
pompelmo | Pompelmo | 🍊
melograno | Melograno | 🍎
fichi | Fichi | 🍇
cachi | Cachi | 🍅
melanzane | Melanzane | 🍆
cetrioli | Cetrioli | 🥒
broccoli | Broccoli | 🥦
cavolfiore | Cavolfiore | 🥦
cavolo | Cavolo e verza | 🥬
spinaci | Spinaci | 🥬
bietole | Bietole | 🥬
rucola | Rucola | 🥬 | La Linea Verde, DimmidiSì
lattuga | Lattuga | 🥬
radicchio | Radicchio | 🥬
finocchi | Finocchi | 🥬
sedano | Sedano | 🥬
porri | Porri | 🧅
cipollotti | Cipollotti | 🧅
carciofi | Carciofi | 🥬
asparagi | Asparagi | 🥬
fagiolini | Fagiolini | 🫛
funghi | Funghi | 🍄
zucca | Zucca | 🎃
pannocchie | Pannocchie di mais | 🌽
patate-dolci | Patate dolci | 🍠
cime-rapa | Cime di rapa | 🥬
ravanelli | Ravanelli | 🥕
barbabietole | Barbabietole | 🥕
pomodorini | Pomodorini | 🍅
basilico | Basilico | 🌿
prezzemolo | Prezzemolo | 🌿
erbe | Rosmarino, salvia e aromi | 🌿
zenzero | Zenzero | 🫚
peperoncino-fresco | Peperoncino fresco | 🌶️
verdure-pronte | Verdure già pulite | 🥗 | La Linea Verde, DimmidiSì, Bonduelle
'''),
  ..._leggi(Reparto.panetteria, '''
pane-integrale | Pane integrale | 🍞
pane-hamburger | Panini per hamburger | 🍔 | Mulino Bianco, Harry's
pane-tramezzini | Pane per tramezzini | 🍞 | Mulino Bianco, Harry's
pangrattato | Pangrattato | 🍞
focaccia | Focaccia | 🫓
base-pizza | Base per pizza | 🍕 | Buitoni, Mulino Bianco
pane-carasau | Pane carasau | 🫓
friselle | Friselle | 🥯
tortillas | Tortillas e wraps | 🌯 | Old El Paso, Mission
gallette | Gallette di riso e mais | 🍘 | Galbusera, Scotti, Misura
cornetti | Cornetti e brioche | 🥐
pane-senza-glutine | Pane senza glutine | 🍞 | Schär
bruschette | Bruschette | 🍞 | Mulino Bianco
'''),
  ..._leggi(Reparto.carne, '''
petto-tacchino | Petto di tacchino | 🦃 | AIA, Amadori, Fileni
fesa-tacchino | Fesa di tacchino | 🦃 | AIA, Amadori
fettine-tacchino | Fettine di tacchino | 🦃 | AIA, Amadori, Fileni
salsiccia-tacchino | Salsiccia di tacchino | 🌭 | AIA, Amadori
macinato-tacchino | Macinato di tacchino | 🦃 | AIA, Amadori
cosce-tacchino | Cosce di tacchino | 🦃 | AIA, Amadori
spezzatino-tacchino | Spezzatino di tacchino | 🦃 | AIA, Amadori
arrosto-tacchino | Arrosto di tacchino | 🦃 | AIA, Amadori
hamburger-tacchino | Hamburger di tacchino | 🍔 | AIA, Amadori
wurstel-tacchino | Würstel di tacchino | 🌭 | Wudy, Amadori
pollo-intero | Pollo intero | 🐔 | AIA, Amadori, Fileni
cosce-pollo | Cosce e fusi di pollo | 🍗 | AIA, Amadori, Fileni
ali-pollo | Ali di pollo | 🍗 | AIA, Amadori
fettine-pollo | Fettine e straccetti di pollo | 🍗 | AIA, Amadori, Fileni
macinato-pollo | Macinato di pollo | 🍗 | AIA, Amadori
wurstel-pollo | Würstel di pollo | 🌭 | Wudy, Amadori
spiedini | Spiedini | 🍢 | AIA, Amadori
cordon-bleu | Cordon bleu | 🍗 | AIA, Amadori
crocchette-pollo | Crocchette e nuggets di pollo | 🍗 | AIA, Amadori
fettine-manzo | Fettine di manzo | 🥩
spezzatino-manzo | Spezzatino di manzo | 🥩
arrosto-manzo | Arrosto di manzo | 🥩
bollito | Carne per brodo / bollito | 🥩
tagliata | Tagliata / fiorentina | 🥩
carpaccio | Carpaccio | 🥩
roast-beef | Roast beef | 🥩
macinato-misto | Macinato misto | 🥩
braciole | Braciole di maiale | 🍖
lonza | Lonza di maiale | 🍖
costine | Costine di maiale | 🍖
filetto-maiale | Filetto di maiale | 🍖
pancetta-fresca | Pancetta fresca | 🥓
fettine-vitello | Fettine di vitello | 🥩
scaloppine | Scaloppine | 🥩
ossobuco | Ossobuco | 🍖
agnello | Agnello | 🍖
coniglio | Coniglio | 🐇
polpette | Polpette | 🧆
involtini | Involtini | 🥩
fegato | Fegato | 🥩
trippa | Trippa | 🥩
'''),
  ..._leggi(Reparto.pesce, '''
tonno-fresco | Tonno fresco | 🐟
pesce-spada | Pesce spada | 🐟
calamari | Calamari | 🦑
polpo | Polpo | 🐙
seppie | Seppie | 🦑
alici | Alici / acciughe | 🐟
sgombro | Sgombro | 🐟
sardine | Sardine | 🐟
baccala | Baccalà | 🐟
trota | Trota | 🐟
sogliola | Sogliola e platessa | 🐟
gamberoni | Gamberoni e scampi | 🦐
salmone-affumicato | Salmone affumicato | 🐟 | Fjord, Skandia
surimi | Surimi | 🦀 | Pescanova
frutti-mare | Frutti di mare misti | 🦪
'''),
  ..._leggi(Reparto.salumiFormaggi, '''
fesa-tacchino-affettata | Fesa di tacchino affettata | 🦃 | AIA, Amadori, Negroni, Rovagnati
petto-pollo-affettato | Petto di pollo affettato | 🍗 | AIA, Amadori
speck | Speck | 🥓 | Senfter, Recla
pancetta | Pancetta | 🥓 | Citterio, Beretta
guanciale | Guanciale | 🥓 | Citterio, Beretta
coppa | Coppa | 🍖 | Citterio, Beretta
porchetta | Porchetta | 🍖
cotechino | Cotechino e zampone | 🍖 | Citterio, Levoni, Negroni
pecorino | Pecorino | 🧀 | Locatelli
gorgonzola | Gorgonzola | 🧀 | Igor, Galbani
provolone | Provolone | 🧀 | Auricchio, Galbani
scamorza | Scamorza | 🧀 | Galbani, Vallelata
fontina | Fontina | 🧀
asiago | Asiago | 🧀
emmental | Emmental | 🧀
edamer | Edamer | 🧀
taleggio | Taleggio | 🧀
brie | Brie | 🧀 | Président
feta | Feta | 🧀
caciocavallo | Caciocavallo | 🧀
grattugiato | Formaggio grattugiato | 🧀 | Parmareggio, Galbani, Grana Padano
'''),
  ..._leggi(Reparto.gastronomia, '''
lasagne-pronte | Lasagne pronte | 🍝 | Giovanni Rana, Buitoni
insalata-riso | Insalata di riso | 🍚
pizza-fresca | Pizza fresca | 🍕 | Buitoni
pollo-arrosto | Pollo arrosto | 🍗
hummus | Hummus | 🫘
olive-ascolane | Olive ascolane | 🫒
arancini | Arancini | 🍙
zuppe | Zuppe pronte | 🥣 | Knorr, DimmidiSì
piadina-farcita | Piadine farcite | 🫓
sushi | Sushi | 🍣
tramezzini | Tramezzini e panini pronti | 🥪
primi-pronti | Primi piatti pronti | 🍝 | Giovanni Rana, Buitoni
secondi-pronti | Secondi piatti pronti | 🍖 | AIA, Amadori
'''),
  ..._leggi(Reparto.latticiniUova, '''
latte-senza-lattosio | Latte senza lattosio | 🥛 | Zymil, Accadì, Granarolo
latte-vegetale | Latte vegetale (soia, mandorla, avena) | 🥛 | Alpro, Valsoia
yogurt-greco | Yogurt greco | 🥣 | Fage, Yomo, Danone
kefir | Kefir | 🥛
stracchino | Stracchino e crescenza | 🧀 | Nonno Nanni, Galbani
mascarpone | Mascarpone | 🧀 | Galbani, Granarolo
burrata | Burrata e stracciatella | 🧀
robiola | Robiola | 🧀 | Fattorie Osella
fiocchi-latte | Fiocchi di latte | 🧀 | Granarolo
besciamella | Besciamella | 🥛 | Parmalat, Granarolo
margarina | Margarina | 🧈 | Gradina, Vallé
formaggini | Formaggini | 🧀 | Mio, Galbani
tofu | Tofu | 🥡 | Valsoia
'''),
  ..._leggi(Reparto.pastaRiso, '''
spaghetti | Spaghetti | 🍝 | Barilla, De Cecco, Garofalo, Rummo, Voiello, La Molisana, Divella
penne | Penne | 🍝 | Barilla, De Cecco, Garofalo, Rummo, Voiello, La Molisana, Divella
fusilli | Fusilli | 🍝 | Barilla, De Cecco, Garofalo, Rummo, La Molisana, Divella
rigatoni | Rigatoni | 🍝 | Barilla, De Cecco, Garofalo, Rummo, La Molisana
linguine | Linguine | 🍝 | Barilla, De Cecco, Garofalo, Rummo
farfalle | Farfalle | 🍝 | Barilla, De Cecco, Garofalo
tagliatelle | Tagliatelle e pasta all'uovo | 🍝 | Barilla, De Cecco, Giovanni Rana
sfoglie-lasagne | Sfoglie per lasagne | 🍝 | Barilla, De Cecco, Giovanni Rana
pasta-integrale | Pasta integrale | 🍝 | Barilla, De Cecco, Garofalo
pasta-senza-glutine | Pasta senza glutine | 🍝 | Barilla, Rummo, Schär
pastina | Pastina | 🍜 | Barilla, De Cecco, Buitoni
tortellini | Tortellini | 🥟 | Giovanni Rana, Fini
ravioli | Ravioli | 🥟 | Giovanni Rana, Fini
orecchiette | Orecchiette | 🍝 | Barilla, Divella
couscous | Couscous | 🍚
orzo-perlato | Orzo e farro | 🌾 | Scotti
quinoa | Quinoa | 🌾
riso-basmati | Riso basmati | 🍚 | Scotti, Gallo
riso-risotti | Riso per risotti | 🍚 | Scotti, Gallo, Curtiriso
polenta | Polenta | 🌽 | Valsugana, Molino Rossetto
lenticchie | Lenticchie secche | 🫘
ceci-secchi | Ceci secchi | 🫘
fagioli-secchi | Fagioli secchi | 🫘
'''),
  ..._leggi(Reparto.conserveCondimenti, '''
pesto | Pesto | 🌿 | Barilla, Saclà, Giovanni Rana
ragu | Ragù pronto | 🥫 | Star, Barilla, Mutti
concentrato | Concentrato di pomodoro | 🍅 | Mutti, Cirio
polpa-pomodoro | Polpa di pomodoro | 🍅 | Mutti, Cirio, Pomì
mais-scatola | Mais in scatola | 🌽 | Bonduelle, Valfrutta
piselli-scatola | Piselli in scatola | 🫛 | Bonduelle, Valfrutta, Cirio
fagioli-scatola | Fagioli in scatola | 🫘 | Valfrutta, Cirio, Bonduelle
ceci-scatola | Ceci in scatola | 🫘 | Valfrutta, Cirio, Bonduelle
sottoli | Funghi e carciofini sott'olio | 🫙 | Saclà, Polli
sottaceti | Sottaceti | 🫙 | Saclà, Polli
capperi | Capperi | 🫙
acciughe-olio | Acciughe sott'olio | 🐟 | Rio Mare, Callipo
sgombro-scatola | Sgombro in scatola | 🐟 | Rio Mare, Nostromo
salmone-scatola | Salmone in scatola | 🐟 | Rio Mare
dado | Dado e brodo pronto | 🥣 | Star, Knorr
senape | Senape | 🌭 | Calvé, Maille
salsa-soia | Salsa di soia | 🍶 | Kikkoman
salse | Salse (barbecue, rosa, tonnata) | 🥫 | Calvé, Heinz
aceto-balsamico | Aceto balsamico | 🍶 | Ponti, De Nigris
pepe | Pepe | 🧂 | Cannamela
origano | Origano | 🌿 | Cannamela
peperoncino | Peperoncino | 🌶️ | Cannamela
spezie | Spezie (curry, paprika, noce moscata…) | 🧂 | Cannamela, Drogheria e Alimentari
zafferano | Zafferano | 🧂 | Tre Cuochi
vanillina | Vanillina e aromi per dolci | 🧁 | Paneangeli, Cameo
bicarbonato | Bicarbonato | 🧂
burro-arachidi | Burro d'arachidi | 🥜
'''),
  ..._leggi(Reparto.colazioneDolci, '''
muesli | Muesli e granola | 🥣 | Kellogg's, Misura
cacao | Cacao in polvere | 🍫 | Perugina
orzo-solubile | Orzo solubile | ☕ | Orzo Bimbo, Crastan
camomilla | Camomilla | 🍵 | Bonomelli, Pompadour
plumcake | Plumcake | 🍰 | Mulino Bianco, Vicenzi
crostatine | Crostatine | 🥧 | Mulino Bianco
cornetti-confezionati | Cornetti confezionati | 🥐 | Bauli, Mulino Bianco, Motta
preparati-torte | Preparati per torte | 🎂 | Cameo, Paneangeli
budino | Budino | 🍮 | Cameo, Danette
caramelle | Caramelle | 🍬 | Haribo, Rossana, Golia
gomme | Gomme da masticare | 🍬 | Vivident, Brooklyn, Mentos
wafer | Wafer | 🧇 | Loacker, Balocco
barrette-cioccolato | Barrette di cioccolato | 🍫 | Kinder, Twix, Mars, KitKat, Snickers
panettone | Panettone | 🎄 | Bauli, Motta, Tre Marie
pandoro | Pandoro | 🎄 | Bauli, Melegatti
colomba | Colomba | 🕊️ | Bauli, Motta
zucchero-canna | Zucchero di canna | 🍬 | Eridania
dolcificante | Dolcificante | 🍬 | Dietor, Hermesetas
'''),
  ..._leggi(Reparto.snackAperitivo, '''
taralli | Taralli | 🥨
popcorn | Popcorn | 🍿 | Sammontana, San Carlo
arachidi | Arachidi | 🥜 | Noberasco, Ventura
pistacchi | Pistacchi | 🥜 | Noberasco, Ventura
mandorle | Mandorle e noci | 🌰 | Noberasco, Ventura
salatini | Salatini | 🥨 | Gran Pavesi
tortilla-chips | Tortilla chips | 🌮 | Doritos, San Carlo
barrette-cereali | Barrette ai cereali | 🍫 | Misura, Kellogg's
frutta-disidratata | Frutta disidratata | 🍑 | Noberasco
'''),
  ..._leggi(Reparto.surgelati, '''
spinaci-surgelati | Spinaci surgelati | 🥬 | Findus, Orogel
piselli-surgelati | Piselli surgelati | 🫛 | Findus, Orogel
fagiolini-surgelati | Fagiolini surgelati | 🫛 | Findus, Orogel
sofficini | Sofficini | 🥟 | Findus
filetti-pesce | Filetti di pesce surgelati | 🐟 | Findus, Orogel
gamberi-surgelati | Gamberi surgelati | 🦐 | Findus
fritto-misto | Fritto misto | 🦑 | Findus
cotolette-surgelate | Cotolette surgelate | 🍗 | AIA, Findus
lasagne-surgelate | Lasagne surgelate | 🍝 | Findus, Buitoni
primi-surgelati | Primi piatti surgelati | 🍝 | Findus, Buitoni
croissant-surgelati | Cornetti surgelati | 🥐
frutti-bosco-surgelati | Frutti di bosco surgelati | 🫐 | Orogel
polpette-surgelate | Polpette surgelate | 🧆 | Findus
coni-gelato | Coni gelato | 🍦 | Algida, Sammontana, Motta
ghiaccioli | Ghiaccioli | 🍧 | Algida, Sammontana
ghiaccio | Ghiaccio | 🧊
'''),
  ..._leggi(Reparto.bevande, '''
aranciata | Aranciata | 🍊 | San Pellegrino, Fanta
chinotto | Chinotto | 🥤 | Neri, San Pellegrino
cola-zero | Cola zero | 🥤 | Coca-Cola, Pepsi
acqua-tonica | Acqua tonica | 🥤 | Schweppes
succo-arancia | Succo d'arancia | 🧃 | Santal, Yoga, Zuegg
energy-drink | Energy drink | ⚡ | Red Bull, Monster
sport-drink | Bevande sportive | 🧃 | Gatorade, Powerade
vino-rosso | Vino rosso | 🍷 | Tavernello, Zonin, Santa Cristina
vino-bianco | Vino bianco | 🥂 | Tavernello, Zonin, Santa Cristina
prosecco | Prosecco e spumante | 🍾 | Mionetto, Martini, Valdo
birra-analcolica | Birra analcolica | 🍺 | Moretti, Peroni, Heineken
amari | Amari e liquori | 🥃 | Montenegro, Averna, Ramazzotti, Lucano
aperitivi | Aperitivi | 🍹 | Aperol, Campari, Crodino, San Bitter
limoncello | Limoncello | 🍋
superalcolici | Superalcolici | 🥃
'''),
  ..._leggi(Reparto.puliziaCasa, '''
detersivo-delicati | Detersivo per capi delicati | 🧺 | Perlana, Woolite
smacchiatore | Smacchiatore | 🧺 | Vanish, Omino Bianco
anticalcare-lavatrice | Anticalcare lavatrice | 🧺 | Calgon
igienizzante-bucato | Igienizzante per bucato | 🧺 | Napisan, Lysoform
profuma-bucato | Profumatore per bucato | 🌸 | Lenor, Vernel
brillantante | Brillantante e sale lavastoviglie | 🍽️ | Finish
vetri | Pulitore vetri | 🪟 | Vetril, Glassex
mobili | Pulitore mobili | 🪑 | Pronto, Emulsio
disinfettante-casa | Disinfettante per casa | 🧴 | Lysoform, Amuchina, Napisan
disgorgante | Disgorgante | 🚰 | Mister Muscolo, Niagara
panni | Panni e Swiffer | 🧹 | Vileda, Swiffer
guanti | Guanti | 🧤 | Vileda, Spontex
tovaglioli | Tovaglioli di carta | 🧻 | Regina, Scottex, Tenderly
piatti-plastica | Piatti e bicchieri usa e getta | 🥤 | Dopla
carta-forno | Carta forno | 📜 | Domopak, Cuki
sacchetti-gelo | Sacchetti gelo | 🧊 | Domopak, Cuki
insetticida | Insetticida | 🪳 | Raid, Baygon, Neocid
antizanzare | Antizanzare | 🦟 | Autan, Vape
candele | Candele | 🕯️
fiammiferi | Fiammiferi e accendini | 🔥 | BIC
alcol | Alcol denaturato | 🧴
sapone-marsiglia | Sapone di Marsiglia | 🧼
'''),
  ..._leggi(Reparto.igienePersonale, '''
cerotti | Cerotti | 🩹 | Hansaplast, Pic
disinfettante-cute | Disinfettante per la pelle | 🩹 | Amuchina, Betadine
gel-mani | Gel igienizzante mani | 🧴 | Amuchina, Napisan
gel-capelli | Gel e lacca per capelli | 💇 | Testanera, Garnier
tinta | Tinta per capelli | 💇 | L'Oréal, Garnier
struccante | Struccante | 🧴 | Garnier, Nivea
crema-viso | Crema viso | 🧴 | Nivea, L'Oréal, Garnier
burrocacao | Burrocacao | 💄 | Labello
solare | Crema solare | ☀️ | Nivea, Bilboa, Angstrom
filo-interdentale | Filo interdentale | 🪥 | Oral-B, GUM
salvaslip | Salvaslip | 🌸 | Lines, Carefree
dopobarba | Dopobarba | 🪒 | Proraso, Nivea Men
intimo | Detergente intimo | 🧴 | Chilly, Saugella, Neutro Roberts
talco | Talco | 🧴 | Borotalco
'''),
  ..._leggi(Reparto.bambini, '''
latte-bambini | Latte per bambini | 🍼 | Mellin, Plasmon, Aptamil
pappe | Creme di cereali e pappe | 🥣 | Plasmon, Mellin
succhi-bambini | Succhi e merende per bambini | 🧃 | Plasmon, Mellin, Hipp
crema-cambio | Crema per il cambio | 🧴 | Fissan, Chicco
bagno-bambini | Bagnetto e shampoo bambini | 🛁 | Johnson's, Chicco
biberon | Biberon e ciucci | 🍼 | Chicco, MAM, Avent
'''),
  ..._leggi(Reparto.animali, '''
snack-cani | Snack per cani | 🦴 | Pedigree, Purina
snack-gatti | Snack per gatti | 🐟 | Whiskas, Felix, Dreamies
sacchetti-cani | Sacchetti igienici | 🐶
antiparassitario | Antiparassitario | 🐾 | Frontline, Advantix
'''),
  ..._leggi(Reparto.altro, '''
farmaci | Farmaci | 💊
giornale | Giornale e riviste | 📰
fiori | Fiori | 🌷
regalo | Regalo | 🎁
'''),
];

List<Prodotto> _leggi(Reparto reparto, String testo) => [
  for (final riga in testo.split('\n'))
    if (riga.trim().isNotEmpty) _prodotto(reparto, riga),
];

Prodotto _prodotto(Reparto reparto, String riga) {
  final parti = riga.split('|').map((s) => s.trim()).toList();
  return Prodotto(
    id: parti[0],
    nome: parti[1],
    reparto: reparto,
    emoji: parti[2],
    marche: parti.length > 3 && parti[3].isNotEmpty
        ? parti[3].split(',').map((m) => m.trim()).toList()
        : const [],
  );
}
