import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import 'installa/installa.dart';
import 'ui/comuni.dart';

/// Indirizzo della versione web (quella che si usa su iPhone).
const indirizzoWeb = 'https://salvatorefiumesas-bit.github.io/lista-spesa.web.app/';

/// Messaggio per installare l'app su iPhone, con il codice famiglia se c'è.
String messaggioInvito({String? codiceFamiglia}) {
  final b = StringBuffer()
    ..writeln('🛒 Lista della spesa condivisa')
    ..writeln()
    ..writeln('Apri questo link con Safari:')
    ..writeln(indirizzoWeb)
    ..writeln()
    ..writeln('Per averla come app: tocca Condividi (il quadrato con la freccia ↑) '
        'e poi "Aggiungi alla schermata Home".');
  if (codiceFamiglia != null) {
    b
      ..writeln()
      ..writeln('Poi tocca l\'icona delle persone in alto a destra, '
          '"Entra con un codice" e scrivi: $codiceFamiglia');
  }
  return b.toString().trim();
}

/// Apre il menu "Condividi" del telefono (WhatsApp, SMS, email…).
/// Dove non c'è (es. browser del computer) copia il messaggio.
Future<void> condividiApp(BuildContext context, {String? codiceFamiglia}) async {
  final testo = messaggioInvito(codiceFamiglia: codiceFamiglia);
  if (kIsWeb && !condivisioneNativa()) {
    await Clipboard.setData(ClipboardData(text: testo));
    if (context.mounted) {
      avviso(context, 'Messaggio copiato: incollalo su WhatsApp o in un SMS');
    }
    return;
  }
  final box = context.findRenderObject() as RenderBox?;
  await SharePlus.instance.share(ShareParams(
    text: testo,
    subject: 'Lista della spesa',
    sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
  ));
}
