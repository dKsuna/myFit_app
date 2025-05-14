//import 'package:flutter/material.dart';
import '../../database/db_helper.dart';
import '../models/exercise_model.dart';
import '../models/workout_model.dart';

Future<void> generateWorkoutPlan(int userId) async {
  final dbHelper = DBHelper();

  // 1️⃣ Fetch user profile data
  final profile = await dbHelper.getUserById(userId);
  if (profile == null) {
    throw Exception('User not found');
  }

  // 2️⃣ Ensure required fields exist in the profile
  if (!profile.containsKey('DaysForWorkout') || !profile.containsKey('Goal')) {
    throw Exception('Missing necessary profile fields');
  }

  // 3️⃣ Get filtered exercises based on the user's equipment and physical issues
  final List<Exercise> availableExercises =
      await _getFilteredExercises(profile);

  // 4️⃣ Determine workout split type
  final List<String> selectedDays = profile['DaysForWorkout'].split(',');
  final Map<String, List<String>> workoutSplit =
      _determineWorkoutSplit(selectedDays.length, profile['Goal']);

  // 5️⃣ Categorize exercises based on workout split
  final Map<String, List<Exercise>> exercisePool = _categorizeExercises(
      availableExercises, workoutSplit.values.expand((v) => v).toSet());

  // 6️⃣ Create weekly workout plan
  final List<Workout> weeklyPlan = [];

  for (final day in selectedDays) {
    final String workoutType =
        workoutSplit['trainingDays']![selectedDays.indexOf(day)];
    final List<Exercise> dayExercises =
        _selectExercisesForDay(exercisePool[workoutType]!, profile['Goal']);

    weeklyPlan.add(
      Workout(
        userId: userId,
        day: day,
        type: workoutType,
        exercises: dayExercises,
      ),
    );
  }

  // 7️⃣ Save workouts to the database
  for (final workout in weeklyPlan) {
    await dbHelper.insertWorkout(workout.toMap());
  }
}

Map<String, List<String>> _determineWorkoutSplit(int totalDays, String goal) {
  final split = {
    'trainingDays': <String>[],
  };

  if (totalDays <= 3) {
    split['trainingDays'] = List.generate(totalDays, (_) => 'Full Body');
  } else if (totalDays == 4) {
    split['trainingDays'] = ['Upper', 'Lower', 'Upper', 'Lower'];
  } else {
    split['trainingDays'] = ['Push', 'Pull', 'Legs', 'Upper', 'Lower'];
  }

  return split;
}

List<Exercise> _selectExercisesForDay(List<Exercise> pool, String goal) {
  const goalPresets = {
    'strength': {'count': 4, 'sets': 4, 'reps': '4-6'},
    'hypertrophy': {'count': 6, 'sets': 3, 'reps': '8-12'},
    'endurance': {'count': 8, 'sets': 2, 'reps': '15-20'},
  };

  final preset = goalPresets[goal.toLowerCase()] ?? goalPresets['hypertrophy']!;
  final shuffled = List.of(pool)..shuffle();

  return shuffled.take(preset['count'] as int).map((exercise) {
    return exercise.copyWith(
      sets: preset['sets'] as int,
      reps: preset['reps'] as String,
    );
  }).toList();
}

Map<String, List<Exercise>> _categorizeExercises(
    List<Exercise> exercises, Set<String> requiredCategories) {
  final categorized = <String, List<Exercise>>{};

  for (final category in requiredCategories) {
    categorized[category] = exercises.where((exercise) {
      return _muscleGroupMapping[category]?.contains(exercise.bodyPart) ??
          false;
    }).toList();
  }

  return categorized;
}

const _muscleGroupMapping = {
  'Full Body': ['Chest', 'Back', 'Legs', 'Shoulders', 'Core'],
  'Upper': ['Chest', 'Back', 'Shoulders', 'Arms'],
  'Lower': ['Legs', 'Glutes', 'Core'],
  'Push': ['Chest', 'Shoulders', 'Triceps'],
  'Pull': ['Back', 'Biceps', 'Rear Delts'],
  'Legs': ['Quads', 'Hamstrings', 'Glutes', 'Calves'],
};

Future<List<Exercise>> _getFilteredExercises(
    Map<String, dynamic> profile) async {
  final dbHelper = DBHelper();

  // Parse the available equipment (split by commas and trim spaces)
  final hasEquipment = profile['EquipmentAvailable'] != null
      ? profile['EquipmentAvailable'].split(',').map((e) => e.trim()).toSet()
      : {};

  final physicalIssues = profile['PhysicalIssues'] ?? '';

  // Fetch filtered exercises from the database
  return await dbHelper.getFilteredExercises(
    hasEquipment: hasEquipment.isNotEmpty,
    physicalIssues: physicalIssues,
  );
}
