import 'package:flutter/material.dart';

class AgeScreen extends StatelessWidget {
  final TextEditingController ageController = TextEditingController();

  AgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely get the arguments from the previous screen
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text("What's your age?")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Merge existing arguments with the new age data
                Navigator.pushNamed(
                  context,
                  '/weight',
                  arguments: {
                    ...?args, // Spread the existing arguments (if any)
                    'age': ageController.text,
                  },
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
