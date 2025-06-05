import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../screens/models/workout_model.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final dbHelper = DBHelper();
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchWorkouts();
  }

  void fetchWorkouts() async {
    final workouts = await dbHelper.getWorkouts();
    setState(() {
      _workouts = workouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: _workouts.isEmpty
          ? const Center(child: Text('No workouts yet.'))
          : ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final workout = _workouts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${workout.day} - ${workout.type}'),
                    subtitle: Text(
                      '${workout.exercises.length} exercises',
                    ),
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
                                    'Sets: ${e.sets ?? '-'}, Reps: ${e.reps ?? '-'}',
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
