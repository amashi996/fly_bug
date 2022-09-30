import 'package:flutter/material.dart';

class Bug extends StatelessWidget {
  final bugY;
  final double bugWidth;
  final double bugHeight;

  Bug({this.bugY, required this.bugWidth, required this.bugHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * bugY + bugHeight) / (2 - bugHeight)),
      child: Image.asset(
        'lib/images/bird.png',
        width: MediaQuery.of(context).size.height * bugWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * bugHeight / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
