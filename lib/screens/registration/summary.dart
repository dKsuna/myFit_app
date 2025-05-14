import 'package:flutter/material.dart';
import 'package:myfit/screens/models/user_model.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get args map from previous screen
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Validate the arguments
    final String? name = args['name'];
    final String? age = args['age'];
    final String? weight = args['weight'];
    final String? heightFeet = args['heightFeet'];
    final String? heightInches = args['heightInches'];
    final String? goal = args['goal'];
    final String? experience = args['experience'];
    final String? issues = args['issues'];
    final List<String> workoutDays = List<String>.from(args['days'] ?? []);
    final List<String> equipmentAccess =
        List<String>.from(args['equipment'] ?? []);

    // Create User object if all necessary values are valid
    if (name != null &&
        age != null &&
        weight != null &&
        heightFeet != null &&
        heightInches != null &&
        goal != null &&
        experience != null) {
      final user = User(
        name: name,
        age: int.parse(age),
        weightKg: double.parse(weight),
        heightFeet: int.parse(heightFeet),
        heightInches: int.parse(heightInches),
        fitnessGoal: goal,
        experienceLevel: experience,
        physicalIssues: issues ?? '', // Handle null case for physicalIssues
        workoutDays: workoutDays.join(','), // Convert list to string
        equipmentAccess: equipmentAccess.join(','), // Convert list to string
      );

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
    } else {
      // Handle missing or invalid arguments
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Error: Missing or invalid arguments.'),
        ),
      );
    }
  }
}
