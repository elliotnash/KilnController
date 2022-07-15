import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/models/firing.dart';
import 'package:kiln_controller/models/kiln_info.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/dio_provider.dart';

class FiringFamilyNotifier extends StateNotifier<List<KilnInfo>> {
  final StateNotifierProviderRef ref;
  final String uuid;
  FiringFamilyNotifier(this.ref, this.uuid) : super([]) {
    final auth = ref.watch(authProvider);
    if (auth.state == AuthState.authenticated) {
      refresh();
    }
  }
  Future refresh() async {
    final serial = ref.read(authProvider).serial!;
    final res = await ref.read(dioProvider).get("${serial}/firing/${uuid}");
    state = [
      for (final info in res.data)
        KilnInfo.fromJson(info)
    ];
  }
}

final firingFamilyProvider = StateNotifierProvider.family<FiringFamilyNotifier, List<KilnInfo>, String>((ref, uuid) {
  return FiringFamilyNotifier(ref, uuid);
});
