import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? uid;
  DatabaseService({this.uid});
  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection('users')
        .add(userData)
        .then((value) => print('User Added'))
        .catchError((error) => print(error));
  }

  getData() async {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Future<void> addQuizData(Map<String, dynamic> quizData) async {
    try {
      await FirebaseFirestore.instance.collection('Quiz').add(quizData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Quiz')
          .doc(quizId)
          .collection('QNA')
          .add(questionData);
    } catch (e) {
      print(e);
    }
  }

  getQuizData() async {
    return FirebaseFirestore.instance.collection('Quiz').snapshots();
  }

  getQuestionData(String quizId) async {
    print(quizId);
    return await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}
