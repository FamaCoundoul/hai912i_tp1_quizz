import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/question_model.dart';
import 'QuizzPage.dart';
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
// 1. PAGE D'ACCUEIL (Welcome Page)
// ========================================
class WelcomePage extends StatefulWidget {
final List<Question> questions;

const WelcomePage({Key? key, required this.questions}) : super(key: key);

@override
State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
final TextEditingController _nameController = TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: _darkTeal,
body: SafeArea(
child: Center(
child: Padding(
padding: const EdgeInsets.all(32.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// Logo QUIZ
Container(
width: 180,
height: 180,
decoration: const BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
),
child: const Center(
child: Text(
'QUIZ',
style: TextStyle(
fontSize: 36,
fontWeight: FontWeight.bold,
color: _darkTeal,
letterSpacing: 2,
),
),
),
),

const SizedBox(height: 80),

// Champ de saisie du nom
const Align(
alignment: Alignment.centerLeft,
child: Text(
'Enter your name',
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.w500,
),
),
),

const SizedBox(height: 12),

TextField(
controller: _nameController,
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
hintText: 'Taper votre nom',
hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
filled: true,
fillColor: Colors.white.withOpacity(0.1),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: _accentYellow, width: 2),
),
),
),

const SizedBox(height: 60),

// Bouton Start
SizedBox(
width: double.infinity,
height: 56,
child: ElevatedButton(
onPressed: () {
if (_nameController.text.trim().isNotEmpty) {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => QuizPage(
questions: widget.questions,
userName: _nameController.text.trim(),
),
),
);
}
},
style: ElevatedButton.styleFrom(
backgroundColor: _accentYellow,
foregroundColor: _darkTeal,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
elevation: 0,
),
child: const Text(
'Start',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),
),
],
),
),
),
),
);
}
}