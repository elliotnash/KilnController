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
      // TODO add 404 page
      routes: [
        VWidget(path: LandingPage.route, widget: const LandingPage()),
        VWidget(path: Login.route, widget: const Login()),
        VGuard(
          beforeEnter: (vRedirector) async => _authenticated ? null : vRedirector.to(Login.route),
          stackedRoutes: [
            VWidget(path: Home.route, widget: const Home()),
          ],
        ),
      ],
    );
  }
}

Future<void> fetchData() async {
  await Future.delayed(const Duration(seconds: 5));
}
bool _authenticated = true;

class LandingPage extends StatefulWidget {
  static const route = "/";

  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  late StreamSubscription _fetchFuture;

  @override
  void initState() {
    super.initState();
    _fetchFuture = fetchData().asStream().listen((_) {
      _authenticated = true;
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
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.background,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
