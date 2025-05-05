import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("What's your name?")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/age', arguments: {
                  'name': nameController.text,
                });
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
