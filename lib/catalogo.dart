import 'models.dart';

/// Catalogo di base: prodotti comuni nei supermercati italiani con le marche
/// più diffuse. Si amplia dall'app (prodotti e marche personali).
final List<Prodotto> catalogoBase = [
  ..._r(Reparto.fruttaVerdura, [
    ('mele', 'Mele', '🍎', ['Melinda', 'Val Venosta', 'Marlene']),
    ('banane', 'Banane', '🍌', ['Chiquita', 'Dole', 'Del Monte']),
    ('arance', 'Arance', '🍊', []),
    ('limoni', 'Limoni', '🍋', []),
    ('pomodori', 'Pomodori', '🍅', []),
    ('insalata', 'Insalata', '🥬', ['Bonduelle', 'La Linea Verde', 'DimmidiSì']),
    ('patate', 'Patate', '🥔', ['Selenella', 'Pizzoli']),
    ('cipolle', 'Cipolle', '🧅', []),
    ('aglio', 'Aglio', '🧄', []),
    ('carote', 'Carote', '🥕', []),
    ('zucchine', 'Zucchine', '🥒', []),
    ('peperoni', 'Peperoni', '🫑', []),
    ('frutta-stagione', 'Frutta di stagione', '🍇', []),
  ]),
  ..._r(Reparto.panetteria, [
    ('pane', 'Pane', '🍞', []),
    ('pancarre', 'Pane in cassetta', '🍞', ['Mulino Bianco', "Harry's", 'Morato']),
    ('piadine', 'Piadine', '🫓', ['Loriana', 'Morato', 'Mulino Bianco']),
    ('grissini', 'Grissini', '🥖', ['Mulino Bianco', 'Grissin Bon', 'Panealba']),
    ('crackers', 'Crackers', '🍘', ['Mulino Bianco', 'Gran Pavesi', 'Galbusera', 'Misura']),
    ('fette-biscottate', 'Fette biscottate', '🍞', ['Mulino Bianco', 'Buitoni', 'Misura', 'Barilla']),
  ]),
  ..._r(Reparto.carne, [
    ('pollo', 'Petto di pollo', '🍗', ['Amadori', 'AIA', 'Fileni']),
    ('macinato', 'Carne macinata', '🥩', []),
    ('bistecche', 'Bistecche', '🥩', []),
    ('salsiccia', 'Salsiccia', '🌭', ['Amadori', 'AIA']),
    ('hamburger', 'Hamburger', '🍔', ['Amadori', 'AIA', 'Montana']),
    ('cotolette', 'Cotolette', '🍗', ['AIA', 'Amadori']),
    ('wurstel', 'Würstel', '🌭', ['Wudy', 'Beretta', 'Amadori']),
  ]),
  ..._r(Reparto.pesce, [
    ('salmone', 'Salmone', '🐟', []),
    ('orata', 'Orata / branzino', '🐟', []),
    ('gamberi', 'Gamberi', '🦐', []),
    ('merluzzo', 'Merluzzo', '🐟', []),
    ('cozze', 'Cozze / vongole', '🦪', []),
  ]),
  ..._r(Reparto.salumiFormaggi, [
    ('crudo', 'Prosciutto crudo', '🥓', ['Parma', 'San Daniele', 'Rovagnati']),
    ('cotto', 'Prosciutto cotto', '🍖', ['Rovagnati', 'Parmacotto', 'Beretta', 'Fiorucci']),
    ('salame', 'Salame', '🍖', ['Beretta', 'Citterio', 'Negroni', 'Levoni']),
    ('mortadella', 'Mortadella', '🍖', ['Alcisa', 'Felsineo']),
    ('bresaola', 'Bresaola', '🥩', ['Rigamonti', 'Citterio']),
    ('grana', 'Parmigiano / Grana', '🧀', ['Parmigiano Reggiano', 'Grana Padano', 'Parmareggio', 'Zanetti']),
    ('formaggio-fette', 'Formaggio a fette', '🧀', ['Sottilette', 'Galbani']),
  ]),
  ..._r(Reparto.latticiniUova, [
    ('latte', 'Latte', '🥛', ['Granarolo', 'Parmalat', 'Zymil', 'Mila']),
    ('yogurt', 'Yogurt', '🥣', ['Müller', 'Yomo', 'Danone', 'Activia', 'Vipiteno', 'Fage']),
    ('mozzarella', 'Mozzarella', '🧀', ['Galbani', 'Santa Lucia', 'Vallelata', 'Granarolo']),
    ('burro', 'Burro', '🧈', ['Lurpak', 'Granarolo', 'Président', 'Prealpi']),
    ('uova', 'Uova', '🥚', ['Le Naturelle', 'Fattoria Roberti', 'AIA']),
    ('ricotta', 'Ricotta', '🧀', ['Vallelata', 'Santa Lucia', 'Galbani']),
    ('spalmabile', 'Formaggio spalmabile', '🧀', ['Philadelphia', 'Exquisa', 'Nonno Nanni']),
    ('panna', 'Panna', '🥛', ['Hoplà', 'Parmalat', 'Granarolo']),
  ]),
  ..._r(Reparto.pastaRiso, [
    ('pasta', 'Pasta', '🍝', ['Barilla', 'De Cecco', 'Garofalo', 'Rummo', 'Voiello', 'La Molisana', 'Divella']),
    ('pasta-fresca', 'Pasta fresca', '🥟', ['Giovanni Rana', 'Fini', 'Buitoni']),
    ('gnocchi', 'Gnocchi', '🥔', ['Giovanni Rana', 'Fini']),
    ('riso', 'Riso', '🍚', ['Scotti', 'Gallo', 'Flora']),
    ('farina', 'Farina', '🌾', ['Barilla', 'Lo Conte', 'Caputo', 'Molino Rossetto']),
    ('lievito', 'Lievito', '🧁', ['Paneangeli', 'Cameo']),
  ]),
  ..._r(Reparto.conserveCondimenti, [
    ('passata', 'Passata di pomodoro', '🍅', ['Mutti', 'Cirio', 'Pomì', 'Valfrutta', 'Petti']),
    ('pelati', 'Pelati', '🥫', ['Mutti', 'Cirio', 'Valfrutta']),
    ('sugo', 'Sugo pronto', '🥫', ['Barilla', 'Mutti', 'Star', 'Saclà']),
    ('tonno', 'Tonno in scatola', '🐟', ['Rio Mare', 'Callipo', 'Mareblu', 'Nostromo', 'As do Mar']),
    ('legumi', 'Legumi in scatola', '🫘', ['Valfrutta', 'Cirio', 'Bonduelle']),
    ('olio-evo', 'Olio extravergine', '🫒', ['Carapelli', 'Monini', 'Bertolli', 'Farchioni', 'Sasso', 'Dante']),
    ('olio-semi', 'Olio di semi', '🌻', ['Cuore', 'Topazio', 'Carapelli']),
    ('aceto', 'Aceto', '🍶', ['Ponti', 'Monari Federzoni', 'De Nigris']),
    ('sale', 'Sale', '🧂', ['Gemma di Mare', 'Sosalt', 'Italkali']),
    ('maionese', 'Maionese', '🥚', ['Calvé', 'Kraft', "Hellmann's"]),
    ('ketchup', 'Ketchup', '🍅', ['Heinz', 'Calvé']),
  ]),
  ..._r(Reparto.colazioneDolci, [
    ('caffe', 'Caffè', '☕', ['Lavazza', 'Kimbo', 'Illy', 'Segafredo', 'Borbone', 'Pellini']),
    ('capsule', 'Capsule caffè', '☕', ['Nespresso', 'Lavazza A Modo Mio', 'Borbone', 'Dolce Gusto']),
    ('biscotti', 'Biscotti', '🍪', ['Mulino Bianco', 'Pavesi', 'Gentilini', 'Balocco', 'Oro Saiwa', 'Galbusera']),
    ('merendine', 'Merendine', '🧁', ['Mulino Bianco', 'Kinder', 'Bauli', 'Balocco']),
    ('cereali', 'Cereali', '🥣', ["Kellogg's", 'Nestlé', 'Mulino Bianco', 'Misura']),
    ('crema-spalmabile', 'Crema spalmabile', '🍫', ['Nutella', 'Novi', 'Pan di Stelle']),
    ('marmellata', 'Marmellata', '🍓', ['Zuegg', 'Hero', 'Santa Rosa', 'Rigoni di Asiago']),
    ('te', 'Tè e tisane', '🍵', ['Twinings', 'Lipton', 'Pompadour', 'Sir Winston']),
    ('zucchero', 'Zucchero', '🍬', ['Eridania', 'Italia Zuccheri']),
    ('miele', 'Miele', '🍯', ['Ambrosoli', 'Mielizia', 'Rigoni di Asiago']),
    ('cioccolato', 'Cioccolato', '🍫', ['Lindt', 'Novi', 'Milka', 'Ferrero', 'Perugina']),
  ]),
  ..._r(Reparto.snackAperitivo, [
    ('patatine', 'Patatine', '🥔', ['San Carlo', 'Pai', 'Amica Chips', 'Pringles', "Lay's"]),
    ('frutta-secca', 'Frutta secca', '🥜', ['Noberasco', 'Ventura']),
    ('olive', 'Olive', '🫒', ['Saclà', 'Ficacci', 'Polli']),
  ]),
  ..._r(Reparto.surgelati, [
    ('verdure-surgelate', 'Verdure surgelate', '🥦', ['Findus', 'Orogel', 'Bonduelle']),
    ('minestrone', 'Minestrone', '🥣', ['Findus', 'Orogel']),
    ('bastoncini', 'Bastoncini di pesce', '🐟', ['Findus', 'Orogel']),
    ('pizza-surgelata', 'Pizza surgelata', '🍕', ['Cameo', 'Buitoni', 'Dr. Oetker', 'Italpizza']),
    ('patatine-surgelate', 'Patatine da forno', '🍟', ['McCain', 'Pizzoli', 'Findus']),
    ('gelato', 'Gelato', '🍨', ['Algida', 'Sammontana', 'Motta', 'Häagen-Dazs', "Carte d'Or"]),
  ]),
  ..._r(Reparto.bevande, [
    ('acqua-naturale', 'Acqua naturale', '💧', ['San Benedetto', 'Levissima', "Sant'Anna", 'Panna', 'Rocchetta', 'Vera']),
    ('acqua-frizzante', 'Acqua frizzante', '🫧', ['San Pellegrino', 'Ferrarelle', 'Levissima', 'San Benedetto', 'Uliveto']),
    ('succhi', 'Succhi di frutta', '🧃', ['Yoga', 'Santal', 'Skipper', 'Zuegg']),
    ('bibite', 'Bibite', '🥤', ['Coca-Cola', 'Pepsi', 'Fanta', 'Sprite', 'Lemonsoda']),
    ('te-freddo', 'Tè freddo', '🧋', ['Estathé', 'Lipton', 'San Benedetto']),
    ('birra', 'Birra', '🍺', ['Peroni', 'Moretti', 'Ichnusa', 'Heineken', 'Nastro Azzurro', 'Menabrea']),
    ('vino', 'Vino', '🍷', ['Tavernello', 'Zonin', 'Mionetto', 'Santa Cristina']),
  ]),
  ..._r(Reparto.puliziaCasa, [
    ('detersivo-lavatrice', 'Detersivo lavatrice', '🧺', ['Dash', 'Dixan', 'Ariel', 'Bio Presto', 'Omino Bianco', 'Persil']),
    ('ammorbidente', 'Ammorbidente', '🌸', ['Lenor', 'Coccolino', 'Vernel', 'Soflan']),
    ('detersivo-piatti', 'Detersivo piatti', '🍽️', ['Svelto', 'Nelsen', 'Fairy']),
    ('lavastoviglie', 'Pastiglie lavastoviglie', '🍽️', ['Finish', 'Fairy', 'Svelto', 'Sun']),
    ('sgrassatore', 'Sgrassatore', '🧴', ['Chanteclair', 'Smac', 'Cif', 'Ajax']),
    ('pavimenti', 'Detersivo pavimenti', '🧹', ['Mastro Lindo', 'Ajax', 'Fabuloso', 'Lysoform', 'Spic and Span']),
    ('anticalcare', 'Anticalcare', '🚿', ['Viakal', 'Smac', 'Cif']),
    ('candeggina', 'Candeggina', '🧴', ['ACE', 'Neoblanc']),
    ('wc', 'Pulitore WC', '🚽', ['WC Net', 'Domestos', 'Harpic', 'Bref']),
    ('carta-cucina', 'Carta da cucina', '🧻', ['Scottex', 'Regina', 'Foxy']),
    ('carta-igienica', 'Carta igienica', '🧻', ['Scottex', 'Regina', 'Foxy', 'Tenderly']),
    ('sacchetti', 'Sacchetti spazzatura', '🗑️', ['Domopak', 'Cuki', 'Virosac']),
    ('pellicola', 'Pellicola / alluminio', '📜', ['Domopak', 'Cuki']),
    ('spugne', 'Spugne', '🧽', ['Vileda', 'Scotch-Brite', 'Spontex']),
    ('deo-ambienti', 'Deodorante per ambienti', '🌿', ['Glade', 'Air Wick', 'Ambi Pur']),
  ]),
  ..._r(Reparto.igienePersonale, [
    ('deodorante', 'Deodorante', '🧴', ['Dove', 'Nivea', 'Borotalco', 'Rexona', 'Neutro Roberts', 'Infasil', 'Axe']),
    ('shampoo', 'Shampoo', '🧴', ['Pantene', 'Head & Shoulders', 'Garnier Fructis', "L'Oréal Elvive", 'Dove', 'Clear']),
    ('balsamo', 'Balsamo', '🧴', ['Pantene', 'Garnier Fructis', "L'Oréal Elvive", 'Dove']),
    ('bagnoschiuma', 'Bagnoschiuma', '🛁', ['Dove', 'Nivea', 'Palmolive', 'Neutro Roberts', 'Felce Azzurra', 'Vidal']),
    ('sapone-mani', 'Sapone mani', '🧼', ['Dove', 'Palmolive', 'Dermomed', 'Neutro Roberts', 'Felce Azzurra']),
    ('dentifricio', 'Dentifricio', '🪥', ['Colgate', 'AZ', 'Mentadent', 'Sensodyne', 'Elmex', 'Pasta del Capitano']),
    ('spazzolino', 'Spazzolino', '🪥', ['Oral-B', 'Colgate', 'AZ', 'Mentadent']),
    ('collutorio', 'Collutorio', '🫧', ['Listerine', 'Meridol', 'Colgate']),
    ('rasoi', 'Rasoi e lamette', '🪒', ['Gillette', 'Wilkinson', 'BIC']),
    ('schiuma-barba', 'Schiuma da barba', '🪒', ['Gillette', 'Proraso', 'Nivea Men']),
    ('assorbenti', 'Assorbenti', '🌸', ['Lines', 'Nuvenia', 'Tampax']),
    ('fazzoletti', 'Fazzoletti', '🤧', ['Tempo', 'Kleenex', 'Scottex', 'Foxy']),
    ('cotone', 'Cotton fioc e dischetti', '☁️', ["Johnson's", "Demak'Up"]),
    ('crema-corpo', 'Crema corpo', '🧴', ['Nivea', 'Neutrogena', 'Dove', 'Leocrema']),
  ]),
  ..._r(Reparto.bambini, [
    ('pannolini', 'Pannolini', '👶', ['Pampers', 'Huggies', 'Chicco']),
    ('salviette', 'Salviette umidificate', '🧻', ['Pampers', 'Huggies', 'Chicco']),
    ('omogeneizzati', 'Omogeneizzati', '🍼', ['Plasmon', 'Mellin', 'Hipp', 'Nipiol']),
    ('biscotti-bimbi', 'Biscotti per bambini', '🍪', ['Plasmon', 'Mellin']),
  ]),
  ..._r(Reparto.animali, [
    ('cibo-cani', 'Cibo per cani', '🐶', ['Purina', 'Pedigree', 'Royal Canin', 'Monge', 'Cesar']),
    ('cibo-gatti', 'Cibo per gatti', '🐱', ['Whiskas', 'Felix', 'Purina', 'Gourmet', 'Monge', 'Royal Canin']),
    ('lettiera', 'Lettiera', '🐱', ['Catsan', 'Ever Clean', 'Sanicat']),
  ]),
  ..._r(Reparto.altro, [
    ('pile', 'Pile', '🔋', ['Duracell', 'Energizer', 'Varta']),
    ('lampadine', 'Lampadine', '💡', ['Philips', 'Osram']),
  ]),
];

List<Prodotto> _r(
  Reparto reparto,
  List<(String, String, String, List<String>)> voci,
) =>
    [
      for (final (id, nome, emoji, marche) in voci)
        Prodotto(id: id, nome: nome, reparto: reparto, emoji: emoji, marche: marche),
    ];

/// Toglie accenti e maiuscole per cercare "caffe" e trovare "Caffè".
String normalizza(String s) {
  const da = 'àáâäèéêëìíîïòóôöùúûüç';
  const a = 'aaaaeeeeiiiioooouuuuc';
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    final i = da.indexOf(ch);
    b.write(i >= 0 ? a[i] : ch);
  }
  return b.toString().trim();
}

/// Indovina il reparto di un prodotto scritto a mano, cercando parole note.
Reparto indovinaReparto(String testo, List<Prodotto> catalogo) {
  final t = normalizza(testo);
  if (t.isEmpty) return Reparto.altro;
  // 1) nome identico; 2) il testo contiene un nome noto (il più lungo vince,
  // es. "fettine di petto di pollo"); 3) un nome noto contiene il testo
  // (il più corto vince, es. "deodor" → Deodorante e non Deodorante per ambienti).
  final nomi = [for (final p in catalogo) (normalizza(p.nome), p.reparto)];
  for (final (n, r) in nomi) {
    if (n == t) return r;
  }
  final contenuti = nomi.where((x) => t.contains(x.$1)).toList()
    ..sort((a, b) => b.$1.length - a.$1.length);
  if (contenuti.isNotEmpty) return contenuti.first.$2;
  final contenenti = nomi.where((x) => x.$1.contains(t)).toList()
    ..sort((a, b) => a.$1.length - b.$1.length);
  if (contenenti.isNotEmpty) return contenenti.first.$2;
  for (final p in catalogo) {
    for (final m in p.marche) {
      if (t.contains(normalizza(m))) return p.reparto;
    }
  }
  const parole = <String, Reparto>{
    'frutta': Reparto.fruttaVerdura, 'verdur': Reparto.fruttaVerdura,
    'pere': Reparto.fruttaVerdura, 'kiwi': Reparto.fruttaVerdura,
    'fragol': Reparto.fruttaVerdura, 'melanzan': Reparto.fruttaVerdura,
    'spinaci': Reparto.fruttaVerdura, 'funghi': Reparto.fruttaVerdura,
    'pane': Reparto.panetteria, 'focaccia': Reparto.panetteria,
    'manzo': Reparto.carne, 'maiale': Reparto.carne, 'vitello': Reparto.carne,
    'tacchino': Reparto.carne, 'agnello': Reparto.carne, 'carne': Reparto.carne,
    'pesce': Reparto.pesce, 'tonno fresco': Reparto.pesce, 'calamar': Reparto.pesce,
    'formagg': Reparto.salumiFormaggi, 'speck': Reparto.salumiFormaggi,
    'pecorino': Reparto.salumiFormaggi, 'gorgonzola': Reparto.salumiFormaggi,
    'latte': Reparto.latticiniUova, 'yogurt': Reparto.latticiniUova,
    'stracchino': Reparto.latticiniUova, 'mascarpone': Reparto.latticiniUova,
    'pasta': Reparto.pastaRiso, 'spaghetti': Reparto.pastaRiso,
    'penne': Reparto.pastaRiso, 'cous': Reparto.pastaRiso,
    'pomodor': Reparto.conserveCondimenti, 'pesto': Reparto.conserveCondimenti,
    'spezie': Reparto.conserveCondimenti, 'dado': Reparto.conserveCondimenti,
    'brodo': Reparto.conserveCondimenti,
    'biscott': Reparto.colazioneDolci, 'torta': Reparto.colazioneDolci,
    'cacao': Reparto.colazioneDolci, 'caramell': Reparto.colazioneDolci,
    'surgelat': Reparto.surgelati, 'gelat': Reparto.surgelati,
    'acqua': Reparto.bevande, 'succo': Reparto.bevande, 'vino': Reparto.bevande,
    'bibit': Reparto.bevande, 'aranciata': Reparto.bevande,
    'detersiv': Reparto.puliziaCasa, 'pulit': Reparto.puliziaCasa,
    'carta': Reparto.puliziaCasa, 'sacchett': Reparto.puliziaCasa,
    'scope': Reparto.puliziaCasa, 'stracc': Reparto.puliziaCasa,
    'sapone': Reparto.igienePersonale, 'crema': Reparto.igienePersonale,
    'deodor': Reparto.igienePersonale, 'cerott': Reparto.igienePersonale,
    'bimb': Reparto.bambini, 'neonat': Reparto.bambini,
    'cane': Reparto.animali, 'gatt': Reparto.animali, 'croccant': Reparto.animali,
  };
  for (final e in parole.entries) {
    if (t.contains(e.key)) return e.value;
  }
  return Reparto.altro;
}
