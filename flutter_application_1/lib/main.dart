import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'Notifications/notification_widget.dart';
import 'package:flutter_application_1/BaseDeDatos/database_connection.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

var prueba;
String? notificacion = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // usuarios.forEach((usuario) {
  //   print('CI: ${usuario['ci']}');
  //   print('Nombre: ${usuario['nombre']}');
  //   print('Pass: ${usuario['pass']}');
  //   print('Administrador: ${usuario['administrador']}');
  //   print('Inactivo: ${usuario['inactivo']}');
  //   print('--------------------');
  // });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

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

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      notificacion =
          'Recibiste una notificacion. Titulo: ${title} Cuerpo: ${body}';

      print('Message also contained a notification: ${message.notification}');
      print('Título: ${title ?? "Sin título"}');
      print('Cuerpo: ${body ?? "Sin cuerpo"}');

      NotificationWidget(
        title: title.toString(),
        text: body.toString(),
      );
    }
  });

  // final res = await http
  //     .get(Uri.parse("https://residencialapi.azurewebsites.net/users"));
  // final objetos = jsonDecode(res.body);
  // print(objetos);

  runApp(const MyApp());
  //fetchAndPrintUsers();

  // final url = Uri.parse('http://localhost:3000/usuario/crear');

  // final Map<String, dynamic> userData = {
  //   'ci': '57345678',
  //   'nombre': 'John Doe',
  //   'pass': 'password123',
  //   'administrador': true,
  //   'inactivo': false,
  // };

  // final response = await http.post(
  //   url,
  //   body: jsonEncode(userData),
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGVjayI6dHJ1ZSwiaWF0IjoxNjg2MzY0MTg3LCJleHAiOjE2ODY0MDczODd9.vxrvcp4iNmD4-Y46cGRZNIMkGJAST_W77M9B6VcZlrk'
  //   },
  // );

  // if (response.statusCode == 200) {
  //   // La solicitud fue exitosa
  //   print('Solicitud POST exitosa');
  // } else {
  //   // La solicitud falló
  //   print(
  //       'Error en la solicitud POST. Código de estado: ${response.statusCode}');
  // }

  // final url = Uri.parse('http://localhost:3000/login');

  // final Map<String, dynamic> userData = {
  //   'ci': '57345678',
  //   'password': 'password123'
  // };

  // final response = await http.post(
  //   url,
  //   body: jsonEncode(userData),
  //   headers: {
  //     'Content-Type': 'application/json',
  //   },
  // );

  // if (response.statusCode == 200) {
  //   // La solicitud fue exitosa
  //   print('Solicitud POST exitosa');
  //   print(response);
  // } else {
  //   // La solicitud falló
  //   print(
  //       'Error en la solicitud POST. Código de estado: ${response.statusCode}');
  // }

  final String authToken =
      await APIService.fetchAuthToken('57345678', 'password123');
  final String userInfo = await APIService.fetchUserInfo(authToken);
  print(userInfo);
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
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        String? title = message.notification?.title;
        String? body = message.notification?.body;

        setState(() {
          notificacion =
              'Recibiste una notificacion. Titulo: ${title ?? ''} Cuerpo: ${body ?? ''}';
        });

        print('Message also contained a notification: ${message.notification}');
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

void fetchAndPrintUsers() async {
  try {
    final usersData = await APIService.fetchUsers();
    print(usersData);
    // Aquí puedes procesar los datos y mostrarlos en tu aplicación
  } catch (e) {
    print('Error fetching users: $e');
  }
}
