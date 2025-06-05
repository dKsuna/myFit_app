import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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
  late VideoPlayerController _videoController;
  List<Workout> _generatedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DBHelper();
    _videoController = VideoPlayerController.asset('lib/assets/pull_up.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _generateRoutine() async {
    final user = await _dbHelper.getUserByName(widget.userName);

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

  void _playPauseVideo() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Routine')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _generateRoutine,
                child: const Text('Generate Routine'),
              ),
              const SizedBox(height: 20),

              // Generated Workouts List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
              const SizedBox(height: 30),

              const Text(
                'Workout Video Tip',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              AspectRatio(
                aspectRatio: _videoController.value.isInitialized
                    ? _videoController.value.aspectRatio
                    : 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _videoController.value.isInitialized
                        ? VideoPlayer(_videoController)
                        : const Center(child: CircularProgressIndicator()),

                    // Play Button Overlay
                    if (!_videoController.value.isPlaying)
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            size: 64, color: Colors.white),
                        onPressed: _playPauseVideo,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Buttons Row
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
