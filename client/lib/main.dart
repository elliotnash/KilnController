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
  runApp(const KilnController());
}

class KilnController extends StatefulWidget {
  const KilnController({Key? key}) : super(key: key);

  @override
  _KilnControllerState createState() => _KilnControllerState();
}

class _KilnControllerState extends State<KilnController> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kTitle,
      theme: KilnColors.lightTheme,
      darkTheme: KilnColors.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Login.route,
      routes: {
        Login.route: (context) => const Login(),
        Home.route: (context) => const Home(),
      },
    );
  }
}

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case Home.route:
//         return _GeneratePageRoute(
//             widget: const Home(), routeName: settings.name!);
//       case Login.route:
//         return _GeneratePageRoute(
//             widget: const Login(), routeName: settings.name!);
//       // TODO add 404 route
//       default:
//         return _GeneratePageRoute(
//             widget: const Login(), routeName: settings.name!);
//     }
//   }
// }
//
// class _GeneratePageRoute extends PageRouteBuilder {
//   final Widget widget;
//   final String routeName;
//   _GeneratePageRoute({required this.widget, required this.routeName})
//       : super(
//             settings: RouteSettings(name: routeName),
//             pageBuilder: (BuildContext context, Animation<double> animation,
//                 Animation<double> secondaryAnimation) {
//               return widget;
//             },
//             transitionDuration: const Duration(milliseconds: 500),
//             transitionsBuilder: (BuildContext context,
//                 Animation<double> animation,
//                 Animation<double> secondaryAnimation,
//                 Widget child) {
//               return SlideTransition(
//                 textDirection: TextDirection.rtl,
//                 position: Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               );
//             });
// }
