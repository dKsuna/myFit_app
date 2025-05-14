import 'package:flutter/material.dart';
import 'package:myfit/database/db_helper.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final goalController = TextEditingController();
  final experienceController = TextEditingController();
  final equipmentController = TextEditingController();

  final dbHelper = DBHelper();

  // Function to save user to database
  Future<void> saveUser() async {
    if (_formKey.currentState!.validate()) {
      // Prepare user data for insertion/update
      Map<String, dynamic> user = {
        'Name': nameController.text,
        'Age': int.parse(ageController.text),
        'Gender': genderController.text,
        'Height': double.parse(heightController.text),
        'Weight': double.parse(weightController.text),
        'Goal': goalController.text,
        'ExperienceLevel': experienceController.text,
        'EquipmentAvailable': equipmentController.text
      };

      // Insert or update the user in the database
      await dbHelper.insertUser(user);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added/updated successfully')),
      );

      // Close the screen after saving
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up memory
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalController.dispose();
    experienceController.dispose();
    equipmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name input
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              // Age input
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter age' : null,
              ),
              // Gender input
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) => value!.isEmpty ? 'Enter gender' : null,
              ),
              // Height input
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter height' : null,
              ),
              // Weight input
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter weight' : null,
              ),
              // Goal input
              TextFormField(
                controller: goalController,
                decoration: const InputDecoration(labelText: 'Goal'),
                validator: (value) => value!.isEmpty ? 'Enter goal' : null,
              ),
              // Experience level input
              TextFormField(
                controller: experienceController,
                decoration:
                    const InputDecoration(labelText: 'Experience Level'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter experience level' : null,
              ),
              // Equipment available input
              TextFormField(
                controller: equipmentController,
                decoration:
                    const InputDecoration(labelText: 'Equipment Available'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter equipment info' : null,
              ),
              const SizedBox(height: 20),
              // Save button
              ElevatedButton(
                onPressed: saveUser,
                child: const Text('Save User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
