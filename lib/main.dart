import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF313338)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _a = 0;
  int _b = 0;
  int _sum = 0;

  Future calcSum() async {
    const channel = MethodChannel('bgd.com.br/calculator');

    try {
      final sum = await channel.invokeMethod('calcSum', {
        'a': _a,
        'b': _b,
      });

      setState(() {
        _sum = sum;
      });
    } on PlatformException catch (e) {
      setState(() {
        _sum = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nativo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Value A: ',
                ),
                onChanged: (value) {
                  final valueAParsed = int.tryParse(value) ?? 0;
                  setState(() {
                    _a = valueAParsed;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Value B: ',
                ),
                onChanged: (value) {
                  final valueBParsed = int.tryParse(value) ?? 0;
                  setState(() {
                    _b = valueBParsed;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    calcSum();
                  },
                  child: const Text('Sum'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Result: $_sum',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
