import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hai912i_tp1_quizz/pages/WelcomePage.dart';
import 'model/question_model.dart';
import 'pages/QuizzPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<Question> questions = await _loadQuestionsFromJson();
  runApp(MyApp(questions: questions));
}

Future<List<Question>> _loadQuestionsFromJson() async {
  final String jsonData =
  await rootBundle.loadString('assets/data/quizz_questions.json');
  final List<dynamic> list = json.decode(jsonData);
  return list.map((e) => Question.fromJson(e)).toList();
}

class MyApp extends StatelessWidget {
  final List<Question> questions;

  const MyApp({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: WelcomePage(questions: questions),
    );
  }
}
