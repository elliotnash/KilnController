import 'package:flutter/material.dart';

class CurrentView extends StatelessWidget {
  const CurrentView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You are on page:',
          ),
          Text(
            '1',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
