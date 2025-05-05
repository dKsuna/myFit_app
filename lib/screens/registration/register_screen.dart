import 'package:flutter/material.dart';
import 'package:myfit/screens/models/user_model.dart';
import '../db/db_helper.dart'; // Will connect this later
import 'package:flutter/foundation.dart'; //Will delete this later (dev purposes)

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();

  String _fitnessGoal = 'Lose';
  String _experienceLevel = 'Beginner';
  List<String> _physicalIssues = [];
  List<String> _workoutDays = [];
  String _equipmentAccess = 'Bodyweight';

  // Available options
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> issues = ['Knee pain', 'Back pain', 'Others', 'None'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Prepare User object
      User user = User(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weightKg: double.parse(_weightController.text),
        heightFeet: int.parse(_heightFeetController.text),
        heightInches: int.parse(_heightInchesController.text),
        fitnessGoal: _fitnessGoal,
        experienceLevel: _experienceLevel,
        physicalIssues: _physicalIssues.join(','),
        workoutDays: _workoutDays.join(','),
        equipmentAccess: _equipmentAccess,
      );

      // Insert user to DB (db_helper coming next)
      DBHelper.insertUser(user);

      // Navigate to next screen (routine or dashboard)
      Navigator.pushNamed(context, '/routine');
    }
  }

  Widget _buildCheckboxList(List<String> items, List<String> selected,
      Function(String, bool) onChanged) {
    return Column(
      children: items.map((item) {
        return CheckboxListTile(
          title: Text(item),
          value: selected.contains(item),
          onChanged: (val) {
            setState(() {
              if (val == true) {
                selected.add(item);
              } else {
                selected.remove(item);
              }
              onChanged(item, val!);
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myFit Registration'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () {
                Navigator.pushNamed(context, '/debug');
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter your age' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter your weight' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightFeetController,
                      decoration:
                          const InputDecoration(labelText: 'Height (ft)'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'ft?' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heightInchesController,
                      decoration: const InputDecoration(labelText: 'in'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'in?' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Fitness Goal'),
              DropdownButtonFormField<String>(
                value: _fitnessGoal,
                items: ['Lose', 'Gain', 'Maintain'].map((goal) {
                  return DropdownMenuItem(value: goal, child: Text(goal));
                }).toList(),
                onChanged: (val) => setState(() => _fitnessGoal = val!),
              ),
              const SizedBox(height: 16),
              const Text('Experience Level'),
              DropdownButtonFormField<String>(
                value: _experienceLevel,
                items: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (val) => setState(() => _experienceLevel = val!),
              ),
              const SizedBox(height: 16),
              const Text('Physical Issues'),
              _buildCheckboxList(issues, _physicalIssues, (item, value) {}),
              const SizedBox(height: 16),
              const Text('Workout Days'),
              _buildCheckboxList(days, _workoutDays, (item, value) {}),
              const SizedBox(height: 16),
              const Text('Equipment Access'),
              DropdownButtonFormField<String>(
                value: _equipmentAccess,
                items: ['Bodyweight', 'Gym equipment'].map((equip) {
                  return DropdownMenuItem(value: equip, child: Text(equip));
                }).toList(),
                onChanged: (val) => setState(() => _equipmentAccess = val!),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Register'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
