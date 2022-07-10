import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/providers/api_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    await ref.read(authProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );
    final auth = ref.read(authProvider);
    if (auth.state == AuthState.authenticated) {
      _redirect();
    } else {
      _showError();
    }
  }

  void _redirect() {
    // context.beamingHistory.clear();
    context.beamToReplacementNamed('/');
  }

  void _showError() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Invalid Credentials'),
          // content: const Text('Invalid credentials'),
          actions: <Widget>[
            CupertinoButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'))
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(//forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoTextField(
                    controller: _emailController,
                    padding: const EdgeInsets.all(16),
                    placeholder: "Email",
                    decoration: BoxDecoration(
                        color: CupertinoDynamicColor.resolve(CupertinoColors.secondarySystemBackground, context),
                        borderRadius: const BorderRadius.all(Radius.circular(8))
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoTextField(
                    controller: _passwordController,
                    padding: const EdgeInsets.all(16),
                    placeholder: "Password",
                    decoration: BoxDecoration(
                        color: CupertinoDynamicColor.resolve(CupertinoColors.secondarySystemBackground, context),
                        borderRadius: const BorderRadius.all(Radius.circular(8))
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onSubmitted: (_) => _login(),
                  ),
                ),
                CupertinoButton.filled(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
