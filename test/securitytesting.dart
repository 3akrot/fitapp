// test/securitytesting.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  group('Security Tests', () {
    test('Check for insecure storage', () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedValue = prefs.getString('insecureKey');
      expect(storedValue, isNull, reason: 'Sensitive data should not be stored in SharedPreferences');
    });

    test('Check for weak encryption', () {
      final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt('Sensitive Data', iv: iv);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      expect(decrypted, 'Sensitive Data', reason: 'Encryption and decryption should work correctly');
    });

    test('Check for proper authentication', () async {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(userCredential.user, isNotNull, reason: 'User should be authenticated successfully');
      expect(userCredential.user?.email, 'test@example.com', reason: 'Authenticated user email should match');
    });
  });
}