import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kilncontroller/client.dart';
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

final kilnClient = KilnClient();

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
          beforeEnter: (vRedirector) async => kilnClient.authenticated ? null : vRedirector.to(LandingPage.route),
          stackedRoutes: [
            VWidget(path: Home.route, widget: const Home()),
          ],
        ),
      ],
    );
  }
}

class LandingPage extends StatefulWidget {
  static const route = "/";

  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  StreamSubscription? _loginFuture;

  @override
  void initState() {
    super.initState();
    _loginFuture = kilnClient.login(false).asStream().listen((result) {
      print("logged in with result $result");
      if (result){
        context.vRouter.to(Home.route);
      } else {
        context.vRouter.to(Login.route);
      }
    });
  }

  @override
  void dispose() {
    _loginFuture?.cancel();
    super.dispose();
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
