import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'installa.dart';

@JS('lsStatoInstallazione')
external JSString _stato();

@JS('lsMostraInstallazione')
external JSPromise<JSBoolean> _mostra();

ModoInstallazione modoInstallazione() => switch (_stato().toDart) {
      'ios' || 'ios-altro' => ModoInstallazione.ios,
      'pulsante' => ModoInstallazione.pulsante,
      _ => ModoInstallazione.nessuno,
    };

/// iPhone ma in un browser diverso da Safari (es. dentro WhatsApp).
bool iosNonSafari() => _stato().toDart == 'ios-altro';

Future<bool> mostraInstallazione() async => (await _mostra().toDart).toDart;

void quandoInstallabile(void Function() f) {
  web.window.addEventListener('ls-installabile', ((web.Event _) => f()).toJS);
}

String indirizzoApp() {
  final l = web.window.location;
  return '${l.origin}${l.pathname}';
}
