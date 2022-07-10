import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:kiln_controller/pages/home.dart';
import 'package:kiln_controller/pages/login.dart';
import 'package:kiln_controller/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();

  final routeInformationParser = BeamerParser();
  final routerDelegate = createDelegate(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: KilnControllerApp(
        routerDelegate: routerDelegate,
        routeInformationParser: routeInformationParser,
      ),
    ),
  );
}

class KilnControllerApp extends StatelessWidget {
  const KilnControllerApp({
    Key? key,
    required this.routeInformationParser,
    required this.routerDelegate,
  }) : super(key: key);

  final RouteInformationParser<Object> routeInformationParser;
  final RouterDelegate<Object> routerDelegate;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.fromWindow(
      child: CupertinoApp.router(
        useInheritedMediaQuery: true,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
      ),
    );
  }
}

BeamerDelegate createDelegate(ProviderContainer container) {
  final delegate = BeamerDelegate(
    guards: [
      BeamGuard(
        pathPatterns: ['/login'],
        guardNonMatching: true,
        check: (_, __) => container.read(authProvider).state != AuthState.unauthenticated,
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
  // once auth state loads we need to redirect to login screen
  container.listen(authProvider, (_, Auth next) {
    if (next.state == AuthState.unauthenticated) {
      delegate.beamToReplacementNamed(
        '/login',
        transitionDelegate: const NoAnimationTransitionDelegate(),
      );
    }
  });
  return delegate;
}
