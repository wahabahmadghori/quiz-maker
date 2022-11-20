import 'package:flutter/material.dart';
import 'package:quiz_maker/widget/widget.dart';
import 'package:quiz_maker/services/Database.dart';
import 'package:flutter/services.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key, required this.quizId}) : super(key: key);
  final String quizId;
  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  DatabaseService databaseService = DatabaseService();

  uploadQuizData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> questionData = {
        'question': question,
        'option1': option1,
        'option2': option2,
        'option3': option3,
        'option4': option4,
      };

      databaseService
          .addQuestionData(questionData, widget.quizId)
          .then((value) {
        setState(() {
          question = '';
          option1 = '';
          option2 = '';
          option3 = '';
          option4 = '';
          isLoading = false;
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      print('error is happening');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.quizId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black54),
        title: const AppLogo(),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Question"),
                      validator: (val) =>
                          val!.isEmpty ? "Enter Question" : null,
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Option1 (correct Answer)"),
                      validator: (val) => val!.isEmpty ? "Option1" : null,
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Option2"),
                      validator: (val) => val!.isEmpty ? "Option2" : null,
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Option3"),
                      validator: (val) => val!.isEmpty ? "Option3" : null,
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Option4"),
                      validator: (val) => val!.isEmpty ? "Option4" : null,
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            uploadQuizData();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text('Add Question',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
