import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:quiz_maker/services/Database.dart';
import 'package:quiz_maker/models/question_model.dart';
import 'package:quiz_maker/views/results.dart';
import 'package:quiz_maker/widget/widget.dart';
import 'package:quiz_maker/widgets/quiz_play_widgets.dart';

class QuizPlay extends StatefulWidget {
  const QuizPlay({Key? key, required this.quizId}) : super(key: key);
  final String quizId;
  @override
  State<QuizPlay> createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;

Stream? infoStream;

class _QuizPlayState extends State<QuizPlay> {
  late QuerySnapshot querySnapshot;
  DatabaseService databaseService = DatabaseService();
  bool isLoading = true;
  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((value) {
      querySnapshot = value;
      _notAttempted = querySnapshot.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = querySnapshot.docs.length;
      setState(() {});
      print('$total ${widget.quizId}');
    });

    infoStream = infoStream ??
        Stream<List<int>>.periodic(const Duration(microseconds: 1000), (x) {
          return [_correct, _incorrect];
        });

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();
    questionModel.question = questionSnapshot.get('question');
    List<String> options = [
      questionSnapshot.get('option1'),
      questionSnapshot.get('option2'),
      questionSnapshot.get('option3'),
      questionSnapshot.get('option4'),
    ];
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.get('option1');
    questionModel.answered = false;
    return questionModel;
  }

  resultShow() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Results(
          total: total,
          correct: _correct,
          incorrect: _incorrect,
          notattempted: _notAttempted,
        ),
      ),
    );
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        title: const AppLogo(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(children: [
                  InfoHeader(
                    length: querySnapshot.docs.length,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  querySnapshot.docs == null
                      ? const Center(
                          child: Text("No Data"),
                        )
                      : ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return QuizPlayTile(
                              questionModel: getQuestionModelFromDatasnapshot(
                                  querySnapshot.docs[index]),
                              index: index,
                            );
                          }),
                  const SizedBox(
                    height: 50,
                  )
                ]),
              ),
            ),
      floatingActionButton: GestureDetector(
        onTap: resultShow,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'show result'.toUpperCase(),
            style: const TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  const InfoHeader({Key? key, required this.length}) : super(key: key);
  final int length;

  @override
  State<InfoHeader> createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: ((context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: 40,
                margin: const EdgeInsets.only(left: 14),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    NoOfQuestionTile(text: 'Total', number: widget.length),
                    NoOfQuestionTile(text: 'Correct', number: _correct),
                    NoOfQuestionTile(text: 'InCorrect', number: _incorrect),
                    NoOfQuestionTile(
                        text: 'NotAttempted', number: _notAttempted),
                  ],
                ),
              )
            : const Center(child: Text('No Data'));
      }),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  const QuizPlayTile(
      {Key? key, required this.questionModel, required this.index})
      : super(key: key);
  final QuestionModel questionModel;
  final int index;
  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Q${widget.index + 1}: ${widget.questionModel.question}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      GestureDetector(
        onTap: () {
          if (!widget.questionModel.answered) {
            if (widget.questionModel.option1 ==
                widget.questionModel.correctOption) {
              setState(() {
                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
              });
            } else {
              setState(() {
                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
              });
            }
          }
        },
        child: OptionTile(
          correctAnswer: widget.questionModel.correctOption,
          description: widget.questionModel.option1,
          option: 'A',
          optionSelected: optionSelected,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      GestureDetector(
        onTap: () {
          if (!widget.questionModel.answered) {
            if (widget.questionModel.option2 ==
                widget.questionModel.correctOption) {
              setState(() {
                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
              });
            } else {
              setState(() {
                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
              });
            }
          }
        },
        child: OptionTile(
          correctAnswer: widget.questionModel.correctOption,
          description: widget.questionModel.option2,
          option: 'B',
          optionSelected: optionSelected,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      GestureDetector(
        onTap: () {
          if (!widget.questionModel.answered) {
            if (widget.questionModel.option3 ==
                widget.questionModel.correctOption) {
              setState(() {
                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
              });
            } else {
              setState(() {
                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
              });
            }
          }
        },
        child: OptionTile(
          correctAnswer: widget.questionModel.correctOption,
          description: widget.questionModel.option3,
          option: 'C',
          optionSelected: optionSelected,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      GestureDetector(
        onTap: () {
          if (!widget.questionModel.answered) {
            if (widget.questionModel.option4 ==
                widget.questionModel.correctOption) {
              setState(() {
                optionSelected = widget.questionModel.option4;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
              });
            } else {
              setState(() {
                optionSelected = widget.questionModel.option4;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
              });
            }
          }
        },
        child: OptionTile(
          correctAnswer: widget.questionModel.correctOption,
          description: widget.questionModel.option4,
          option: 'D',
          optionSelected: optionSelected,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
