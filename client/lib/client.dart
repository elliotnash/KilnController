class KilnClient {
  var _authenticated = false;
  bool get authenticated{
    return _authenticated;
  }
  Future<bool> login(bool result) async {
    await Future.delayed(const Duration(seconds: 5));
    _authenticated = result;
    return result;
  }
}