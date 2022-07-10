import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  String baseUrl = "https://kiln.elliotnash.org/";
  BaseOptions options = BaseOptions(
      baseUrl: baseUrl
  );
  return Dio(options);
});
