import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Artist Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const QuizHomePage(),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool hasAnswered = false;
  bool quizStarted = false;
  bool quizCompleted = false;

  static const int maxTime = 30;
  int timeLeft = maxTime;
  Timer? timer;

  final List<Question> questions = const [
    // Frank Ocean Questions
    Question(
      question:
          'Which Frank Ocean album features the iconic track "Nikes" and was released exclusively on Apple Music in 2016?',
      options: ['Channel Orange', 'Blonde', 'Endless', 'Nostalgia, Ultra'],
      correctIndex: 1,
      explanation:
          'Blonde is Frank Ocean\'s critically acclaimed second studio album, featuring "Nikes" as the opening track.',
    ),
    Question(
      question:
          'What was Frank Ocean\'s breakthrough mixtape that featured songs like "Novacane" and "Swim Good"?',
      options: [
        'The Lonny Breaux Collection',
        'Nostalgia, Ultra',
        'Unreleased, Misc',
        'Channel Orange',
      ],
      correctIndex: 1,
      explanation:
          'Nostalgia, Ultra (2011) was Frank Ocean\'s debut mixtape that launched his career and caught widespread attention.',
    ),

    // Justin Bieber Questions
    Question(
      question:
          'Which Justin Bieber album marked his return to music in 2020 and featured the hit single "Yummy"?',
      options: ['Purpose', 'Believe', 'Changes', 'Justice'],
      correctIndex: 2,
      explanation:
          'Changes was released in February 2020 and marked Justin\'s comeback with a more R&B-influenced sound.',
    ),
    Question(
      question:
          'What was Justin Bieber\'s debut single that became a worldwide hit in 2009?',
      options: ['Baby', 'One Time', 'One Less Lonely Girl', 'Somebody to Love'],
      correctIndex: 1,
      explanation:
          'One Time was Justin Bieber\'s debut single released in 2009, which launched his career at just 15 years old.',
    ),
    Question(
      question:
          'Which collaboration became one of Justin Bieber\'s biggest hits, featuring Luis Fonsi and Daddy Yankee?',
      options: [
        'Where Are Ü Now',
        'Despacito (Remix)',
        'I\'m the One',
        'Cold Water',
      ],
      correctIndex: 1,
      explanation:
          'Despacito (Remix) in 2017 became a global phenomenon, breaking multiple streaming records and topping charts worldwide.',
    ),
  ];

  void startTimer() {
    timer?.cancel();
    timeLeft = maxTime;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timeLeft = 0;
          SystemSound.play(SystemSoundType.alert);
          hasAnswered = true;
          t.cancel();
        }
      });
    });
  }

  void startQuiz() {
    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      hasAnswered = false;
      quizCompleted = false;
    });
    startTimer();
  }

  void selectAnswer(int index) {
    if (hasAnswered) return;
    SystemSound.play(SystemSoundType.click);

    setState(() {
      selectedAnswer = index;
      hasAnswered = true;
      timer?.cancel();
      if (index == questions[currentQuestionIndex].correctIndex) {
        score++;
      } else {
        SystemSound.play(SystemSoundType.alert);
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
        hasAnswered = false;
        startTimer();
      } else {
        quizCompleted = true;
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!quizStarted) return _buildWelcome();
    if (quizCompleted) return _buildResult();
    return _buildQuiz();
  }

  Widget _buildWelcome() => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    size: 64,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ARTIST KNOWLEDGE',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'MUSIC QUIZ',
                  style: TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Test Your Music IQ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.quiz,
                        '${questions.length} Questions',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.timer, '30 seconds per question'),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.headphones,
                        'Frank Ocean & Justin Bieber',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'START QUIZ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 20),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    final q = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2a2a2a), Color(0xFF1a1a1a)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF3a3a3a),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFD700),
                ),
                minHeight: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Question ${currentQuestionIndex + 1}/${questions.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: timeLeft <= 10
                            ? const Color(0xFFFFD700).withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: timeLeft <= 10
                              ? const Color(0xFFFFD700)
                              : Colors.white30,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 18,
                            color: timeLeft <= 10
                                ? const Color(0xFFFFD700)
                                : Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$timeLeft',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: timeLeft <= 10
                                  ? const Color(0xFFFFD700)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        q.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ...List.generate(
                        q.options.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildOptionButton(i, q),
                        ),
                      ),
                      if (hasAnswered) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedAnswer == q.correctIndex
                                ? const Color(0xFFFFD700).withOpacity(0.15)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedAnswer == q.correctIndex
                                  ? const Color(0xFFFFD700)
                                  : Colors.white30,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    selectedAnswer == q.correctIndex
                                        ? Icons.check_circle
                                        : Icons.info_outline,
                                    color: selectedAnswer == q.correctIndex
                                        ? const Color(0xFFFFD700)
                                        : Colors.white70,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    selectedAnswer == q.correctIndex
                                        ? 'Correct!'
                                        : 'Explanation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: selectedAnswer == q.correctIndex
                                          ? const Color(0xFFFFD700)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                q.explanation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            currentQuestionIndex < questions.length - 1
                                ? 'NEXT QUESTION'
                                : 'VIEW RESULTS',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, Question q) {
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;

    if (hasAnswered) {
      if (index == q.correctIndex) {
        backgroundColor = const Color(0xFFFFD700).withOpacity(0.2);
        borderColor = const Color(0xFFFFD700);
        textColor = Colors.white;
      } else if (index == selectedAnswer) {
        backgroundColor = Colors.white.withOpacity(0.05);
        borderColor = Colors.white30;
        textColor = Colors.white60;
      } else {
        backgroundColor = Colors.white.withOpacity(0.03);
        borderColor = Colors.white10;
        textColor = Colors.white38;
      }
    } else {
      backgroundColor = Colors.white.withOpacity(0.05);
      borderColor = Colors.white30;
      textColor = Colors.white;
    }

    return InkWell(
      onTap: () => selectAnswer(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: hasAnswered && index == q.correctIndex
                    ? const Color(0xFFFFD700)
                    : hasAnswered && index == selectedAnswer
                    ? Colors.white24
                    : Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    color: hasAnswered && index == q.correctIndex
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                q.options[index],
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasAnswered && index == q.correctIndex)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFFD700),
                size: 24,
              ),
            if (hasAnswered &&
                index == selectedAnswer &&
                index != q.correctIndex)
              const Icon(Icons.cancel, color: Colors.white38, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final percent = (score / questions.length * 100).round();
    String label;
    IconData icon;

    if (percent >= 80) {
      label = 'Music Expert!';
      icon = Icons.emoji_events;
    } else if (percent >= 60) {
      label = 'Great Job!';
      icon = Icons.thumb_up;
    } else if (percent >= 40) {
      label = 'Good Effort!';
      icon = Icons.sentiment_satisfied;
    } else {
      label = 'Keep Listening!';
      icon = Icons.headphones;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFD700),
                        width: 3,
                      ),
                    ),
                    child: Icon(icon, size: 80, color: const Color(0xFFFFD700)),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$score/${questions.length}',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () => setState(() => quizStarted = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
