import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/matrix4_transform

void main() async => runApp(MaterialApp(home: Demo()));

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scale and Translate Example')),
      body: Stack(
        children: [
          box1(),
          box2(),
          box3(),
          box4(),
        ],
      ),
    );
  }

  Center box1() => Center(child: box('140×180'));

  Center box2() {
    return Center(
      child: Container(
        transform:
            Matrix4Transform().scaleBy(x: 1.5, y: 1.5, origin: Offset(140 / 2, 180 / 2)).matrix4,
        child: box('140×180\nScale 1.5×1.5 (origin 70×90)'),
      ),
    );
  }

  Center box3() {
    return Center(
      child: Container(
        transform: Matrix4Transform().translate(x: 140, y: 180).scaleBy(x: 1.5, y: 1.5).matrix4,
        child: box('140×180\nScale 1.5×1.5\n(origin 140×180)'),
      ),
    );
  }

  Center box4() {
    return Center(
      child: Container(
        transform: Matrix4Transform().scaleBy(x: 1.5, y: 1.5).translate(x: 140, y: 180).matrix4,
        child: box('140×180\nScale 1.5×1.5\n(origin 140×180)'),
      ),
    );
  }

  Container box(String text) {
    return Container(
      color: Colors.red.withOpacity(0.5),
      width: 140,
      height: 180,
      child: Text(text, style: TextStyle(fontSize: 10.5)),
    );
  }
}
