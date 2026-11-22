import 'package:material_ui/material_ui.dart';

import '../models.dart';
import '../stato.dart';

/// Rende lo [Stato] disponibile a tutte le schermate.
class StatoScope extends InheritedNotifier<Stato> {
  const StatoScope({super.key, required Stato stato, required super.child})
    : super(notifier: stato);

  static Stato of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StatoScope>()!.notifier!;

  static Stato read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<StatoScope>()!.notifier!;
}

/// Immagine della marca. Per ora un "logo" con le iniziali e un colore fisso
/// per ogni marca; in seguito potrà mostrare la foto del prodotto.
class MarcaAvatar extends StatelessWidget {
  const MarcaAvatar(this.marca, {super.key, this.size = 44});

  final String marca;
  final double size;

  static const _colori = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFB8C00),
    Color(0xFF8E24AA),
    Color(0xFF00897B),
    Color(0xFF3949AB),
    Color(0xFFD81B60),
    Color(0xFF6D4C41),
    Color(0xFF00ACC1),
    Color(0xFF7CB342),
    Color(0xFFF4511E),
  ];

  String get _iniziali {
    final parole = marca
        .replaceAll(RegExp(r"[^A-Za-zÀ-ÿ0-9 ]"), ' ')
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parole.isEmpty) return '?';
    if (parole.length == 1) {
      final p = parole.first;
      return p.length <= 3 && p == p.toUpperCase()
          ? p
          : p.substring(0, p.length >= 2 ? 2 : 1);
    }
    return (parole[0][0] + parole[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c =
        _colori[marca
                .toLowerCase()
                .codeUnits
                .fold(0, (a, b) => a * 31 + b)
                .abs() %
            _colori.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: .35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _iniziali,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * (_iniziali.length > 2 ? 0.3 : 0.38),
          letterSpacing: -.5,
        ),
      ),
    );
  }
}

/// Icona del prodotto (emoji su sfondo del colore del reparto).
class ProdottoAvatar extends StatelessWidget {
  const ProdottoAvatar({
    super.key,
    required this.emoji,
    required this.reparto,
    this.size = 44,
  });

  final String emoji;
  final Reparto reparto;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: reparto.colore.withValues(alpha: .13),
      borderRadius: BorderRadius.circular(size * 0.28),
    ),
    child: Text(emoji, style: TextStyle(fontSize: size * 0.52)),
  );
}

void avviso(BuildContext context, String testo, {SnackBarAction? azione}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(testo),
        action: azione,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
}
