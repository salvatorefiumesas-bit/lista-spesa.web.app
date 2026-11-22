import 'package:material_ui/material_ui.dart';

import '../catalogo.dart';
import '../models.dart';
import '../stato.dart';
import 'comuni.dart';
import 'lista_page.dart' show QuantitaSelettore;

/// Scelta dei prodotti: reparti → prodotti → marca.
class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final _cerca = TextEditingController();
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi prodotti'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SearchBar(
              controller: _cerca,
              hintText: 'Cerca prodotto o marca (es. Dash)',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              trailing: [
                if (_q.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      _cerca.clear();
                      _q = '';
                    }),
                  ),
              ],
              onChanged: (t) => setState(() => _q = t),
            ),
          ),
        ),
      ),
      body: _q.trim().isEmpty
          ? _GrigliaReparti(stato: stato)
          : _Risultati(
              stato: stato,
              q: _q,
              // Dopo aver aggiunto, svuota la ricerca per il prossimo prodotto.
              onAggiunto: () => setState(() {
                _cerca.clear();
                _q = '';
              }),
            ),
    );
  }
}

class _GrigliaReparti extends StatelessWidget {
  const _GrigliaReparti({required this.stato});
  final Stato stato;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: Reparto.values.length,
      itemBuilder: (context, i) {
        final r = Reparto.values[i];
        final n = stato.prodottiDi(r).length;
        return Material(
          color: r.colore.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => RepartoPage(reparto: r))),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.emoji, style: const TextStyle(fontSize: 34)),
                  const Spacer(),
                  Text(r.nome,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: r.colore, height: 1.15)),
                  Text('$n prodotti', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Risultati extends StatelessWidget {
  const _Risultati({required this.stato, required this.q, required this.onAggiunto});
  final Stato stato;
  final String q;
  final VoidCallback onAggiunto;

  @override
  Widget build(BuildContext context) {
    final risultati = stato.cerca(q);
    final t = normalizza(q);
    final esatto = risultati.any((p) => normalizza(p.nome) == t);
    return ListView(
      children: [
        for (final p in risultati)
          RigaProdotto(
            prodotto: p,
            onAggiunto: onAggiunto,
            // Se ho cercato una marca (es. "Dash"), la propongo già.
            marcaSuggerita: p.marche
                .where((m) => normalizza(m).contains(t) && !normalizza(p.nome).contains(t))
                .firstOrNull,
          ),
        if (!esatto)
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.add)),
            title: Text('Aggiungi «${q.trim()}»'),
            subtitle: const Text('Nuovo prodotto: lo ricorderò per le prossime volte'),
            onTap: () async {
              if (await nuovoProdotto(context, stato, q.trim())) onAggiunto();
            },
          ),
      ],
    );
  }
}

class RepartoPage extends StatelessWidget {
  const RepartoPage({super.key, required this.reparto});
  final Reparto reparto;

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    final prodotti = stato.prodottiDi(reparto);
    return Scaffold(
      appBar: AppBar(
        title: Text('${reparto.emoji}  ${reparto.nome}'),
        backgroundColor: reparto.colore.withValues(alpha: .12),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => nuovoProdotto(context, stato, '', reparto: reparto),
        icon: const Icon(Icons.add),
        label: const Text('Altro prodotto'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [for (final p in prodotti) RigaProdotto(prodotto: p)],
      ),
    );
  }
}

class RigaProdotto extends StatelessWidget {
  const RigaProdotto({super.key, required this.prodotto, this.marcaSuggerita, this.onAggiunto});
  final Prodotto prodotto;
  final String? marcaSuggerita;
  final VoidCallback? onAggiunto;

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    final p = prodotto;
    final inLista = stato.quantiInLista(p);
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: ProdottoAvatar(emoji: p.emoji, reparto: p.reparto),
      title: Text(p.nome, style: const TextStyle(fontSize: 16)),
      subtitle: Text(
        marcaSuggerita ??
            (p.marche.isEmpty
                ? p.reparto.nome
                : '${p.marche.take(3).join(', ')}${p.marche.length > 3 ? '…' : ''}'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (inLista > 0)
            Chip(
              label: Text('$inLista in lista'),
              visualDensity: VisualDensity.compact,
              backgroundColor: cs.primaryContainer,
              side: BorderSide.none,
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () async {
        if (await sceltaMarca(context, stato, p, marcaIniziale: marcaSuggerita)) {
          onAggiunto?.call();
        }
      },
    );
  }
}

/// Foglio con le marche del prodotto (con immagine) e la quantità.
/// Restituisce true se il prodotto è stato aggiunto alla lista.
Future<bool> sceltaMarca(BuildContext context, Stato stato, Prodotto p,
    {String? marcaIniziale}) async {
  final aggiunto = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => StatoScope(
      stato: stato,
      child: _SceltaMarca(prodottoId: p.id, prodottoIniziale: p, marcaIniziale: marcaIniziale),
    ),
  );
  return aggiunto ?? false;
}

class _SceltaMarca extends StatefulWidget {
  const _SceltaMarca({required this.prodottoId, required this.prodottoIniziale, this.marcaIniziale});
  final String prodottoId;
  final Prodotto prodottoIniziale;
  final String? marcaIniziale;

  @override
  State<_SceltaMarca> createState() => _SceltaMarcaState();
}

class _SceltaMarcaState extends State<_SceltaMarca> {
  int _q = 1;

  Future<void> _aggiungi(Prodotto p, String? marca) async {
    final stato = StatoScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    await stato.aggiungi(p, marca: marca, quantita: _q);
    if (!mounted) return;
    Navigator.pop(context, true);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text('Aggiunto: ${_q > 1 ? '$_q × ' : ''}${p.nome}${marca != null ? ' $marca' : ''}'),
      ));
  }

  Future<void> _nuovaMarca(Prodotto p) async {
    final stato = StatoScope.read(context);
    final ctrl = TextEditingController();
    final marca = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Nuova marca di ${p.nome.toLowerCase()}'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Nome della marca'),
          onSubmitted: (t) => Navigator.pop(c, t),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Annulla')),
          FilledButton(onPressed: () => Navigator.pop(c, ctrl.text), child: const Text('Aggiungi')),
        ],
      ),
    );
    if (marca == null || marca.trim().isEmpty) return;
    await stato.aggiungiMarca(p, marca);
    await _aggiungi(p, marca.trim());
  }

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    final p = stato.catalogo.where((x) => x.id == widget.prodottoId).firstOrNull ??
        widget.prodottoIniziale;
    final marche = [...p.marche];
    if (widget.marcaIniziale != null) {
      marche
        ..remove(widget.marcaIniziale)
        ..insert(0, widget.marcaIniziale!);
    }
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: marche.length > 4 ? .75 : .55,
      maxChildSize: .95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
            child: Row(
              children: [
                ProdottoAvatar(emoji: p.emoji, reparto: p.reparto, size: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.nome, style: Theme.of(context).textTheme.titleLarge),
                      Text(p.reparto.nome, style: TextStyle(color: p.reparto.colore)),
                    ],
                  ),
                ),
                QuantitaSelettore(valore: _q, onChanged: (x) => setState(() => _q = x)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Scegli la marca', style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          Expanded(
            child: GridView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 130,
                childAspectRatio: .95,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              children: [
                _TesseraMarca(
                  icona: ProdottoAvatar(emoji: p.emoji, reparto: p.reparto, size: 52),
                  testo: 'Qualsiasi',
                  onTap: () => _aggiungi(p, null),
                ),
                for (final m in marche)
                  _TesseraMarca(
                    icona: MarcaAvatar(m, size: 52),
                    testo: m,
                    evidenziata: m == widget.marcaIniziale,
                    onTap: () => _aggiungi(p, m),
                  ),
                _TesseraMarca(
                  icona: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.outline),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.add, color: cs.primary),
                  ),
                  testo: 'Altra marca',
                  onTap: () => _nuovaMarca(p),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TesseraMarca extends StatelessWidget {
  const _TesseraMarca({
    required this.icona,
    required this.testo,
    required this.onTap,
    this.evidenziata = false,
  });
  final Widget icona;
  final String testo;
  final VoidCallback onTap;
  final bool evidenziata;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: evidenziata ? cs.primaryContainer : cs.surfaceContainerHighest.withValues(alpha: .5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icona,
              const SizedBox(height: 8),
              Text(testo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, height: 1.1)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Crea un prodotto che non c'è nel catalogo, con il reparto indovinato.
Future<bool> nuovoProdotto(BuildContext context, Stato stato, String nomeIniziale,
    {Reparto? reparto}) async {
  final ctrl = TextEditingController(text: nomeIniziale);
  var scelto = reparto ?? indovinaReparto(nomeIniziale, stato.catalogo);
  var toccatoReparto = reparto != null;

  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: const Text('Nuovo prodotto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              autofocus: nomeIniziale.isEmpty,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nome (es. Lenticchie)'),
              onChanged: (t) {
                if (!toccatoReparto) {
                  setState(() => scelto = indovinaReparto(t, stato.catalogo));
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Reparto>(
              initialValue: scelto,
              key: ValueKey(scelto),
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Reparto'),
              items: [
                for (final r in Reparto.values)
                  DropdownMenuItem(value: r, child: Text('${r.emoji}  ${r.nome}')),
              ],
              onChanged: (r) => setState(() {
                scelto = r ?? scelto;
                toccatoReparto = true;
              }),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annulla')),
          FilledButton(
            onPressed: () => Navigator.pop(c, ctrl.text.trim().isNotEmpty),
            child: const Text('Avanti'),
          ),
        ],
      ),
    ),
  );
  if (ok != true || !context.mounted) return false;
  final p = await stato.creaProdotto(ctrl.text, scelto);
  if (!context.mounted) return false;
  return sceltaMarca(context, stato, p);
}
