import 'dart:io';

String pepperFromEnvironment() {
  final pepper = Platform.environment['PEPPER'];
  if (pepper == null) {
    throw Exception("PEPPER environment variable is not set");
  }
  return pepper;
}
