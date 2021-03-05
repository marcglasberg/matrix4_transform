import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/matrix4_transform

void main() async => runApp(MaterialApp(home: Demo()));

class Demo extends StatelessWidget {
  final boxes = [
    Box(null, "Original"),
    Box(Matrix4Transform().translate(x: 25).matrix4, ".translate(x: 25)"),
    Box(Matrix4Transform().rotateDegrees(20).matrix4, ".rotateDegrees(20)"),
    Box(Matrix4Transform().rotateDegrees(45).matrix4, ".rotateDegrees(45)"),
    Box(Matrix4Transform().rotateDegrees(20, origin: Offset(25, 25)).matrix4,
        ".rotateDegrees(20, origin: Offset(25, 25))"),
    Box(Matrix4Transform().rotateDegrees(45, origin: Offset(25, 25)).matrix4,
        ".rotateDegrees(45, origin: Offset(25, 25))"),
    Box(Matrix4Transform().rotateDegrees(45, origin: Offset(25, 25)).translate(x: 25).matrix4,
        ".rotateDegrees(45, origin: Offset(25, 25)).\ntranslate(x: 25)"),
    Box(Matrix4Transform().scaleBy(x: 2.0, y: 0.5).matrix4, ".scaleBy(x: 2.0, y: 0.5)"),
    Box(Matrix4Transform().scaleBy(x: 2.0, y: 0.5, origin: Offset(25, 25)).matrix4,
        ".scaleBy(x: 2.0, y: 0.5, origin: Offset(25, 25))"),
    Box(Matrix4Transform().scaleBy(x: 2, y: 0.5, origin: Offset(25, 25)).right(25).matrix4,
        ".scaleBy(x: 2, y: 0.5, origin: Offset(25, 25))\n.right(25)"),
    Box(
        Matrix4Transform()
            .scaleBy(x: 2, y: 0.5, origin: Offset(25, 25))
            .translateOriginalCoordinates(x: 25)
            .matrix4,
        ".scaleBy(x: 2, y: 0.5, origin: Offset(25, 25))\n.translateOriginalCoordinates(x: 25)"),
    //
    Box(Matrix4Transform().flipHorizontally().matrix4, ".flipHorizontally()"),
    Box(Matrix4Transform().flipHorizontally(origin: Offset(25, 25)).matrix4,
        ".flipHorizontally(origin: Offset(25, 25))"),
    Box(Matrix4Transform().flipVertically().matrix4, ".flipVertically()"),
    Box(Matrix4Transform().flipVertically(origin: Offset(25, 25)).matrix4,
        ".flipVertically(origin: Offset(25, 25))"),
    Box(Matrix4Transform().flipDiagonally().matrix4, ".flipDiagonally())"),
    Box(Matrix4Transform().flipDiagonally(origin: Offset(25, 25)).matrix4,
        ".flipDiagonally(origin: Offset(25, 25))"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matrix4Transform Example')),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Colors.grey[400],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var box in boxes) wrap(box),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 1.5, height: double.infinity, color: Colors.black),
                  Container(width: 0.75, height: double.infinity, color: Colors.black26),
                  Container(width: 1.0, height: double.infinity, color: Colors.black26),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget wrap(Box box) {
  return Column(
    children: <Widget>[
      if (box.description != null)
        Align(
          alignment: Alignment.centerLeft,
          child: Text(box.description.toString(), style: TextStyle(fontSize: 11)),
        ),
      Container(height: 1.5, width: double.infinity, color: Colors.black),
      Container(child: box, alignment: Alignment.center, height: 50, width: double.infinity),
      Container(height: 1.0, width: double.infinity, color: Colors.black26),
      SizedBox(height: 70.0),
    ],
  );
}

class Box extends StatelessWidget {
  final Matrix4 matrix;
  final String? description;

  Box(
    Matrix4? matrix,
    this.description,
  ) : matrix = matrix ?? Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: matrix,
      color: Colors.red,
      width: 50,
      height: 50,
      child: Center(
        child: Stack(
          children: [
            Icon(Icons.cancel, color: Colors.yellow, size: 38),
            Icon(Icons.expand_less, color: Colors.yellow, size: 38),
            Icon(Icons.add_circle, color: Colors.yellow, size: 10),
          ],
        ),
      ),
    );
  }
}
