import 'package:flutter/material.dart';
import 'package:quiz_maker/widget/widget.dart';
import 'package:quiz_maker/services/Database.dart';
import 'package:flutter/services.dart';
import 'add_question.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key, required this.quizId}) : super(key: key);
  final String quizId;
  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  String quizImageUrl = '', quizTitle = '', quizDesc = '';
  DatabaseService databaseService = DatabaseService();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  createQuiz() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> quizData = {
        'quizImageUrl': quizImageUrl,
        'quizTitle': quizTitle,
        'quizDesc': quizDesc,
      };
      databaseService.addQuizData(quizData).then((value) {
        setState(() {
          false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddQuestion(
              quizId: widget.quizId,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black54),
        title: const AppLogo(),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formkey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Quiz Image Url'),
              validator: (val) => val!.isEmpty ? "Enter Quiz Image Url" : null,
              onChanged: (val) {
                quizImageUrl = val;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Quiz Title'),
              validator: (val) => val!.isEmpty ? "Enter Quiz Title" : null,
              onChanged: (val) {
                quizTitle = val;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Quiz Description'),
              validator: (val) =>
                  val!.isEmpty ? "Enter Quiz Description" : null,
              onChanged: (val) {
                quizDesc = val;
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                createQuiz();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text('Create Quiz',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 60),
          ]),
        ),
      ),
    );
  }
}
