import 'package:flutter/material.dart';
import 'package:myfit/database/db_helper.dart';

class AddRoutineScreen extends StatefulWidget {
  const AddRoutineScreen({super.key});

  @override
  State<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  final _formKey = GlobalKey<FormState>();

  final userIdController = TextEditingController();
  final dateStartedController = TextEditingController();
  final routineDataController = TextEditingController();

  final dbHelper = DBHelper();

  Future<void> saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the routine data to be inserted into the database
      Map<String, dynamic> routine = {
        'UserID': int.parse(userIdController.text),
        'DateStarted': dateStartedController.text,
        'RoutineData': routineDataController.text,
      };

      // Insert the routine into the database
      await dbHelper.insertRoutine(routine);

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Routine added successfully')),
      );

      // Go back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    userIdController.dispose();
    dateStartedController.dispose();
    routineDataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Routine')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // User ID input
              TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter user ID' : null,
              ),
              // Date Started input
              TextFormField(
                controller: dateStartedController,
                decoration: const InputDecoration(
                    labelText: 'Date Started (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Enter date' : null,
              ),
              // Routine Data input
              TextFormField(
                controller: routineDataController,
                decoration: const InputDecoration(labelText: 'Routine Data'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter routine data' : null,
              ),
              const SizedBox(height: 20),
              // Save button
              ElevatedButton(
                onPressed: saveRoutine,
                child: const Text('Save Routine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
