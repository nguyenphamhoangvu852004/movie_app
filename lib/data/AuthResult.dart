class AuthResult {
  final String? uid;
  final String? error;

  AuthResult({this.uid, this.error});

  bool get isSuccess => uid != null && error == null;
}