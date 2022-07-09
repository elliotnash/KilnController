import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:kiln_controller/pages/home.dart';
import 'package:kiln_controller/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(KilnControllerApp());
}

class KilnControllerApp extends StatelessWidget {
  KilnControllerApp({Key? key}) : super(key: key);
  final routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
        pathPatterns: ['/login'],
        guardNonMatching: true,
        check: (context, location) => false,
        beamToNamed: (_, __) => '/login',
      ),
    ],
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (_, __, ___) => const BeamPage(
            name: 'home',
            title: 'Kiln Controller',
            type: BeamPageType.cupertino,
            child: HomePage()
        ),
        '/login': (_, __, ___) => const BeamPage(
            name: 'login',
            title: 'Kiln Controller Login',
            type: BeamPageType.cupertino,
            child: LoginPage()
        ),
      },
    ),
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: CupertinoApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
      ),
    );
  }
}
