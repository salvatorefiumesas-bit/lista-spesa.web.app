import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../installa/installa.dart';
import 'comuni.dart';

class FamigliaPage extends StatefulWidget {
  const FamigliaPage({super.key});

  @override
  State<FamigliaPage> createState() => _FamigliaPageState();
}

class _FamigliaPageState extends State<FamigliaPage> {
  late final _nome = TextEditingController(text: StatoScope.read(context).nome);
  final _codice = TextEditingController();
  bool _occupato = false;

  Future<void> _esegui(Future<String?> Function() f) async {
    setState(() => _occupato = true);
    final errore = await f();
    if (!mounted) return;
    setState(() => _occupato = false);
    if (errore != null) avviso(context, errore);
  }

  String _invito(String codice) {
    final url = indirizzoApp();
    return 'Ecco la nostra lista della spesa condivisa!\n'
        '${url.isNotEmpty ? '1. Apri $url\n' : '1. Apri l\'app Lista Spesa\n'}'
        '2. Tocca l\'icona delle persone in alto → "Entra con un codice"\n'
        '3. Scrivi il codice: $codice';
  }

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Famiglia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nome,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Il tuo nome',
              helperText: 'Così l\'altro vede chi ha aggiunto o comprato un prodotto',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: stato.impostaNome,
          ),
          const SizedBox(height: 24),
          if (!stato.condivisioneDisponibile) ...[
            Card(
              elevation: 0,
              color: cs.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.cloud_off, color: cs.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text('Condivisione non ancora attiva', style: tt.titleMedium),
                    ]),
                    const SizedBox(height: 8),
                    Text(
                      stato.erroreFirebase == null
                          ? 'Per ora la lista resta solo su questo telefono. '
                              'La condivisione si attiva appena viene collegato Firebase.'
                          : 'Impossibile collegarsi al servizio di condivisione. '
                              'Controlla la connessione e riapri l\'app.',
                    ),
                  ],
                ),
              ),
            ),
          ] else if (stato.inFamiglia) ...[
            Text('Codice della famiglia', style: tt.labelLarge),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectableText(
                stato.codiceFamiglia!.split('').join(' '),
                textAlign: TextAlign.center,
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copia l\'invito da mandare'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _invito(stato.codiceFamiglia!)));
                if (context.mounted) {
                  avviso(context, 'Invito copiato: incollalo su WhatsApp o in un messaggio');
                }
              },
            ),
            const SizedBox(height: 24),
            Text('Nella lista', style: tt.labelLarge),
            for (final e in stato.membri.entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(e.value.isEmpty ? '?' : e.value[0].toUpperCase()),
                ),
                title: Text(e.value.isEmpty ? 'Senza nome' : e.value),
                subtitle: e.key == stato.uid ? const Text('Tu') : null,
              ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Esci dalla famiglia'),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Uscire dalla famiglia?'),
                    content: const Text(
                        'Non vedrai più la lista condivisa. Potrai rientrare con il codice.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const Text('Annulla')),
                      FilledButton(
                          onPressed: () => Navigator.pop(c, true), child: const Text('Esci')),
                    ],
                  ),
                );
                if (ok == true) await stato.esciDallaFamiglia();
              },
            ),
          ] else ...[
            Text('Condividi la lista', style: tt.titleMedium),
            const SizedBox(height: 4),
            const Text(
              'Uno dei due crea la famiglia e manda il codice all\'altro. '
              'Da quel momento vedete la stessa lista e le spunte in tempo reale.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.group_add),
              label: const Text('Crea la famiglia'),
              onPressed: _occupato ? null : () => _esegui(stato.creaFamiglia),
            ),
            const SizedBox(height: 32),
            Text('Hai ricevuto un codice?', style: tt.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _codice,
              textCapitalization: TextCapitalization.characters,
              maxLength: 7,
              decoration: const InputDecoration(
                labelText: 'Codice di 6 caratteri',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
            ),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.login),
              label: const Text('Entra con un codice'),
              onPressed: _occupato ? null : () => _esegui(() => stato.entraInFamiglia(_codice.text)),
            ),
          ],
          if (_occupato) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
