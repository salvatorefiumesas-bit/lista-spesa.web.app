import 'package:material_ui/material_ui.dart';

/// I reparti del supermercato. L'ordine qui è l'ordine in cui compaiono
/// nella lista (più o meno il percorso tipico di un supermercato).
enum Reparto {
  fruttaVerdura('Frutta e verdura', '🥦', Color(0xFF43A047)),
  panetteria('Pane e forno', '🥖', Color(0xFFB7791F)),
  carne('Carne', '🥩', Color(0xFFC62828)),
  pesce('Pesce', '🐟', Color(0xFF0277BD)),
  salumiFormaggi('Salumi e formaggi', '🧀', Color(0xFFEF8F00)),
  latticiniUova('Latte, latticini e uova', '🥛', Color(0xFF5C6BC0)),
  pastaRiso('Pasta, riso e farina', '🍝', Color(0xFFD4A017)),
  conserveCondimenti('Conserve e condimenti', '🥫', Color(0xFFD84315)),
  colazioneDolci('Colazione e dolci', '☕', Color(0xFF6D4C41)),
  snackAperitivo('Snack e aperitivo', '🍿', Color(0xFFF9A825)),
  surgelati('Surgelati', '🧊', Color(0xFF00ACC1)),
  bevande('Bevande', '🥤', Color(0xFF1E88E5)),
  puliziaCasa('Pulizia casa', '🧽', Color(0xFF00897B)),
  igienePersonale('Igiene personale', '🧴', Color(0xFF8E24AA)),
  bambini('Bambini', '👶', Color(0xFFEC407A)),
  animali('Animali', '🐾', Color(0xFF795548)),
  altro('Altro', '🛒', Color(0xFF757575));

  const Reparto(this.nome, this.emoji, this.colore);
  final String nome;
  final String emoji;
  final Color colore;

  static Reparto daNome(String? n) =>
      Reparto.values.firstWhere((r) => r.name == n, orElse: () => Reparto.altro);
}

/// Un prodotto del catalogo (es. "Deodorante") con le marche disponibili.
class Prodotto {
  const Prodotto({
    required this.id,
    required this.nome,
    required this.reparto,
    required this.emoji,
    this.marche = const [],
    this.personale = false,
  });

  final String id;
  final String nome;
  final Reparto reparto;
  final String emoji;
  final List<String> marche;

  /// true se aggiunto da voi (non fa parte del catalogo di base).
  final bool personale;

  Prodotto copyWith({List<String>? marche}) => Prodotto(
        id: id,
        nome: nome,
        reparto: reparto,
        emoji: emoji,
        marche: marche ?? this.marche,
        personale: personale,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'reparto': reparto.name,
        'emoji': emoji,
        'marche': marche,
      };

  factory Prodotto.fromMap(Map<String, dynamic> m) => Prodotto(
        id: m['id'] as String,
        nome: m['nome'] as String? ?? '',
        reparto: Reparto.daNome(m['reparto'] as String?),
        emoji: m['emoji'] as String? ?? '🛒',
        marche: List<String>.from(m['marche'] as List? ?? const []),
        personale: true,
      );
}

/// Una riga della lista della spesa.
class Voce {
  Voce({
    required this.id,
    required this.nome,
    required this.reparto,
    required this.emoji,
    this.prodottoId,
    this.marca,
    this.quantita = 1,
    this.nota,
    this.presa = false,
    this.aggiuntaDa,
    this.presaDa,
    required this.creata,
  });

  final String id;
  final String? prodottoId;
  final String nome;
  final String? marca;
  final Reparto reparto;
  final String emoji;
  final int quantita;
  final String? nota;
  final bool presa;
  final String? aggiuntaDa;
  final String? presaDa;
  final int creata;

  /// Chiave per riconoscere lo stesso prodotto della stessa marca.
  String get chiave => '${nome.toLowerCase()}|${(marca ?? '').toLowerCase()}';

  Voce copyWith({
    int? quantita,
    bool? presa,
    String? presaDa,
    bool azzeraPresaDa = false,
    String? nota,
  }) =>
      Voce(
        id: id,
        prodottoId: prodottoId,
        nome: nome,
        marca: marca,
        reparto: reparto,
        emoji: emoji,
        quantita: quantita ?? this.quantita,
        nota: nota ?? this.nota,
        presa: presa ?? this.presa,
        aggiuntaDa: aggiuntaDa,
        presaDa: azzeraPresaDa ? null : (presaDa ?? this.presaDa),
        creata: creata,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'prodottoId': prodottoId,
        'nome': nome,
        'marca': marca,
        'reparto': reparto.name,
        'emoji': emoji,
        'quantita': quantita,
        'nota': nota,
        'presa': presa,
        'aggiuntaDa': aggiuntaDa,
        'presaDa': presaDa,
        'creata': creata,
      };

  factory Voce.fromMap(Map<String, dynamic> m) => Voce(
        id: m['id'] as String,
        prodottoId: m['prodottoId'] as String?,
        nome: m['nome'] as String? ?? '',
        marca: m['marca'] as String?,
        reparto: Reparto.daNome(m['reparto'] as String?),
        emoji: m['emoji'] as String? ?? '🛒',
        quantita: (m['quantita'] as num?)?.toInt() ?? 1,
        nota: m['nota'] as String?,
        presa: m['presa'] as bool? ?? false,
        aggiuntaDa: m['aggiuntaDa'] as String?,
        presaDa: m['presaDa'] as String?,
        creata: (m['creata'] as num?)?.toInt() ?? 0,
      );
}

String nuovoId() {
  final t = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final r = (DateTime.now().hashCode ^ identityHashCode(Object()))
      .abs()
      .toRadixString(36);
  return '$t$r';
}
