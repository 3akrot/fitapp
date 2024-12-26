// test/sign_up_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:healthapp/signup.dart';
void main() {
  group('Sign Up Validation Tests', () {
    test('validateEmail should return error message for empty email', () {
      var result = SignupPage().validateEmail('');
      expect(result, 'Please enter an email');
    });

    test('validateEmail should return error message for incorrect email format', () {
      var result = SignupPage().validateEmail('invalid-email');
      expect(result, 'Please enter a valid email');
    });

    test('validatePassword should return error message for empty password', () {
      var result = SignupPage().validatePassword('');
      expect(result, 'Please enter a password');
    });

    test('validateUsername should return error message for empty username', () {
      var result = SignupPage().validateUsername('');
      expect(result, 'Please enter a username');
    });
  });
}