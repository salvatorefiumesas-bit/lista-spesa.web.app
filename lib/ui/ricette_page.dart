import 'package:material_ui/material_ui.dart';

import '../catalogo.dart';
import '../nutrizione.dart';
import '../ricette.dart';
import '../stato.dart';
import 'comuni.dart';

/// Idee per pranzo e cena: si sceglie un piatto e i suoi ingredienti
/// finiscono in lista con le dosi giuste.
class RicettePage extends StatefulWidget {
  const RicettePage({super.key, this.categoria});
  final CategoriaRicetta? categoria;

  @override
  State<RicettePage> createState() => _RicettePageState();
}

class _RicettePageState extends State<RicettePage> {
  late CategoriaRicetta? _cat = widget.categoria;
  String _q = '';
  bool _leggere = false;

  @override
  Widget build(BuildContext context) {
    final t = normalizza(_q);
    final elenco =
        ricette
            .where((r) => _cat == null || r.categoria == _cat)
            .where(
              (r) =>
                  t.isEmpty ||
                  normalizza(r.nome).contains(t) ||
                  r.ingredienti.any(
                    (i) => normalizza(i.prodotto.nome).contains(t),
                  ),
            )
            .toList()
          ..sort(
            (a, b) => _leggere
                ? a.kcalPorzione - b.kcalPorzione
                : a.nome.compareTo(b.nome),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Idee per pranzo e cena'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: SearchBar(
                  hintText: 'Cerca piatto o ingrediente (es. tacchino)',
                  leading: const Icon(Icons.search),
                  elevation: const WidgetStatePropertyAll(0),
                  onChanged: (x) => setState(() => _q = x),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    FilterChip(
                      avatar: const Icon(Icons.local_fire_department, size: 18),
                      label: const Text('Più leggere'),
                      selected: _leggere,
                      onSelected: (x) => setState(() => _leggere = x),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('Tutte'),
                      selected: _cat == null,
                      onSelected: (_) => setState(() => _cat = null),
                    ),
                    for (final c in CategoriaRicetta.values) ...[
                      const SizedBox(width: 6),
                      ChoiceChip(
                        label: Text('${c.emoji} ${c.nome}'),
                        selected: _cat == c,
                        onSelected: (_) => setState(() => _cat = c),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: elenco.isEmpty
          ? const Center(child: Text('Nessun piatto trovato'))
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: elenco.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
              itemBuilder: (context, i) => RigaRicetta(ricetta: elenco[i]),
            ),
    );
  }
}

class RigaRicetta extends StatelessWidget {
  const RigaRicetta({super.key, required this.ricetta});
  final Ricetta ricetta;

  @override
  Widget build(BuildContext context) {
    final r = ricetta;
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.tertiaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(r.emoji, style: const TextStyle(fontSize: 26)),
      ),
      title: Text(r.nome),
      subtitle: Text(
        '${formatoKcal(r.kcalPorzione)} a porzione · ${r.minuti} min · '
        '${r.ingredienti.length} ingredienti',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => apriRicetta(context, r),
    );
  }
}

Future<void> apriRicetta(BuildContext context, Ricetta r) {
  final stato = StatoScope.read(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => StatoScope(
      stato: stato,
      child: _SchedaRicetta(ricetta: r),
    ),
  );
}

class _SchedaRicetta extends StatefulWidget {
  const _SchedaRicetta({required this.ricetta});
  final Ricetta ricetta;

  @override
  State<_SchedaRicetta> createState() => _SchedaRicettaState();
}

class _SchedaRicettaState extends State<_SchedaRicetta> {
  int _persone = 2;

  // Gli ingredienti di dispensa (olio, pepe…) sono proposti ma non spuntati.
  late final Set<String> _scelti = {
    for (final i in widget.ricetta.ingredienti)
      if (!i.dispensa) i.prodottoId,
  };

  @override
  Widget build(BuildContext context) {
    final r = widget.ricetta;
    final stato = StatoScope.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .9,
      maxChildSize: .95,
      builder: (context, scroll) => Column(
        children: [
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              children: [
                Row(
                  children: [
                    Text(r.emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.nome, style: tt.titleLarge),
                          Text(
                            '${r.categoria.nome} · ${r.minuti} minuti',
                            style: tt.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  color: cs.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: cs.onTertiaryContainer,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatoKcal(r.kcalPorzione)} a porzione',
                                style: tt.titleMedium?.copyWith(
                                  color: cs.onTertiaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Piatto completo per $_persone: '
                                '${formatoKcal(r.kcalPorzione * _persone)}'
                                ' · porzione ≈ ${formatoPeso(r.grammiPorzione)} di ingredienti',
                                style: TextStyle(color: cs.onTertiaryContainer),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.people_outline),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Persone', style: TextStyle(fontSize: 16)),
                    ),
                    IconButton.filledTonal(
                      onPressed: _persone > 1
                          ? () => setState(() => _persone--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '$_persone',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: _persone < 20
                          ? () => setState(() => _persone++)
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Ingredienti per $_persone', style: tt.titleSmall),
                Text(
                  'Spunta quelli da comprare. Olio, pepe e spezie non sono '
                  'spuntati perché di solito ci sono già in casa.',
                  style: tt.bodySmall,
                ),
                const SizedBox(height: 4),
                for (final i in r.ingredienti) _rigaIngrediente(stato, i),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(
                    _scelti.isEmpty
                        ? 'Scegli almeno un ingrediente'
                        : 'Aggiungi ${_scelti.length} ingredienti alla lista',
                  ),
                  onPressed: _scelti.isEmpty
                      ? null
                      : () {
                          final messenger = ScaffoldMessenger.of(context);
                          final n = stato.aggiungiRicetta(r, _persone, _scelti);
                          Navigator.pop(context);
                          messenger
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  '${r.nome} per $_persone: '
                                  '$n ingredienti in lista',
                                ),
                              ),
                            );
                        },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rigaIngrediente(Stato stato, Ingrediente i) {
    final p = i.prodotto;
    final n = nutrizioneDi(i.prodottoId);
    final g = i.grammi * _persone;
    final pezzi = n?.pezzo != null && g >= n!.pezzo! * .8
        ? ' (≈ ${(g / n.pezzo!).round()} pz)'
        : '';
    final kcal = i.kcal(_persone);
    final scelto = _scelti.contains(i.prodottoId);
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: scelto,
      onChanged: (x) => setState(
        () => x == true
            ? _scelti.add(i.prodottoId)
            : _scelti.remove(i.prodottoId),
      ),
      secondary: Text(
        kcal > 0 ? formatoKcal(kcal) : '',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      title: Text('${p.emoji}  ${p.nome}'),
      subtitle: Text(
        '${formatoPeso(g, liquido: n?.liquido ?? false)}$pezzi'
        '${i.dispensa ? ' · di solito in dispensa' : ''}',
      ),
    );
  }
}
