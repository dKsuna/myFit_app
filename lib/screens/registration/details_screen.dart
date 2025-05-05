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
        backgroundColor: Colors.cyan,
        titleTextStyle: TextStyle(
          //backgroundColor: Colors.cyan,
          color: Colors.black,
          fontSize: 25.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text("Age: ${user.age}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text("Weight: ${user.weightKg} kg",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Height: ${user.heightFeet} ft ${user.heightInches} in",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Fitness Goal: ${user.fitnessGoal}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Experience Level: ${user.experienceLevel}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Physical Issues: ${user.physicalIssues}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Workout Days: ${user.workoutDays}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Equipment Access: ${user.equipmentAccess}",
                style: const TextStyle(fontSize: 20)),
            //const SizedBox(height: 20),
            const Spacer(), // Pushes content up and reserves space for the button below
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text("->", style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
