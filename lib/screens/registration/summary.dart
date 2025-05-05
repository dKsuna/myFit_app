import 'package:flutter/material.dart';
import 'package:myfit/screens/models/user_model.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get args map from previous screen
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Registration Complete!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // build user object from args
                User user = User(
                  name: args['name'],
                  age: int.parse(args['age']),
                  weightKg: double.parse(args['weight']),
                  heightFeet: int.parse(args['heightFeet']),
                  heightInches: int.parse(args['heightInches']),
                  fitnessGoal: args['goal'],
                  experienceLevel: args['experience'],
                  physicalIssues: args['issues'],
                  workoutDays: args['days'],
                  equipmentAccess: args['equipment'],
                );

                // navigate and pass user
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: user,
                );
              },
              child: const Text('View your details'),
            )
          ],
        ),
      ),
    );
  }
}
