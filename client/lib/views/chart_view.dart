import 'package:flutter/material.dart';

class ChartView extends StatelessWidget {
  const ChartView({
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
            '2',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
