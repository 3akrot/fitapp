// lib/signup.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styles.dart'; // Import the styles
import './firebaseAUTH/auth.dart'; // Import the Authentication class

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}

class _SignupPageState extends State<SignupPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // New fields
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController fitnessGoalController = TextEditingController();
  TextEditingController fitnessLevelController = TextEditingController();

  // Dropdown values
  List<String> fitnessGoals = ['Lose Weight', 'Build Muscle', 'Increase Strength'];
  List<String> fitnessLevels = ['Beginner', 'Intermediate', 'Advanced'];

  String selectedFitnessGoal = 'Lose Weight';
  String selectedFitnessLevel = 'Beginner';

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    fitnessGoalController.dispose();
    fitnessLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/signUP.jpeg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Start the Journey',
                    style: AppStyles.titleStyle,
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  validator: widget.validateUsername,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  validator: widget.validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  validator: widget.validatePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (val) =>
                      widget.validateConfirmPassword(passwordController.text, val),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
                const SizedBox(height: 20),
                // New Fields
                TextFormField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedFitnessGoal,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFitnessGoal = newValue!;
                    });
                  },
                  items: fitnessGoals.map((goal) {
                    return DropdownMenuItem(
                      value: goal,
                      child: Text(goal),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Fitness Goal',
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedFitnessLevel,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFitnessLevel = newValue!;
                    });
                  },
                  items: fitnessLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Fitness Level',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF4C0F77),
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    String username = usernameController.text;
    String confirmPassword = confirmPasswordController.text;

    String height = heightController.text;
    String weight = weightController.text;
    String age = ageController.text;

    try {
      // Check if the username is already in use
      QuerySnapshot usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        // Username already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username is already taken. Please choose another.")),
        );
        return;
      }

      // Create the user
      User? user = await _auth.createUserWithEmailAndPassword(email, password);
      if (user != null) {
        // Calculate BMI
        double bmi = _calculateBMI(double.parse(height), double.parse(weight));

        // Generate workout plan
        Map<String, dynamic> workoutPlan = _generateWorkoutPlan();

        // Save user data and workout plan
        await _saveUserData(user.uid, email, username, height, weight, age, selectedFitnessGoal, selectedFitnessLevel, bmi, workoutPlan);

        // Navigate to the login screen
        Navigator.pushNamed(context, "/login");
      } else {
        // Sign-up failed
        print("Sign-up failed: User is null.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This email is already registered. Please log in.")),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password is too weak. Please choose a stronger password.")),
        );
      }
    } catch (e) {
      // General error handling
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  double _calculateBMI(double height, double weight) {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  Map<String, dynamic> _generateWorkoutPlan() {
    // A sample workout plan generation based on goal and fitness level
    Map<String, dynamic> workoutPlan = {};

    // Generate workout plan for 4 weeks
    for (int week = 1; week <= 4; week++) {
      workoutPlan['Week $week'] = _generateExercisesForWeek(selectedFitnessGoal, selectedFitnessLevel);
    }

    return workoutPlan;
  }

  Map<String, dynamic> _generateExercisesForWeek(String goal, String level) {
    // Example workout exercises for different goals and levels
    Map<String, List<String>> exercises = {
      'Lose Weight': ['Jumping Jacks', 'Squats', 'Lunges'],
      'Build Muscle': ['Push-ups', 'Pull-ups', 'Deadlifts'],
      'Increase Strength': ['Bench Press', 'Squats', 'Deadlifts'],
    };

    // Select exercises based on the goal
    List<String> selectedExercises = exercises[goal] ?? ['Push-ups', 'Squats'];

    // Map exercises to sets and reps based on fitness level
    Map<String, dynamic> workout = {};
    for (String exercise in selectedExercises) {
      switch (level) {
        case 'Beginner':
          workout[exercise] = {'sets': 3, 'reps': 10};
          break;
        case 'Intermediate':
          workout[exercise] = {'sets': 4, 'reps': 12};
          break;
        case 'Advanced':
          workout[exercise] = {'sets': 5, 'reps': 15};
          break;
        default:
          workout[exercise] = {'sets': 3, 'reps': 10};
          break;
      }
    }

    return workout;
  }

  Future<void> _saveUserData(String userId, String email, String username, String height, String weight, String age, String goal, String level, double bmi, Map<String, dynamic> workoutPlan) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'username': username,
        'height': height,
        'weight': weight,
        'age': age,
        'goal': goal,
        'level': level,
        'bmi': bmi,
        'workoutPlan': workoutPlan,
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
