import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/question_model.dart';
import 'LeaderboardPage.dart';

// ========================================
// COLORS
// ========================================
const Color _darkTeal = Color(0xFF1B5E5E);
const Color _mediumTeal = Color(0xFF2D7A7A);
const Color _lightBeige = Color(0xFFF5F1E8);
const Color _accentYellow = Color(0xFFFFB84D);
const Color _correctGreen = Color(0xFF6FB3A0);
const Color _textDark = Color(0xFF2C3E50);


// ========================================
// 2. PAGE QUIZ
// ========================================
class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final String userName;

  const QuizPage({
    Key? key,
    required this.questions,
    required this.userName,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  int _timeRemaining = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timeRemaining > 0 && _selectedAnswer == null) {
        setState(() {
          _timeRemaining--;
        });
        _startTimer();
      } else if (_timeRemaining == 0 && _selectedAnswer == null) {
        _nextQuestion();
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;

    setState(() {
      _selectedAnswer = answer;
      if (answer == widget.questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _timeRemaining = 30;
      });
      _startTimer();
    } else {
      _showResultPage();
    }
  }

  void _showResultPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LeaderboardPage(
          userName: widget.userName,
          userScore: _score,
          totalQuestions: widget.questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];

    return Scaffold(
      backgroundColor: _lightBeige,
      appBar: AppBar(
        backgroundColor: _lightBeige,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.arrow_back_ios, size: 14, color: _textDark),
            const SizedBox(width: 4),
            const Text(
              'Previous',
              style: TextStyle(color: _textDark, fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${_currentIndex + 1}/${widget.questions.length}',
              style: const TextStyle(
                color: _textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Timer circulaire
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: _timeRemaining / 30,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(_mediumTeal),
                    ),
                  ),
                  Text(
                    '$_timeRemaining',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Icône de la question
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                question.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.image, size: 40, color: Colors.grey);
                },
              ),
            ),
          ),

          // Carte de question
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              question.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _textDark,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Options de réponse
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                final option = question.options[index];
                final isSelected = _selectedAnswer == option;
                final isCorrect = option == question.correctAnswer;

                Color backgroundColor = Colors.white;
                if (_selectedAnswer != null) {
                  if (isCorrect) {
                    backgroundColor = _correctGreen;
                  } else if (isSelected && !isCorrect) {
                    backgroundColor = Colors.red.shade300;
                  }
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _selectAnswer(option),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _mediumTeal : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: _selectedAnswer != null && (isCorrect || isSelected)
                                    ? Colors.white
                                    : _textDark,
                              ),
                            ),
                          ),
                          if (_selectedAnswer != null && isCorrect)
                            const Icon(Icons.check_circle, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bouton Next
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedAnswer != null ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _darkTeal,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
