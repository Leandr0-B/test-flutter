import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

String? notificacion = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  inicializarFirebase();

  runApp(const MyApp());
}

void inicializarFirebase() {
  final messaging = FirebaseMessaging.instance;

  messaging
      .requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  )
      .then((settings) {
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      obtenerTokenFirebase();
    }
  }).catchError((error) {
    print('Error al solicitar los permisos: $error');
    // Manejar el error de solicitud de permisos
  });
}

void obtenerTokenFirebase() {
  final messaging = FirebaseMessaging.instance;
  final vapidKey =
      "BEFBbZpzZnDl-RhLiOFuppuuUb-bllW0g3skh2rzUwV2GeRpvyPxzCkibX7Wr7qz_xlE3wkCdR9cZWe4pCJszP8";

  messaging.getToken(vapidKey: vapidKey).then((token) {
    print('Token de Firebase: $token');
    // Aquí puedes continuar con el flujo de tu aplicación utilizando el token
  }).catchError((error) {
    print('Error al obtener el token de Firebase: $error');
    // Manejar el error de solicitud del token de Firebase
  });
}

void sendPushMessage(String? token, String body, String title) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAETDov4g:APA91bHcsF5k0xIEr40AL6qlBqdIwWcabEcNe-w3Q3qARtgY4eBMK4G0t13TwL0XwEN0TmzV2m7h9h5HkmdFo02U2JdBv8UcsNgwmG2Ek47snBdn9DDQGAysCv3YJNZG2d76echcY9Tc'
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
          },
          "to": token,
          "webpush": {
            "headers": {
              "TTL":
                  "86400", // Duración de la notificación en segundos (ejemplo: 1 hora)
            }
          },
        },
      ),
    );
  } catch (e) {
    print("error al push");
  }
}

void sendPushMessageTokens(
    List<String?> tokens, String body, String title) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAETDov4g:APA91bHcsF5k0xIEr40AL6qlBqdIwWcabEcNe-w3Q3qARtgY4eBMK4G0t13TwL0XwEN0TmzV2m7h9h5HkmdFo02U2JdBv8UcsNgwmG2Ek47snBdn9DDQGAysCv3YJNZG2d76echcY9Tc'
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
          },
          "registration_ids": tokens,
        },
      ),
    );
  } catch (e) {
    print("error al push");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print('test ' + message.toString());
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context,
        '/chat',
      );
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String? title = message.notification?.title;
        String? body = message.notification?.body;

        setState(() {
          notificacion =
              'Recibiste una notificacion. Titulo: ${title ?? ''} Cuerpo: ${body ?? ''}';
        });
        print('Título: ${title ?? "Sin título"}');
        print('Cuerpo: ${body ?? "Sin cuerpo"}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              notificacion ?? 'Sin notificaciones',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
