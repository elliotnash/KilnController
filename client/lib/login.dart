import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kilncontroller/consts.dart';

class Login extends StatefulWidget {
  static const route = "/login";

  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(kTitle),
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
      drawerScrimColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("hhello"),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter valid mail id as abc@gmail.com'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
