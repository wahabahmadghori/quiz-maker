import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_maker/services/Database.dart';
import 'package:quiz_maker/views/add_question.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/views/quiz_play.dart';
import 'package:quiz_maker/widget/widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseService databaseService = DatabaseService();
  Stream? quizStream;
  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  Widget quizList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
              stream: quizStream,
              builder: (context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: Text('No Data'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: QuizTile(
                                imageUrl: snapshot.data.docs[index]
                                    ['quizImageUrl'],
                                title: snapshot.data.docs[index]['quizTitle'],
                                id: snapshot.data.docs[index].id,
                                description: snapshot.data.docs[index]
                                    ['quizDesc']),
                          );
                        });
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const AppLogo(),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0.0,
          backgroundColor: Colors.transparent),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuiz(
                quizId: "123456",
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  const QuizTile(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.id,
      required this.description})
      : super(key: key);
  final String imageUrl, title, id, description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizPlay(quizId: id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      color: Colors.black26,
                      height: 150,
                      child: const Icon(
                        Icons.add,
                        size: 54,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      print(id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuestion(
                            quizId: id,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
