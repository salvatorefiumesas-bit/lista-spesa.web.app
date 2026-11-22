// Installazione come app sulla schermata Home (solo versione web).
export 'installa_stub.dart' if (dart.library.js_interop) 'installa_web.dart';

enum ModoInstallazione {
  /// Già installata, o non siamo nel browser.
  nessuno,

  /// iPhone/iPad in Safari: servono le istruzioni Condividi → Aggiungi a Home.
  ios,

  /// Android/Chrome: c'è il pulsante di installazione vero.
  pulsante,
}
