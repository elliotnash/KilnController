import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/models/firing.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/dio_provider.dart';

class FiringsNotifier extends StateNotifier<List<Firing>> {
  StateNotifierProviderRef ref;
  Timer? _refresh;
  FiringsNotifier(this.ref) : super([]) {
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
    final res = await ref.read(dioProvider).get("${serial}/firings");
    state = [
      for (final firing in res.data)
        Firing.fromJson(firing)
    ];
  }
}

final firingsProvider = StateNotifierProvider<FiringsNotifier, List<Firing>>((ref) {
  return FiringsNotifier(ref);
});
