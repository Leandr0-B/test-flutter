import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/UI/vistaInicio.dart';
import 'package:flutter_application_1/UI/vistaLogin.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'Notifications/notification_widget.dart';
import 'package:http/http.dart' as http;

var prueba;
String? notificacion = '';
final FirebaseMessaging messaging = FirebaseMessaging.instance;

void main() async {
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // use the returned token to send messages to users from your custom server
  String? token = await messaging.getToken(
    vapidKey:
        "BEFBbZpzZnDl-RhLiOFuppuuUb-bllW0g3skh2rzUwV2GeRpvyPxzCkibX7Wr7qz_xlE3wkCdR9cZWe4pCJszP8",
  );

  prueba = token;

  print(token);

  List<String?> tokens = [];

  /*
  //Mi token
  tokens.add(token);

  //Token lea
  tokens.add(
      'cz9_7QC-Z3VngC4M2T39tT:APA91bF3R-yUCcnzSf6HR_IN2vtFg28wkW_OKybXb48gos_QgcSvxHUF3NKc14nvgbNyOi3DXLzrOZEq4Ys6EBvPDNOIauJIapa6qpymCJHbg8dw_P4PSIarHlHYJuw49GAF9c5nVtEV');

  sendPushMessageTokens(
      tokens,
      'Esta es una notificacion que se envia a varios tokens',
      'Notificacion Multiple');

  */
  //sendPushMessage(token, "Notificacion con tiempo", "Notificacion"); //-> envia la notificacion al token

*/
  runApp(const MyApp());
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        InicioPage.id: (context) => InicioPage(),
      },
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
            ClipboardWidget(textToCopy: prueba)
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

class ClipboardWidget extends StatelessWidget {
  final String textToCopy;

  ClipboardWidget({required this.textToCopy});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _copyToClipboard();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Texto copiado al portapapeles')),
        );
      },
      child: Text('Copiar al portapapeles'),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: textToCopy));
  }
}
