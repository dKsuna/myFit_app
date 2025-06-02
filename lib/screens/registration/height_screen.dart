import 'package:flutter/material.dart';

class HeightScreen extends StatelessWidget {
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();

  HeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from the previous screen, with a null check
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text("Your height?")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: feetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Feet'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: inchesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Inches'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (feetController.text.isEmpty ||
                    inchesController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Enter a valid height.'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  // Merge existing arguments with the new height data
                  Navigator.pushNamed(
                    context,
                    '/goal',
                    arguments: {
                      ...?args, // Spread the existing arguments (if any)
                      'heightFeet': feetController.text,
                      'heightInches': inchesController.text,
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
