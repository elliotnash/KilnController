import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kilncontroller/consts.dart';
import 'package:vrouter/vrouter.dart';

import 'home.dart';
import 'main.dart';

class Login extends StatefulWidget {
  static const route = "/login";

  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final _emailCtl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final _passwordCtl = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  StreamSubscription? _loginFuture;

  @override
  void dispose() {
    _loginFuture?.cancel();

    _emailCtl.dispose();
    _emailFocus.dispose();
    _passwordCtl.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    // update the login button to show loading animation
    setState(() {
      loginState = KilnLoginState.loading;
    });
    print("logging in with email: ${_emailCtl.value.text}, "
        "password: ${_passwordCtl.value.text}");
    _loginFuture = kilnClient.login(true).asStream().listen((result) {
      print("logged in with result $result");
      context.vRouter.to(Home.route);
    });
  }

  KilnLoginState loginState = KilnLoginState.content;

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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: KilnTextField(
                      label: kEmailLabel,
                      hint: kEmailHint,
                      type: TextFieldType.email,
                      autofocus: true,
                      controller: _emailCtl,
                      focusNode: _emailFocus,
                      onSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: KilnTextField(
                      label: kPasswordLabel,
                      hint: kPasswordHint,
                      type: TextFieldType.password,
                      controller: _passwordCtl,
                      focusNode: _passwordFocus,
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: KilnLoginButton(
                      child: const Text(kSubmit),
                      state: loginState,
                      onPressed: () => _submit(),
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

class KilnLoginButton extends StatelessWidget {
  const KilnLoginButton({
    Key? key,
    this.child,
    this.onPressed,
    this.state = KilnLoginState.content,
  }) : super(key: key);

  final Widget? child;
  final VoidCallback? onPressed;
  final KilnLoginState state;

  Widget? _setupChild() {
    switch (state) {
      case KilnLoginState.content:
        {
          return child;
        }
      case KilnLoginState.loading:
        {
          return const CircularProgressIndicator();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(state == KilnLoginState.content ? 10 : 30),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: state == KilnLoginState.content ? 20 : 0,
          vertical: 10,
        ),
        child: _setupChild(),
      ),
      onPressed: onPressed,
    );
  }
}

enum KilnLoginState { content, loading }

class KilnTextField extends StatelessWidget {
  const KilnTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.type = TextFieldType.text,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.onSubmitted,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextFieldType type;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

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
      focusNode: focusNode,
      onSubmitted: onSubmitted,
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
