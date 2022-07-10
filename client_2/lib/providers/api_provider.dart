import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Api {

}

final dioProvider = Provider<Dio>((ref) {
  String baseUrl = "https://kiln.elliotnash.org/";
  BaseOptions options = BaseOptions(
      baseUrl: baseUrl
  );
  return Dio(options);
});

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
  AuthNotifier(this.ref) : super(Auth(AuthState.initializing));

  Future login(String email, String password) async {
    var dio = ref.read(dioProvider);
    try {
      final res = await dio.post("login", data: {
        'email': email,
        'password': password,
      });
      state = Auth(AuthState.authenticated, res.data);
    } catch (e) {
      state = Auth(AuthState.unauthenticated);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Auth>(
  (ref) => AuthNotifier(ref)
);
