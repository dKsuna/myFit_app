import 'dart:convert';
import 'exercise_model.dart';

class Workout {
  final int workoutID;
  final String? userName;
  final String date;
  final String day;
  final String type; // Full Body, Upper, Lower, etc.
  final List<Exercise> exercises; // List of exercises for the day

  Workout({
    required this.workoutID,
    this.userName,
    required this.date,
    required this.day,
    required this.type,
    required this.exercises,
  });

  // Converts a Workout object into a Map (for database insertion)
  Map<String, dynamic> toMap({required String date}) {
    return {
      'userName': userName,
      'date': date,
      'day': day,
      'type': type,
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList()),
    };
  }

  // Creates a Workout object from a Map (for fetching from the database)
  /*
  factory Workout.fromMap(Map<String, dynamic> map) {
    final exercisesJson = map['exercises'] as String? ?? '[]';
    final List<dynamic> exercisesList = jsonDecode(exercisesJson);

    return Workout(
      //userId: map['userId'],
      userName: map['userName'],
      date: map['date'],
      day: map['day'],
      type: map['type'],
      exercises: exercisesList.map((e) => Exercise.fromMap(e)).toList(),
    );
  }
  */

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      workoutID: map['workoutID'],
      userName: map['userName'],
      date: map['date'],
      day: map['day'],
      type: map['type'],
      exercises: (json.decode(map['exercises']) as List)
          .map((e) => Exercise.fromMap(e))
          .toList(),
    );
  }
}
