import 'package:material_ui/material_ui.dart';

import '../installa/installa.dart';
import 'comuni.dart';

/// Banner "Installa l'app" mostrato nella versione web finché l'app non è
/// sulla schermata Home. Su iPhone spiega i passaggi, su Android installa.
class InstallaBanner extends StatefulWidget {
  const InstallaBanner({super.key});

  @override
  State<InstallaBanner> createState() => _InstallaBannerState();
}

class _InstallaBannerState extends State<InstallaBanner> {
  late ModoInstallazione _modo = modoInstallazione();

  @override
  void initState() {
    super.initState();
    quandoInstallabile(() {
      if (mounted) setState(() => _modo = modoInstallazione());
    });
  }

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    if (_modo == ModoInstallazione.nessuno ||
        stato.flag('banner-installa-chiuso')) {
      return const SizedBox.shrink();
    }
    final cs = Theme.of(context).colorScheme;
    final ios = _modo == ModoInstallazione.ios;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      color: cs.primaryContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
        child: Row(
          children: [
            Icon(
              ios ? Icons.ios_share : Icons.install_mobile,
              color: cs.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installa l\'app sul telefono',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ios
                        ? 'Aggiungila alla schermata Home: si apre come un\'app vera.'
                        : 'Un tocco e la trovi tra le tue app.',
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (ios) {
                  mostraIstruzioniIphone(context);
                } else {
                  final ok = await mostraInstallazione();
                  if (mounted) setState(() => _modo = modoInstallazione());
                  if (ok && context.mounted) avviso(context, 'App installata!');
                }
              },
              child: Text(ios ? 'Come fare' : 'Installa'),
            ),
            IconButton(
              tooltip: 'Chiudi',
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => stato.setFlag('banner-installa-chiuso', true),
            ),
          ],
        ),
      ),
    );
  }
}

void mostraIstruzioniIphone(BuildContext context) {
  final altroBrowser = iosNonSafari();
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installa su iPhone',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (altroBrowser) ...[
              const _Passo(
                n: '!',
                icona: Icons.open_in_browser,
                testo:
                    'Stai usando un\'altra app (es. WhatsApp). Apri questa pagina in Safari: '
                    'tocca ⋯ oppure l\'icona della bussola e scegli "Apri in Safari".',
              ),
            ],
            const _Passo(
              n: '1',
              icona: Icons.ios_share,
              testo:
                  'In Safari tocca il pulsante Condividi (il quadrato con la freccia verso l\'alto), '
                  'in basso al centro o in alto a destra.',
            ),
            const _Passo(
              n: '2',
              icona: Icons.add_box_outlined,
              testo: 'Scorri il menu e tocca "Aggiungi alla schermata Home".',
            ),
            const _Passo(
              n: '3',
              icona: Icons.check_circle_outline,
              testo: 'Tocca "Aggiungi" in alto a destra. Trovi l\'icona "Spesa" tra le tue app.',
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ho capito'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Passo extends StatelessWidget {
  const _Passo({required this.n, required this.icona, required this.testo});
  final String n;
  final IconData icona;
  final String testo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: cs.primary,
            child: Text(
              n,
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icona, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(testo, style: const TextStyle(height: 1.35))),
        ],
      ),
    );
  }
}
