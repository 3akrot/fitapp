import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  Future<Map<String, dynamic>> lookupRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    return json.decode(response.body);
  }
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  Map<String, dynamic>? _randomMeal;
  bool _showInstructions = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomMeal();
  }

  Future<void> _fetchRandomMeal() async {
    final randomMeal = await _recipeService.lookupRandomMeal();
    setState(() {
      _randomMeal = randomMeal['meals'][0]; 
      _showInstructions = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Suggestion',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF535878),
      ),
      backgroundColor: const Color(0xFF535878),
      body: SingleChildScrollView(
        child: Center(
          child: _randomMeal == null
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _randomMeal!['strMeal'],
                        style: const TextStyle(
                          fontSize: 26, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _randomMeal!['strMealThumb'],
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 10),
                      _showInstructions
                          ? AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: 1.0,
                              child: Column(
                                children: _buildInstructionLines(),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRandomMeal,
        tooltip: 'Get Another Random Meal',
        backgroundColor: const Color(0xFF535878),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Widget> _buildInstructionLines() {
    List<Widget> widgets = [];
    List<String> lines = _randomMeal!['strInstructions'].split('\n');
    for (int i = 0; i < lines.length; i++) {
      widgets.add(
        FadeInText(
          key: Key('instruction_$i'),
          text: lines[i],
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 150 * i),
        ),
      );
    }
    return widgets;
  }
}

class FadeInText extends StatefulWidget {
  final String text;
  final Duration duration;
  final Duration delay;

  const FadeInText({
    required Key key,
    required this.text,
    required this.duration,
    required this.delay,
  }) : super(key: key);

  @override
  _FadeInTextState createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    Future.delayed(widget.delay, () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 18, 
            color: Colors.white,
            fontWeight: FontWeight.w400
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
