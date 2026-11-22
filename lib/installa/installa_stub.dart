import 'installa.dart';

ModoInstallazione modoInstallazione() => ModoInstallazione.nessuno;
bool iosNonSafari() => false;
Future<bool> mostraInstallazione() async => false;
void quandoInstallabile(void Function() f) {}
String indirizzoApp() => '';
bool condivisioneNativa() => true;
