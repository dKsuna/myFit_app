import 'exercise_model.dart';

class Workout {
  final int userId;
  final String day;
  final String type; // Full Body, Upper, Lower, etc.
  final List<Exercise> exercises; // List of exercises for the day

  Workout({
    required this.userId,
    required this.day,
    required this.type,
    required this.exercises,
  });

  // Converts a Workout object into a Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'day': day,
      'type': type,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  // Creates a Workout object from a Map (for fetching from the database)
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      userId: map['userId'],
      day: map['day'],
      type: map['type'],
      exercises: List<Exercise>.from(
        map['exercises']?.map((e) => Exercise.fromMap(e)) ?? [],
      ),
    );
  }
}
