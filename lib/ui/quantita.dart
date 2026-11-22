import 'package:material_ui/material_ui.dart';

import '../nutrizione.dart';

/// Quantità scelta: a pezzi/confezioni oppure a peso (g, o ml per i liquidi).
class Quantita {
  const Quantita({this.aPeso = false, this.pezzi = 1, this.grammi = 500});
  final bool aPeso;
  final int pezzi;
  final int grammi;

  Quantita copyWith({bool? aPeso, int? pezzi, int? grammi}) => Quantita(
    aPeso: aPeso ?? this.aPeso,
    pezzi: pezzi ?? this.pezzi,
    grammi: grammi ?? this.grammi,
  );

  int? kcal(Nutrizione? n) => n?.kcalPer(aPeso ? grammi : pezzi * n.unita);
}

/// Pezzi oppure peso, con le calorie calcolate mentre si sceglie.
class SceltaQuantita extends StatelessWidget {
  const SceltaQuantita({
    super.key,
    required this.nutrizione,
    required this.valore,
    required this.onChanged,
  });

  final Nutrizione? nutrizione;
  final Quantita valore;
  final ValueChanged<Quantita> onChanged;

  static int _passo(int g) => g < 500 ? 50 : (g < 2000 ? 100 : 250);

  Future<void> _scriviPeso(BuildContext context, bool liquido) async {
    final ctrl = TextEditingController(text: '${valore.grammi}');
    final g = await showDialog<int>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(liquido ? 'Quanti millilitri?' : 'Quanti grammi?'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: liquido ? 'ml' : 'g',
            helperText: liquido ? '1 litro = 1000 ml' : '1 kg = 1000 g',
          ),
          onSubmitted: (t) => Navigator.pop(c, int.tryParse(t)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, int.tryParse(ctrl.text)),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (g != null && g > 0) onChanged(valore.copyWith(grammi: g));
  }

  @override
  Widget build(BuildContext context) {
    final n = nutrizione;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final liquido = n?.liquido ?? false;
    final kcal = valore.kcal(n);

    final pezzi = Row(
      children: [
        Expanded(
          child: Text(
            n == null
                ? 'Quantità'
                : '1 ${n.pezzo != null ? 'pezzo' : 'confezione'} ≈ '
                      '${formatoPeso(n.unita, liquido: liquido)}',
            style: tt.bodyMedium,
          ),
        ),
        _Stepper(
          testo: '${valore.pezzi}',
          meno: valore.pezzi > 1
              ? () => onChanged(valore.copyWith(pezzi: valore.pezzi - 1))
              : null,
          piu: () => onChanged(valore.copyWith(pezzi: valore.pezzi + 1)),
        ),
      ],
    );

    final scelte = liquido
        ? const [250, 500, 1000, 1500, 2000]
        : const [100, 250, 500, 1000, 2000];
    final peso = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final g in scelte)
              ChoiceChip(
                label: Text(formatoPeso(g, liquido: liquido)),
                selected: valore.grammi == g,
                onSelected: (_) => onChanged(valore.copyWith(grammi: g)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Scrivi il peso'),
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                onPressed: () => _scriviPeso(context, liquido),
              ),
            ),
            _Stepper(
              testo: formatoPeso(valore.grammi, liquido: liquido),
              larghezza: 86,
              onTap: () => _scriviPeso(context, liquido),
              meno: valore.grammi > _passo(valore.grammi - 1)
                  ? () => onChanged(
                      valore.copyWith(
                        grammi: valore.grammi - _passo(valore.grammi - 1),
                      ),
                    )
                  : null,
              piu: () => onChanged(
                valore.copyWith(grammi: valore.grammi + _passo(valore.grammi)),
              ),
            ),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (n != null) ...[
          SegmentedButton<bool>(
            segments: [
              const ButtonSegment(
                value: false,
                icon: Icon(Icons.inventory_2_outlined),
                label: Text('Pezzi'),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.scale_outlined),
                label: Text(liquido ? 'Litri / ml' : 'Peso (g / kg)'),
              ),
            ],
            selected: {valore.aPeso},
            onSelectionChanged: (s) => onChanged(
              valore.copyWith(
                aPeso: s.first,
                // passando a peso propone il peso dei pezzi scelti
                grammi: s.first ? valore.pezzi * n.unita : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        valore.aPeso ? peso : pezzi,
        if (kcal != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.local_fire_department, size: 18, color: cs.tertiary),
              const SizedBox(width: 6),
              Text(
                '≈ ${formatoKcal(kcal)}',
                style: tt.titleSmall?.copyWith(color: cs.tertiary),
              ),
              Text(
                '   (${n!.kcal} kcal ogni 100 ${liquido ? 'ml' : 'g'})',
                style: tt.bodySmall,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.testo,
    required this.meno,
    required this.piu,
    this.larghezza = 40,
    this.onTap,
  });
  final String testo;
  final VoidCallback? meno;
  final VoidCallback piu;
  final double larghezza;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton.filledTonal(onPressed: meno, icon: const Icon(Icons.remove)),
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: larghezza,
          child: Text(
            testo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      IconButton.filledTonal(onPressed: piu, icon: const Icon(Icons.add)),
    ],
  );
}
