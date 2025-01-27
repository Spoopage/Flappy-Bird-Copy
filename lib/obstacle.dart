import 'package:flutter/material.dart';

class Obstacles extends StatelessWidget {
  //const Obstacles({super.key, this.size});

  final size;

  Obstacles({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 10, color: Colors.green.shade900),
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}