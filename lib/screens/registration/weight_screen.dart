import 'package:flutter/material.dart';

class WeightScreen extends StatelessWidget {
  final TextEditingController weightController = TextEditingController();

  WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from the previous screen, with a null check
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    //final String? gender = args['gender'];

    return Scaffold(
      appBar: AppBar(title: const Text("Enter your weight")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (weightController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a weight.'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  // Merge existing arguments with the new weight data
                  Navigator.pushNamed(
                    context,
                    '/height',
                    arguments: {
                      ...args,
                      'weight': weightController.text,
                    },
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
