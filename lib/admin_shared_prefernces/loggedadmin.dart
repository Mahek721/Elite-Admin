class LoggedAdmin {
  static String? _email;

  static String get email => _email!;

  static set email(String value) {
    _email = value;
  }
}
