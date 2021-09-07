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
      //extendBodyBehindAppBar: true,
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
      //extendBody: true,
      drawerScrimColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Log In"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: KilnTextField(
                label: "email",
                hint: "account@example.com",
                type: TextFieldType.email,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: KilnTextField(
                label: "password",
                hint: "enter password",
                type: TextFieldType.password,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KilnTextField extends StatelessWidget {
  const KilnTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.type = TextFieldType.text,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextFieldType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      autocorrect: type == TextFieldType.email || type == TextFieldType.password,
      obscureText: type == TextFieldType.password,
      enableSuggestions: type == TextFieldType.password,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          labelStyle: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 18
          ),
          labelText: label,
          hintText: hint,
      ),
    );
  }
}

enum TextFieldType{ text, email, password }
