import 'package:flutter/material.dart';

import 'json_data.dart';

bool goNext = false;

String currentWord = '';
List<String> options = [];
void main() {
  runApp(VocabQuizApp());
}

class VocabQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Quiz',
      debugShowCheckedModeBanner: false, // Убираем debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> words = [];
  List<String> incorrectWords = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    words = flashcards.keys.toList()..shuffle();
    goNext = false;
    currentWord = words.first;
    options = getOptions(flashcards[currentWord]!);
  }

  void checkAnswer(String word, String selectedAnswer) {
    String correctAnswer = flashcards[word]!;
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score++;
        goNext = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Правильно!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        goNext = true;
      });
      incorrectWords.add(word);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Неправильно. Правильный ответ: $correctAnswer"),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      words.remove(word);
      if (words.isEmpty && incorrectWords.isNotEmpty) {
        words = List.from(incorrectWords);
        incorrectWords.clear();
      }
    });
  }

  List<String> getOptions(String correctAnswer) {
    List<String> options = [correctAnswer];
    List<String> otherAnswers = flashcards.values.toList();
    otherAnswers.remove(correctAnswer);
    otherAnswers.shuffle();
    options.addAll(otherAnswers.take(3));
    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Результаты")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  "Вы ответили правильно на $score из ${flashcards.length} слов.",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                InkWell(
                  radius: 0,
                  onTap: () {
                    setState(() {
                      words = flashcards.keys.toList()..shuffle();
                      goNext = false;
                      currentWord = words.first;
                      options = getOptions(flashcards[currentWord]!);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Заново',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // appBar: AppBar(title: const Text("Vocabulary Quiz")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Переведите слово '$currentWord':",
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30.0),
                ...options.map((option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () =>
                            goNext ? null : checkAnswer(currentWord, option),
                        child: Text(
                          option,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                goNext
                    ? InkWell(
                        radius: 0,
                        onTap: () {
                          setState(() {
                            goNext = false;
                            currentWord = words.first;
                            options = getOptions(flashcards[currentWord]!);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          // margin: const EdgeInsets.all(24),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
