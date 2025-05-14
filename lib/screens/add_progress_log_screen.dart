import 'package:flutter/material.dart';
import 'package:myfit/database/db_helper.dart';

class AddProgressLogScreen extends StatefulWidget {
  const AddProgressLogScreen({super.key});

  @override
  State<AddProgressLogScreen> createState() => _AddProgressLogScreenState();
}

class _AddProgressLogScreenState extends State<AddProgressLogScreen> {
  final _formKey = GlobalKey<FormState>();

  final userIdController = TextEditingController();
  final dateStartedController = TextEditingController();
  final logDateController = TextEditingController();
  final weightController = TextEditingController();
  final chestController = TextEditingController();
  final waistController = TextEditingController();
  final armsController = TextEditingController();

  final dbHelper = DBHelper();

  Future<void> saveProgressLog() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> log = {
        'UserID': int.parse(userIdController.text),
        'DateStarted': dateStartedController.text,
        'LogDate': logDateController.text,
        'Weight': double.parse(weightController.text),
        'Chest': double.parse(chestController.text),
        'Waist': double.parse(waistController.text),
        'Arms': double.parse(armsController.text),
      };

      await dbHelper.insertProgressLog(log);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress log added successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    userIdController.dispose();
    dateStartedController.dispose();
    logDateController.dispose();
    weightController.dispose();
    chestController.dispose();
    waistController.dispose();
    armsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Progress Log')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter user ID' : null,
              ),
              TextFormField(
                controller: dateStartedController,
                decoration: const InputDecoration(
                    labelText: 'Routine Start Date (YYYY-MM-DD)'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter start date' : null,
              ),
              TextFormField(
                controller: logDateController,
                decoration:
                    const InputDecoration(labelText: 'Log Date (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Enter log date' : null,
              ),
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter weight' : null,
              ),
              TextFormField(
                controller: chestController,
                decoration: const InputDecoration(labelText: 'Chest (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter chest size' : null,
              ),
              TextFormField(
                controller: waistController,
                decoration: const InputDecoration(labelText: 'Waist (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter waist size' : null,
              ),
              TextFormField(
                controller: armsController,
                decoration: const InputDecoration(labelText: 'Arms (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter arms size' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProgressLog,
                child: const Text('Save Progress Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
