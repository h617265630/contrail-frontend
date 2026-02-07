class TokenHolder {
  String? token;
}

class UnauthorizedHandler {
  void Function()? handler;

  void call() {
    handler?.call();
  }
}
