import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../screens/models/workout_model.dart';
import '../screens/models/workout_gen.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Workout> _generatedWorkouts = [];

  Future<void> _generateRoutine() async {
    final user = await _dbHelper.getUserByName(
        'asdf'); // placeholder change to the value inserted by the user

    if (user.isNotEmpty) {
      final generatedRoutine = await generateWorkoutPlan('asdf');
      setState(() {
        print('in _generateRoutine');
        _generatedWorkouts = generatedRoutine;
      });
    }
  }

  Future<void> _saveRoutine() async {
    if (_generatedWorkouts.isNotEmpty) {
      for (var workout in _generatedWorkouts) {
        await _dbHelper.insertWorkout(workout.toMap());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Routine saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Routine')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _generateRoutine,
              child: const Text('Generate Routine'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _generatedWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = _generatedWorkouts[index];
                  return ListTile(
                    title: Text('${workout.day} - ${workout.type}'),
                    subtitle: Text('${workout.exercises.length} exercises'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('${workout.day} - ${workout.type}'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              shrinkWrap: true,
                              children: workout.exercises.map((e) {
                                return ListTile(
                                  title: Text(e.name),
                                  subtitle: Text(
                                    'Sets: ${e.sets ?? '-'} | Reps: ${e.reps ?? '-'}',
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/editRoutine');
                  },
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: _saveRoutine,
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
