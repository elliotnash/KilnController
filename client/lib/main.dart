import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:vibration/vibration.dart';
import 'kiln_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiln Controller',
      theme: ThemeData(
        primarySwatch: KilnColors.cyan,
      ),
      home: const Home(title: 'Kiln Controller'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var _tab = _Tabs.home;

  final _controller = PageController(initialPage: _Tabs.home.index);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
        ),
        //backgroundColor: KilnColors.cyan.withAlpha(0x),

      ),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.values[0],
          snakeShape: SnakeShape.rectangle,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),

          backgroundColor: Colors.grey[200],
          snakeViewColor: KilnColors.cyan,
          selectedItemColor: Colors.blueGrey[900],
          unselectedItemColor: Colors.blueGrey[900],

          showSelectedLabels: true,

          currentIndex: _tab.index,
          onTap: (index) {
            Vibration.hasVibrator().then((hasVibrator) {
              if (hasVibrator!) Vibration.vibrate(duration: 50);
            });
            setState(() {
              _tab = _Tabs.values[index];
              _controller.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.data_usage), label: 'data'),
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
        ),
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          if (_tab.index != index) {
            // Then we've swiped, as the _tab index would already be updated
            // if we had changed tabs with the navbar. Vibrate
            Vibration.vibrate(duration: 50);
          }
          setState(() {
            _tab = _Tabs.values[index];
          });
        },
        children: <Widget>[
          Center(
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          const Center(child: Text("page 2")),
        ],
      ),
    );
  }
}

enum _Tabs { home, data }
