import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            Text("Track your progress here!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
