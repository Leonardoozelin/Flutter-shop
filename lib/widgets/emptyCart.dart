import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.network('https://static.thenounproject.com/png/632851-200.png'),
          Text(
            label,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
