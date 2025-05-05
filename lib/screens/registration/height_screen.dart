import 'package:flutter/material.dart';

class HeightScreen extends StatelessWidget {
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();

  HeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
                Navigator.pushNamed(context, '/goal', arguments: {
                  ...args,
                  'heightFeet': feetController.text,
                  'heightInches': inchesController.text,
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
