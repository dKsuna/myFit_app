import 'package:flutter/material.dart';
import 'package:myfit/screens/models/user_model.dart';

class DetailsScreen extends StatelessWidget {
  final User user;

  const DetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Age: ${user.age}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Weight: ${user.weightKg} kg",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Height: ${user.heightFeet} ft ${user.heightInches} in",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Fitness Goal: ${user.fitnessGoal}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Experience Level: ${user.experienceLevel}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Physical Issues: ${user.physicalIssues}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Workout Days: ${user.workoutDays}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Equipment Access: ${user.equipmentAccess}",
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
