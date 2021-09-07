import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kiln_colors.dart';
import 'consts.dart';
import 'package:vrouter/vrouter.dart';


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
    return VRouter(
      title: kTitle,
      theme: KilnColors.lightTheme,
      darkTheme: KilnColors.darkTheme,
      themeMode: ThemeMode.system,
      mode: VRouterMode.history,
      routes: [
        VWidget(path: '/', widget: const LandingPage()),
        VWidget(path: '/login', widget: const Login()),
        VGuard(
          beforeEnter: (vRedirector) async => _authenticated ? null : vRedirector.to('/login'),
          stackedRoutes: [
            VWidget(path: '/home', widget: const Home()),
          ],
        ),
      ],
      // initialRoute: LandingPage.route,
      // routes: {
      //   LandingPage.route: (context) => const LandingPage(),
      //   Login.route: (context) => const Login(),
      //   Home.route: (context) => const Home(),
      // },
      // onGenerateRoute: (settings) {
      //   if (_authenticated) {
      //     print("route changed but authed");
      //     return MaterialPageRoute(
      //         builder: (_) => const Home(),
      //         settings: const RouteSettings(name: Home.route),
      //     );
      //   } else {
      //     switch (settings.name){
      //       case Login.route: {
      //         return MaterialPageRoute(
      //           builder: (_) => const Login(),
      //           settings: const RouteSettings(name: Login.route),
      //         );
      //       }
      //       default: {
      //         return MaterialPageRoute(
      //           builder: (_) => const LandingPage(),
      //           settings: const RouteSettings(name: LandingPage.route),
      //         );
      //       }
      //     }
      //   }
      //},
    );
  }
}

Future<void> fetchData() async {
  await Future.delayed(const Duration(seconds: 5));
}

class LandingPage extends StatefulWidget {
  static const route = "/";

  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

bool _authenticated = false;

class _LandingPageState extends State<LandingPage> {

  late StreamSubscription _fetchFuture;

  @override
  void initState() {
    super.initState();
    _fetchFuture = fetchData().asStream().listen((_) {
      _authenticated = false;
      context.vRouter.to(Home.route);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fetchFuture.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
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
