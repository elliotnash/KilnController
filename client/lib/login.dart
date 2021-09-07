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
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Log In"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: KilnTextField(
                      label: kEmailLabel,
                      hint: kEmailHint,
                      type: TextFieldType.email,
                      autofocus: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: KilnTextField(
                      label: kPasswordLabel,
                      hint: kPasswordHint,
                      type: TextFieldType.password,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(kSubmit),
                      ),
                      onPressed: () {
                        print("oh yes you did it");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    this.autofocus = false,
    this.controller,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextFieldType type;
  final bool autofocus;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      autocorrect:
          type == TextFieldType.email || type == TextFieldType.password,
      obscureText: type == TextFieldType.password,
      enableSuggestions: type == TextFieldType.password,
      autofocus: autofocus,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelStyle: TextStyle(color: theme.colorScheme.secondary, fontSize: 18),
        labelText: label,
        hintText: hint,
      ),
    );
  }
}

enum TextFieldType { text, email, password }
