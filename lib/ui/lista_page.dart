import 'package:material_ui/material_ui.dart';

import '../condividi.dart';
import '../models.dart';
import '../stato.dart';
import 'catalogo_page.dart';
import 'comuni.dart';
import 'famiglia_page.dart';
import 'installa_banner.dart';

class ListaPage extends StatelessWidget {
  const ListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    final gruppi = stato.daPrendere;
    final presi = stato.presi;
    final daPrendere = gruppi.fold(0, (s, g) => s + g.$2.length);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lista della spesa'),
            Text(
              daPrendere == 0 && presi.isEmpty
                  ? 'Vuota'
                  : '$daPrendere da prendere · ${presi.length} nel carrello',
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Condividi l\'app (anche per iPhone)',
            icon: const Icon(Icons.share),
            onPressed: () => condividiApp(context, codiceFamiglia: stato.codiceFamiglia),
          ),
          IconButton(
            tooltip: stato.inFamiglia ? 'Famiglia (condivisa)' : 'Condividi la lista',
            icon: Icon(stato.inFamiglia ? Icons.people : Icons.person_add_alt_1),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const FamigliaPage())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CatalogoPage())),
        icon: const Icon(Icons.add),
        label: const Text('Aggiungi'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          const InstallaBanner(),
          if (!stato.inFamiglia && !stato.flag('banner-famiglia-chiuso'))
            _BannerFamiglia(stato: stato),
          if (gruppi.isEmpty && presi.isEmpty) const _ListaVuota(),
          for (final (reparto, voci) in gruppi) ...[
            _TitoloReparto(reparto: reparto, quanti: voci.length),
            for (final v in voci) _RigaVoce(voce: v),
          ],
          if (gruppi.isEmpty && presi.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const Text('🎉', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text('Hai preso tutto!', style: Theme.of(context).textTheme.titleMedium),
              ]),
            ),
          if (presi.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 8, 4),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, size: 20, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Nel carrello (${presi.length})',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: const Text('Togli dalla lista'),
                    onPressed: () => _confermaTogliPresi(context, stato),
                  ),
                ],
              ),
            ),
            for (final v in presi) _RigaVoce(voce: v),
          ],
        ],
      ),
    );
  }

  Future<void> _confermaTogliPresi(BuildContext context, Stato stato) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Spesa finita?'),
        content: const Text('Tolgo dalla lista tutti i prodotti già nel carrello.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annulla')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Togli')),
        ],
      ),
    );
    if (ok == true) await stato.togliPresi();
  }
}

class _TitoloReparto extends StatelessWidget {
  const _TitoloReparto({required this.reparto, required this.quanti});
  final Reparto reparto;
  final int quanti;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                  color: reparto.colore, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 10),
            Text(reparto.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(reparto.nome,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700, color: reparto.colore)),
            const SizedBox(width: 6),
            Text('$quanti', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}

class _RigaVoce extends StatelessWidget {
  const _RigaVoce({required this.voce});
  final Voce voce;

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.read(context);
    final cs = Theme.of(context).colorScheme;
    final v = voce;
    final dettagli = [
      if (v.nota != null && v.nota!.isNotEmpty) v.nota!,
      if (v.presa && v.presaDa != null)
        'preso da ${v.presaDa}'
      else if (v.aggiuntaDa != null && stato.inFamiglia)
        'da ${v.aggiuntaDa}',
    ].join(' · ');

    return Dismissible(
      key: ValueKey(v.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: cs.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete_outline, color: cs.onErrorContainer),
      ),
      onDismissed: (_) {
        stato.elimina(v);
        avviso(context, '${v.nome} tolto dalla lista',
            azione: SnackBarAction(label: 'Annulla', onPressed: () => stato.ripristina(v)));
      },
      child: Opacity(
        opacity: v.presa ? .55 : 1,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 4, right: 8),
          onTap: () => stato.segna(v, !v.presa),
          onLongPress: () => _modifica(context, stato, v),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: v.presa,
                shape: const CircleBorder(),
                onChanged: (x) => stato.segna(v, x ?? false),
              ),
              v.marca != null
                  ? MarcaAvatar(v.marca!, size: 40)
                  : ProdottoAvatar(emoji: v.emoji, reparto: v.reparto, size: 40),
            ],
          ),
          title: Text.rich(
            TextSpan(children: [
              TextSpan(text: v.nome),
              if (v.marca != null)
                TextSpan(
                    text: '  ${v.marca}',
                    style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
            ]),
            style: TextStyle(
              decoration: v.presa ? TextDecoration.lineThrough : null,
              fontSize: 16,
            ),
          ),
          subtitle: dettagli.isEmpty ? null : Text(dettagli),
          trailing: v.quantita > 1
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: cs.secondaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Text('×${v.quantita}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: cs.onSecondaryContainer)),
                )
              : null,
        ),
      ),
    );
  }

  void _modifica(BuildContext context, Stato stato, Voce v) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (c) => _ModificaVoce(stato: stato, voce: v),
    );
  }
}

class _ModificaVoce extends StatefulWidget {
  const _ModificaVoce({required this.stato, required this.voce});
  final Stato stato;
  final Voce voce;

  @override
  State<_ModificaVoce> createState() => _ModificaVoceState();
}

class _ModificaVoceState extends State<_ModificaVoce> {
  late int _q = widget.voce.quantita;
  late final _nota = TextEditingController(text: widget.voce.nota ?? '');

  @override
  Widget build(BuildContext context) {
    final v = widget.voce;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text([v.nome, if (v.marca != null) v.marca].join(' · '),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Quantità', style: TextStyle(fontSize: 16)),
              const Spacer(),
              QuantitaSelettore(valore: _q, onChanged: (x) => setState(() => _q = x)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nota,
            decoration: const InputDecoration(
              labelText: 'Nota (es. "quello grande", "senza lattosio")',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Elimina'),
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                onPressed: () {
                  widget.stato.elimina(v);
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  widget.stato.cambiaQuantita(v, _q);
                  if ((_nota.text.trim()) != (v.nota ?? '')) {
                    widget.stato.cambiaNota(v.copyWith(quantita: _q), _nota.text);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Salva'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerFamiglia extends StatelessWidget {
  const _BannerFamiglia({required this.stato});
  final Stato stato;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      color: cs.secondaryContainer,
      elevation: 0,
      child: ListTile(
        leading: const Icon(Icons.people_outline),
        title: const Text('Condividi la lista in famiglia'),
        subtitle: const Text('Chi aggiunge e chi compra vedono la stessa lista, in tempo reale.'),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const FamigliaPage())),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => stato.setFlag('banner-famiglia-chiuso', true),
        ),
      ),
    );
  }
}

class _ListaVuota extends StatelessWidget {
  const _ListaVuota();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
        child: Column(
          children: [
            const Text('🛒', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('La lista è vuota', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tocca "Aggiungi", scegli il prodotto e la marca.\n'
              'La lista si ordina da sola per reparto.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
}

/// Pulsanti − 2 + per scegliere la quantità.
class QuantitaSelettore extends StatelessWidget {
  const QuantitaSelettore({super.key, required this.valore, required this.onChanged});
  final int valore;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            onPressed: valore > 1 ? () => onChanged(valore - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Text('$valore',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          IconButton.filledTonal(
            onPressed: () => onChanged(valore + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      );
}
