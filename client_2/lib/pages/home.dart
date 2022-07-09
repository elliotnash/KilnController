import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoButton.filled(
          onPressed: () => context.beamToNamed('/login'),
          child: const Text('Click to Login'),
        ),
      ),
    );
  }
}