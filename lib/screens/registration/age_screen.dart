import 'package:flutter/material.dart';

class AgeScreen extends StatelessWidget {
  final TextEditingController ageController = TextEditingController();

  AgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text("Enter your Age")),
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
                String ageText = ageController.text.trim();

                if (ageText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an age.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  int? age = int.tryParse(ageText);

                  if (age == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else if (age <= 13 || age >= 90) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Age not valid. Please enter a valid age.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/gender',
                      arguments: {
                        ...?args,
                        'age': ageText,
                      },
                    );
                  }
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
