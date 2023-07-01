import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = true;
  String _text = '';

  final fieldDescripcion = TextEditingController();
  String descripcion = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  @override
  void dispose() {
    fieldDescripcion.dispose();
    super.dispose();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
          fieldDescripcion.text =
              _text; // Rellenar el campo de descripción con el texto reconocido
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _incrementCounter() {
    setState(() {
      String textoAudio = _text;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Ingrese una descripción del control:"),
            ),
            TextFormField(
              controller: fieldDescripcion,
              onSaved: (value) {
                descripcion = value!;
              },
              decoration: InputDecoration(
                hintText: 'Descripción del control',
                suffixIcon: IconButton(
                  onPressed: _toggleListening,
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
