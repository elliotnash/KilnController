import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/models/kiln_info.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/dio_provider.dart';

class KilnInfoNotifier extends StateNotifier<String?> {
  StateNotifierProviderRef ref;
  Timer? _refresh;
  KilnInfoNotifier(this.ref) : super(null) {
    final auth = ref.watch(authProvider);
    if (auth.state == AuthState.authenticated) {
      _fetch(auth.serial!);
      _refresh = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _fetch(auth.serial!),
      );
    } else {
      _refresh?.cancel();
    }
  }
  Future _fetch(String serial) async {
    final res = await ref.read(dioProvider).get("${serial}/info");
    final kilnInfo = KilnInfo.fromJson(res.data);
    print(kilnInfo);
  }
}

final kilnInfoProvider = StateNotifierProvider<KilnInfoNotifier, String?>((ref) {
  return KilnInfoNotifier(ref);
});
