import 'package:material_ui/material_ui.dart';

import 'stato.dart';
import 'ui/comuni.dart';
import 'ui/lista_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final stato = Stato()..avvia();
  runApp(ListaSpesaApp(stato: stato));
}

class ListaSpesaApp extends StatelessWidget {
  const ListaSpesaApp({super.key, required this.stato});
  final Stato stato;

  @override
  Widget build(BuildContext context) {
    ThemeData tema(Brightness b) => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32),
        brightness: b,
      ),
      useMaterial3: true,
    );
    return StatoScope(
      stato: stato,
      child: MaterialApp(
        title: 'Lista Spesa',
        debugShowCheckedModeBanner: false,
        theme: tema(Brightness.light),
        darkTheme: tema(Brightness.dark),
        home: const _Avvio(),
      ),
    );
  }
}

class _Avvio extends StatelessWidget {
  const _Avvio();

  @override
  Widget build(BuildContext context) {
    final stato = StatoScope.of(context);
    if (!stato.pronto) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (stato.nome.isEmpty && !stato.flag('benvenuto-visto')) {
      return const _Benvenuto();
    }
    return const ListaPage();
  }
}

class _Benvenuto extends StatefulWidget {
  const _Benvenuto();

  @override
  State<_Benvenuto> createState() => _BenvenutoState();
}

class _BenvenutoState extends State<_Benvenuto> {
  final _nome = TextEditingController();

  Future<void> _avanti() async {
    final stato = StatoScope.read(context);
    await stato.impostaNome(_nome.text);
    await stato.setFlag('benvenuto-visto', true);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  Text('Lista della spesa', style: tt.headlineMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'Scegli prodotti e marche, la lista si ordina da sola per reparto '
                    'e la condividi con chi fa la spesa.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nome,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Come ti chiami?',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _avanti(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _avanti,
                      child: const Text('Inizia'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
