import 'package:flutter/material.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final bool questionAnswer;

  const Question(this.questionText, this.questionAnswer);
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Icon> scoreKeeper = [];

  final List<Question> questionBank = const [
    Question('Việt Nam có đường biên giới với Campuchia.', true),
    Question('Mặt trời mọc ở hướng Tây và lặn ở hướng Đông.', false),
    Question('Thủ đô của Việt Nam là Thành phố Hồ Chí Minh.', false),
    Question('Flutter là framework phát triển ứng dụng đa nền tảng của Google.', true),
    Question('Nước sôi ở nhiệt độ 100 độ C trong điều kiện áp suất tiêu chuẩn.', true),
  ];

  int questionNumber = 0;

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = questionBank[questionNumber].questionAnswer;

    setState(() {
      if (userPickedAnswer == correctAnswer) {
        scoreKeeper.add(
          const Icon(
            Icons.check,
            color: Colors.green,
            size: 24.0,
          ),
        );
      } else {
        scoreKeeper.add(
          const Icon(
            Icons.close,
            color: Colors.red,
            size: 24.0,
          ),
        );
      }

      if (questionNumber < questionBank.length - 1) {
        questionNumber++;
      } else {
        // Thông báo kết thúc và reset trò chơi
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _showFinishDialog();
          }
        });
      }
    });
  }

  void _showFinishDialog() {
    int correctAnswers =
        scoreKeeper.where((icon) => icon.icon == Icons.check).length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          title: const Text(
            'Hoàn thành Quiz!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bạn đã trả lời đúng $correctAnswers / ${questionBank.length} câu hỏi.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  questionNumber = 0;
                  scoreKeeper.clear();
                });
              },
              child: const Text(
                'Làm lại',
                style: TextStyle(color: Colors.greenAccent, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questionBank[questionNumber].questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: const Text(
                'Đúng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: const Text(
                'Sai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
          child: Row(
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
