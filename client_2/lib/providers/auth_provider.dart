import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (_) async => await SharedPreferences.getInstance()
);

class Auth {
  final AuthState state;
  final String? serial;
  Auth(this.state, [this.serial]);
}

enum AuthState {
  initializing,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends StateNotifier<Auth> {
  final StateNotifierProviderRef ref;
  AuthNotifier(this.ref) : super(Auth(AuthState.initializing)) {
    // listen to shared preferences to load auth from
    ref.watch(sharedPreferencesProvider).whenData((prefs) {
      final sn = prefs.getString("serialNumber");
      if (sn != null) {
        state = Auth(AuthState.authenticated, sn);
      } else {
        state = Auth(AuthState.unauthenticated);
      }
    });
  }

  Future login(String email, String password) async {
    var dio = ref.read(dioProvider);
    try {
      final res = await dio.post("login", data: {
        'email': email,
        'password': password,
      });
      ref.read(sharedPreferencesProvider).value!.setString("serialNumber", res.data);
      state = Auth(AuthState.authenticated, res.data);
    } catch (e) {
      state = Auth(AuthState.unauthenticated);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Auth>(
        (ref) => AuthNotifier(ref)
);
