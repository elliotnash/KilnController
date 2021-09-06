import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kiln_colors.dart';
import 'consts.dart';

import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // transparent nav bar
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Kiln Controller',
    //   theme: ThemeData(
    //     primarySwatch: KilnColors.cyan,
    //   ),
    //   home: const Home(title: 'Kiln Controller'),
    // );
    return MaterialApp(
      title: kTitle,
      theme: KilnColors.lightTheme,
      darkTheme: KilnColors.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {
        '/': (context) {
          return const Home(title: kTitle);
        },
        '/login': (context) {
          return const Login(title: kTitle);
        }
      },
    );
  }
}
