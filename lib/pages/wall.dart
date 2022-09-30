import 'package:flutter/material.dart';

class Wall extends StatelessWidget {
  final wallWidth;
  final wallHeight;
  final wallX;
  final bool isThisBottomWall;

  Wall(
      {this.wallHeight,
      this.wallWidth,
      required this.isThisBottomWall,
      this.wallX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
          (2 * wallX + wallWidth) / (2 - wallWidth), isThisBottomWall ? 1 : -1),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * wallWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * wallHeight / 2,
      ),
    );
  }
}
