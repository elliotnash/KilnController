import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/dio_provider.dart';

Timer? _refresh;
// Contains all active hazards
final FutureProvider<void> kilnInfoProvider = FutureProvider<void>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth.state == AuthState.authenticated) {
    // this is a really hacky way to auto refresh the hazards every 30 seconds
    if (_refresh != null) {
      _refresh!.cancel();
    }
    _refresh = Timer(const Duration(seconds: 30), () {
      ref.refresh(kilnInfoProvider);
    });
    await ref.watch(dioProvider).get("info");
  }
});
