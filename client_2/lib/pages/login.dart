import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                  ),
                ),
                CupertinoButton.filled(
                  onPressed: () => context.beamToNamed('/'),
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
