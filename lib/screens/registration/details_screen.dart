import 'package:flutter/material.dart';
import 'package:myfit/database/db_helper.dart'; // Import DBHelper
import 'package:myfit/screens/models/user_model.dart'; // Import User model
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/shared_pfres_helper.dart';

class DetailsScreen extends StatelessWidget {
  final User user;

  const DetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        backgroundColor: Colors.cyan,
        titleTextStyle: const TextStyle(
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
            Text("Gender: ${user.gender}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text("Weight: ${user.weightKg} kg",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Height: ${user.heightFeet} ft ${user.heightInches} in",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Fitness Goal: ${user.goal}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Experience Level: ${user.experienceLevel}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Physical Issues: ${user.physicalIssues}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Workout Days: ${user.daysForWorkout}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Equipment Access: ${user.equipmentAvailable}",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  final dbHelper = DBHelper(); // Create an instance of DBHelper

                  // Insert the user into the database
                  await dbHelper.insertUser(user.toMap());

                  //debug
                  //print('name inserted is: ${user.name}');
                  List<Map<String, dynamic>> users =
                      await DBHelper().database.then((db) => db.query('Users'));
                  print('Users: $users');
                  await completeRegistration(user.name);
                  // Navigate to the main screen
                  Navigator.pushReplacementNamed(context, '/main',
                      arguments: user.name);
                },
                child: const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
