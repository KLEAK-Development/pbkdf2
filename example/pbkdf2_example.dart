import 'package:pbkdf2/pbkdf2.dart';

String fakePepper() => 'This is a fake pepper';

void main() {
  final pbkdf2 = Pbkdf2(pepperFactory: fakePepper);
  final hash = pbkdf2.hash('Test');
  print(hash);

  final isVerified = pbkdf2.verify('Test', hash);
  print(isVerified);

  final isVerified2 = pbkdf2.verify('Toto', hash);
  print(isVerified2);
}
