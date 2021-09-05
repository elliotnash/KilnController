import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:vibration/vibration.dart';
import 'kiln_colors.dart';

import 'views/current_view.dart';
import 'views/chart_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Kiln Controller',
    //   theme: ThemeData(
    //     primarySwatch: KilnColors.cyan,
    //   ),
    //   home: const Home(title: 'Kiln Controller'),
    // );
    return MaterialApp(
      title: 'Kiln Controller',
      theme: ThemeData(
        primarySwatch: KilnColors.cyan,
        backgroundColor: KilnColors.magnolia,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: KilnColors.cyan,
          primaryVariant: KilnColors.cyan,
          secondary: KilnColors.rhythm,
          secondaryVariant: KilnColors.rhythm,
          surface: KilnColors.jet,
          background: KilnColors.black,
          error: KilnColors.orange,
          onPrimary: KilnColors.magnolia,
          onSecondary: KilnColors.magnolia,
          onSurface: KilnColors.magnolia,
          onBackground: KilnColors.magnolia,
          onError: KilnColors.magnolia,
        )
      ),
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) {
          return const Home(title: "Kiln Controller");
        },
      },
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
  var _tab = _Tabs.home;

  final _controller = PageController(initialPage: _Tabs.home.index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
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
          backgroundColor: theme.colorScheme.surface,
          snakeViewColor: theme.colorScheme.primary,
          selectedItemColor: theme.colorScheme.onPrimary,
          unselectedItemColor: theme.colorScheme.onSurface,
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
        ),
      ),
      body: SafeArea(
        child: PageView(
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
          children: const <Widget>[
            CurrentView(),
            ChartView(),
          ],
        ),
      ),
    );
  }
}

enum _Tabs { home, data }
