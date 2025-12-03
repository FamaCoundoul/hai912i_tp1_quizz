import 'package:flutter/material.dart';
import 'question_model.dart';

// Couleurs
const Color _primaryColor = Color(0xFFFF69B4); // Hot Pink
const Color _backgroundColor = Color(0xFF607D8B); // BlueGrey 500
const Color _darkBackgroundColor = Color(0xFF455A64); // BlueGrey 700
const Color _cardColor = Colors.white;

class QuizzPage extends StatefulWidget {
  final String title;
  final List<Question> questions;

  const QuizzPage({
    Key? key,
    required this.title,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  int _currentIndex = 0;
  int _score = 0;

  // Vérifie la réponse
  bool _checkAnswer(bool userChoice, BuildContext context) {
    bool correct = widget.questions[_currentIndex].isCorrect == userChoice;

    if (correct) {
      _score++;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          correct ? "Bonne réponse !" : "Mauvaise réponse !",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: correct ? Colors.green.shade600 : Colors.red.shade600,
        duration: const Duration(milliseconds: 1200),
      ),
    );

    return correct;
  }

  // Passage à la question suivante
  void _nextQuestion() {
    setState(() {
      if (_currentIndex < widget.questions.length - 1) {
        _currentIndex++;
      } else {
        _showFinalScoreDialog();
      }
    });
  }

  // Score final
  void _showFinalScoreDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Quizz Terminé !', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Votre score est $_score / ${widget.questions.length}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentIndex = 0;
                  _score = 0;
                });
              },
              child: const Text('Recommencer', style: TextStyle(color: _primaryColor)),
            ),
          ],
        );
      },
    );
  }


  // 1. Carte avec illustration (Image.asset dynamique)

  Widget _buildIllustrationCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
      height: 220,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  // 2. Carte Question
  Widget _buildQuestionCard(String text) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(minHeight: 120),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  // 3. Boutons
  Widget _buildAnswerButton(String text, bool? answer) {
    bool isNextButton = answer == null;

    return ElevatedButton(
      onPressed: isNextButton
          ? _nextQuestion
          : () {
        _checkAnswer(answer!, context);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isNextButton ? _cardColor : Colors.black87,
        backgroundColor: isNextButton ? _primaryColor : _cardColor,
        side: BorderSide(color: isNextButton ? _primaryColor : Colors.black12),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: isNextButton ? 8 : 2,
      ),
      child: isNextButton
          ? const Icon(Icons.arrow_forward, color: _cardColor)
          : Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: _cardColor)),
        centerTitle: true,
        backgroundColor: _darkBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: _backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // ILLUSTRATION AVEC L'IMAGE
          _buildIllustrationCard(question.image),

          // QUESTION
          _buildQuestionCard(question.questionText),

          const Spacer(),

          // BOUTONS : VRAI / FAUX / SUIVANT
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAnswerButton('VRAI', true),
                _buildAnswerButton('FAUX', false),
                _buildAnswerButton('', null),
              ],
            ),
          ),

          // Indicateur de progression
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Text(
                'Question ${_currentIndex + 1} / ${widget.questions.length}',
                style: const TextStyle(color: _cardColor, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
