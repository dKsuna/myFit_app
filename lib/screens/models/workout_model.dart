import 'dart:convert';
import 'exercise_model.dart';

class Workout {
  //final int userId;
  final String? workoutName;
  final String day;
  final String type; // Full Body, Upper, Lower, etc.
  final List<Exercise> exercises; // List of exercises for the day

  Workout({
    //required this.userId,
    this.workoutName,
    required this.day,
    required this.type,
    required this.exercises,
  });

  // Converts a Workout object into a Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      //'userId': userId,
      'workoutName': workoutName,
      'day': day,
      'type': type,
      // Encode exercises list as JSON string
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList()),
    };
  }

  // Creates a Workout object from a Map (for fetching from the database)
  factory Workout.fromMap(Map<String, dynamic> map) {
    final exercisesJson = map['exercises'] as String? ?? '[]';
    final List<dynamic> exercisesList = jsonDecode(exercisesJson);

    return Workout(
      //userId: map['userId'],
      workoutName: map['workoutName'],
      day: map['day'],
      type: map['type'],
      exercises: exercisesList.map((e) => Exercise.fromMap(e)).toList(),
    );
  }
}
