import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:vibration/vibration.dart';
import 'consts.dart';

import 'views/current_view.dart';
import 'views/chart_view.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
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
                  ? theme.colorScheme.primaryVariant.withAlpha(0xAA)
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
      drawer: const FrostDrawer(),
      drawerScrimColor: Colors.transparent,
      body: const Center(
        child: Text("hi"),
      ),
    );
  }
}

class FrostDrawer extends StatefulWidget {
  const FrostDrawer({Key? key}) : super(key: key);

  @override
  _FrostDrawerState createState() => _FrostDrawerState();
}

class _FrostDrawerState extends State<FrostDrawer> {

  @override
  void initState() {
    super.initState();
    Vibration.vibrate(duration: 50);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
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
    );
  }
}

enum _Tabs { home, data }