import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../screens/models/workout_model.dart';
import '../screens/models/workout_gen.dart';

class RoutineScreen extends StatefulWidget {
  final String userName;
  const RoutineScreen({super.key, required this.userName});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  bool isSaved = false;
  late final DBHelper _dbHelper;
  List<Workout> _generatedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DBHelper();
  }

  Future<void> _generateRoutine() async {
    final user = await _dbHelper.getUserByName(widget
        .userName); // placeholder change to the value inserted by the user

    if (user.isNotEmpty) {
      final generatedRoutine = await generateWorkoutPlan(widget.userName);
      setState(() {
        print('in _generateRoutine');
        print(widget.userName);
        _generatedWorkouts = generatedRoutine;
        isSaved = false;
      });
    }
  }

  Future<void> _saveRoutine() async {
    try {
      if (_generatedWorkouts.isNotEmpty) {
        final dateSaved = DateTime.now();
        final formattedDate =
            '${dateSaved.year}-${dateSaved.month.toString().padLeft(2, '0')}-${dateSaved.day.toString().padLeft(2, '0')}';
        for (var workout in _generatedWorkouts) {
          await _dbHelper.insertWorkout(workout.toMap(date: formattedDate));
        }
        //display workouts saved
        List<Map<String, dynamic>> workout_display =
            await DBHelper().database.then((db) => db.query('Workouts'));
        print('Inserted Workouts:');
        print('Workouts: $workout_display');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Routine saved successfully!')),
        );

        setState(() {
          isSaved = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving routine!')),
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
                if (!isSaved)
                  ElevatedButton(
                    onPressed: _saveRoutine,
                    child: const Text('Save'),
                  )
                else
                  const Text(
                    'Routine Saved!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
