import '../../database/db_helper.dart';
import '../models/exercise_model.dart';
import '../models/workout_model.dart';
import '../../data/exercises.dart';

Future<List<Workout>> generateWorkoutPlan(int userId) async {
  final dbHelper = DBHelper();

  // 1️⃣ Fetch user profile data
  final profile = await dbHelper.getUserById(userId);
  if (profile == null) {
    throw Exception('User not found');
  }

  // 2️⃣ Ensure required fields exist in the profile
  if (!profile.containsKey('daysForWorkout') || !profile.containsKey('goal')) {
    throw Exception('Missing necessary profile fields');
  }

  // 3️⃣ Get filtered exercises based on the user's equipment and physical issues
  final List<Exercise> availableExercises =
      await _getFilteredExercises(profile);

  // 4️⃣ Determine workout split type
  final List<String> selectedDays = profile['daysForWorkout'].split(',');
  final Map<String, List<String>> workoutSplit =
      _determineWorkoutSplit(selectedDays.length, profile['goal']);

  // 5️⃣ Categorize exercises based on workout split
  final Map<String, List<Exercise>> exercisePool = _categorizeExercises(
    availableExercises,
    workoutSplit.values.expand((v) => v).toSet(),
  );

  // 6️⃣ Create weekly workout plan
  final List<Workout> weeklyPlan = [];

  for (final day in selectedDays) {
    final String workoutType =
        workoutSplit['trainingDays']![selectedDays.indexOf(day)];

    final pool = exercisePool[workoutType] ?? [];

    if (pool.isEmpty) {
      throw Exception('No exercises available for $workoutType day.');
    }

    final List<Exercise> dayExercises =
        _selectExercisesForDay(pool, profile['goal']);

    weeklyPlan.add(
      Workout(
        userId: userId,
        day: day,
        type: workoutType,
        exercises: dayExercises,
      ),
    );
  }
  return weeklyPlan;
}

Map<String, List<String>> _determineWorkoutSplit(int totalDays, String goal) {
  final split = {
    'trainingDays': <String>[],
  };

  switch (totalDays) {
    case 1:
      split['trainingDays'] = ['Full Body'];
      break;
    case 2:
      split['trainingDays'] = ['Upper', 'Lower'];
      break;
    case 3:
      split['trainingDays'] = ['Push', 'Pull', 'Legs'];
      break;
    case 4:
      split['trainingDays'] = ['Upper', 'Lower', 'Push', 'Pull'];
      break;
    case 5:
      split['trainingDays'] = ['Push', 'Pull', 'Legs', 'Upper', 'Lower'];
      break;
    case 6:
      split['trainingDays'] = [
        'Push',
        'Pull',
        'Legs',
        'Upper',
        'Lower',
        'Full Body'
      ];
      break;
    default:
      // If user selects more than 6 days, just repeat Push/Pull/Legs
      split['trainingDays'] = List.generate(
        totalDays,
        (index) => ['Push', 'Pull', 'Legs'][index % 3],
      );
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
    final available = exercises.where((exercise) {
      return _muscleGroupMapping[category]?.contains(exercise.bodyPart) ??
          false;
    }).toList();

    // Debug print exercise count per category
    print('$category: ${available.length} exercises available.');

    categorized[category] = available;
  }

  return categorized;
}

const _muscleGroupMapping = {
  'Full Body': ['Chest', 'Back', 'Legs', 'Shoulders', 'Core'],
  'Upper': ['Chest', 'Back', 'Shoulders', 'Arms'],
  'Lower': ['Legs', 'Glutes', 'Core'],
  'Push': ['Chest', 'Shoulders', 'Triceps'],
  'Pull': ['Back', 'Biceps', 'Rear Delts'],
  'Legs': ['Legs'],
};

Future<List<Exercise>> _getFilteredExercises(
    Map<String, dynamic> profile) async {
  final equipmentString = profile['equipmentAvailable']?.toString() ?? '';
  final physicalIssuesString = profile['physicalIssues']?.toString() ?? '';

  final hasEquipment = equipmentString
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet();

  final physicalIssuesSet = physicalIssuesString
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet();

  return allExercises.where((exercise) {
    // Only include if user has equipment or exercise is bodyweight
    final matchesEquipment = exercise.equipment == 'Bodyweight' ||
        hasEquipment.contains(exercise.equipment);

    // Exclude exercises that target user's physical issues
    final hasIssue = exercise.physicalIssues
        .any((issue) => physicalIssuesSet.contains(issue));

    return matchesEquipment && !hasIssue;
  }).toList();
}
