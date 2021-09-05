import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:vibration/vibration.dart';
import 'kiln_colors.dart';
import 'consts.dart';

import 'views/current_view.dart';
import 'views/chart_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // transparent nav bar
    statusBarColor: Colors.transparent, // transparent status bar
  ));
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
      title: kTitle,
      theme: KilnColors.lightTheme,
      darkTheme: KilnColors.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) {
          return const Home(title: kTitle);
        },
      },
      initialRoute: '/',
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

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
    final query = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: query.platformBrightness == Brightness.light
                  ? theme.colorScheme.primary.withAlpha(0xAA)
                  : theme.colorScheme.surface.withAlpha(0xAA),
            ),
          ),
        ),
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
                icon: Icon(Icons.notifications), label: kHome),
            BottomNavigationBarItem(
                icon: Icon(Icons.data_usage), label: kData),
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
        ),
      ),
      drawer: SizedBox(
        width: 300,
        child: ClipPath(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child:
                    Container(color: theme.colorScheme.surface.withAlpha(0xAA)),
              ),
              ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    child: Text('Account'),
                  ),
                  MaterialButton(
                    onPressed: () {
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Settings"),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(kLogOut),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawerScrimColor: Colors.transparent,
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
        children: const <Widget>[
          CurrentView(),
          ChartView(),
        ],
      ),
    );
  }
}

enum _Tabs { home, data }
