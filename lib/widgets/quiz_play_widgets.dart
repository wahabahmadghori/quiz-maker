import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  const OptionTile(
      {Key? key,
      required this.option,
      required this.description,
      required this.correctAnswer,
      required this.optionSelected})
      : super(key: key);
  final String option, description, correctAnswer, optionSelected;

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(children: [
        Container(
          height: 28,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.optionSelected == widget.description
                    ? widget.correctAnswer == widget.optionSelected
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                    : Colors.grey,
                width: 1.5),
            color: widget.optionSelected == widget.description
                ? widget.correctAnswer == widget.optionSelected
                    ? Colors.green.withOpacity(0.7)
                    : Colors.red.withOpacity(0.7)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.option,
            style: TextStyle(
                color: widget.optionSelected == widget.description
                    ? Colors.white
                    : Colors.grey),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          widget.description,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black54,
          ),
        )
      ]),
    );
  }
}

class NoOfQuestionTile extends StatefulWidget {
  const NoOfQuestionTile({Key? key, required this.text, required this.number})
      : super(key: key);
  final String text;
  final int number;
  @override
  State<NoOfQuestionTile> createState() => _NoOfQuestionTileState();
}

class _NoOfQuestionTileState extends State<NoOfQuestionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            color: Colors.blue,
          ),
          child: Text(
            widget.number.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            color: Colors.black54,
          ),
          child: Text(
            widget.text.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
