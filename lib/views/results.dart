import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/widget.dart';

class Results extends StatefulWidget {
  const Results(
      {Key? key,
      required this.total,
      required this.correct,
      required this.incorrect,
      required this.notattempted})
      : super(key: key);
  final int total, correct, incorrect, notattempted;
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(color: Colors.black87),
          title: const AppLogo(),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0.0,
          backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.total.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'you answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text('Go to home',
                    style: TextStyle(color: Colors.white, fontSize: 19)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
