// lib/login.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/main.dart';
import 'package:provider/provider.dart';
import './firebaseAUTH/auth.dart'; // Import the Authentication class
import 'styles.dart'; // Import the styles

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form
  String? _errorMessage; // Store error message for login failure

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/vecteezy_male-athlete-lifting-dumbbells_10437122.jpg', // Path to your image asset
              width: 100, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // Grey background for the page
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey, // Set key for the Form
            autovalidateMode: AutovalidateMode.onUserInteraction, // Enable auto validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/vecteezy_male-athlete-lifting-dumbbells_10437122.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Welcome back!',
                          style: AppStyles.titleStyle,
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: widget.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: widget.validatePassword,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _forgotPassword(); // Implement forgot password
                          },
                          style: AppStyles.textButtonStyle,
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _signIn();
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[200],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color(0xFF4C0F77),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        print("Login successful");
        // Fetch the username and medication reminder times from Firestore
        String username = await _auth.fetchUsernameFromFirestore(user.uid);
        List<DateTime> medicationTimes =
            await _auth.fetchTimesDataFromFirestore(user.uid);

        // Update the provider with the fetched username and medication reminder times
        Provider.of<UsernameProvider>(context, listen: false).setUsername(username);

        // Schedule daily medication reminders
        Navigator.pushNamed(context, "/AndriodPrototype");
      } else {
        setState(() {
          _errorMessage = "Invalid email or password.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Login failed. Please try again.";
      });
      print("Error: $e");
    }
  }

  // Implement Forgot Password functionality
  Future<void> _forgotPassword() async {
    String email = emailController.text;
    if (email.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email to reset password.";
      });
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _errorMessage = "Password reset email sent. Please check your inbox.";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to send reset email. Please try again.";
      });
      print("Error: $e");
    }
  }
}
