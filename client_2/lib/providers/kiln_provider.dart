import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/models/kiln_info.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/dio_provider.dart';

class KilnInfoNotifier extends StateNotifier<KilnInfo?> {
  StateNotifierProviderRef ref;
  Timer? _refresh;
  KilnInfoNotifier(this.ref) : super(null) {
    final auth = ref.watch(authProvider);
    if (auth.state == AuthState.authenticated) {
      refresh();
      _refresh = Timer.periodic(
        const Duration(seconds: 30),
        (_) => refresh(),
      );
    } else {
      _refresh?.cancel();
    }
  }
  Future refresh() async {
    final serial = ref.read(authProvider).serial!;
    final res = await ref.read(dioProvider).get("${serial}/info");
    state = KilnInfo.fromJson(res.data);
  }
}

final kilnInfoProvider = StateNotifierProvider<KilnInfoNotifier, KilnInfo?>((ref) {
  return KilnInfoNotifier(ref);
});
