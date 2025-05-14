import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String _fitnessGoal = 'Lose';

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from the previous screen, with a null check
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If arguments are not null and 'goal' is available, set it to _fitnessGoal
    if (args != null && args['goal'] != null) {
      _fitnessGoal = args['goal'];
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _fitnessGoal,
              items: ['Lose', 'Gain', 'Maintain'].map((goal) {
                return DropdownMenuItem(value: goal, child: Text(goal));
              }).toList(),
              onChanged: (val) => setState(() => _fitnessGoal = val!),
              decoration: const InputDecoration(labelText: 'Select your goal'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Merge existing arguments with the new goal
                Navigator.pushNamed(
                  context,
                  '/experience',
                  arguments: {
                    ...?args, // Spread the existing arguments (if any)
                    'goal': _fitnessGoal
                  },
                );
              },
              child: const Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}
