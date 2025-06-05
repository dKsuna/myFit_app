import '../../database/db_helper.dart';
import '../models/exercise_model.dart';
import '../models/workout_model.dart';
import '../../data/exercises.dart';

Future<List<Workout>> generateWorkoutPlan(String userName) async {
  final dbHelper = DBHelper();

  // 1️⃣ Fetch user profile data
  final profile = await dbHelper.getUserByName(userName);
  if (profile.isEmpty) {
    throw Exception('User not found');
  }

  //final String gender = profile['gender'] ?? 'Any';
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
        workoutID: 1, //placeholder for workoutID
        userName: userName,
        date: workoutType, //placeholder for date
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
  const basePresets = {
    'maintain': {'count': 4, 'sets': 3, 'reps': '10-12'},
    'gain': {'count': 6, 'sets': 3, 'reps': '8-12'},
    'lose': {'count': 8, 'sets': 4, 'reps': '15-20'},
  };

  final preset = basePresets[goal.toLowerCase()]!;

  final shuffled = List.of(pool)..shuffle();

  return shuffled.take(preset['count'] as int).map((exercise) {
    int sets = preset['sets'] as int;
    String reps = preset['reps'] as String;

    // Adjust sets and reps based on exercise's goals and user's goal
    if (!exercise.goals.contains(goal)) {
      // If exercise isn't specifically for user's goal, adjust based on goal type
      switch (goal.toLowerCase()) {
        case 'lose':
          sets += 1;
          reps = adjustReps(reps, increase: true);
          break;
        case 'gain':
          sets -= 1;
          reps = adjustReps(reps, increase: true);
          break;
        case 'maintain':
          sets -= 1;
          reps = adjustReps(reps, increase: false);
          break;
      }
    }

    return exercise.copyWith(
      sets: sets,
      reps: reps,
    );
  }).toList();
}

String adjustReps(String reps, {required bool increase}) {
  final parts = reps.split('-').map((e) => int.tryParse(e.trim())).toList();

  if (parts.length != 2 || parts.contains(null)) {
    return reps; // if invalid format, return as-is
  }

  int min = parts[0]!;
  int max = parts[1]!;

  if (increase) {
    min += 2;
    max += 2;
  } else {
    min = (min - 1).clamp(1, 100);
    max = (max - 1).clamp(1, 100);
  }

  return '$min-$max';
}

Map<String, List<Exercise>> _categorizeExercises(
    List<Exercise> exercises, Set<String> requiredCategories) {
  final categorized = <String, List<Exercise>>{};

  for (final category in requiredCategories) {
    final available = exercises.where((exercise) {
      return _muscleGroupMapping[category]?.contains(exercise.bodyPart) ??
          false;
    }).toList();

    print('\nCategory: $category');
    //print('Mapped Body Parts: ${_muscleGroupMapping[category]}');
    print('Exercises found: ${available.map((e) => e.name).toList()}');

    // Debug print exercise count per category
    print('$category: ${available.length} exercises available.');

    categorized[category] = available;
  }

  print('Req. Categories: $requiredCategories');

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
  print(profile);
  final equipmentString = profile['equipmentAvailable']?.toString() ?? '';
  final physicalIssuesString = profile['physicalIssues']?.toString() ?? '';
  final String gender = profile['gender'];
  final int age = int.tryParse(profile['age'].toString()) ?? 21;
  final String experienceLevel = profile['experienceLevel'];
  final String goal = profile['goal'];

  final hasEquipment =
      equipmentString.split(',').map((e) => e.trim().toLowerCase()).expand((e) {
    if (e == 'gym equipment') {
      print(Exercise.gymEquipmentTypes.map((type) => type.toLowerCase()));
      return Exercise.gymEquipmentTypes.map((type) => type.toLowerCase());
    }
    print([e]);
    return [e];
  }).toSet();

  final physicalIssuesSet = physicalIssuesString
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet();

  return allExercises.where((exercise) {
    // Only include if user has equipment or exercise is bodyweight
//if when selected is bodyweight and error occurs de-comment the following line
    final matchesEquipment = //exercise.equipment.toLowerCase() == 'bodyweight' ||
        hasEquipment.contains(exercise.equipment.toLowerCase());
//SOMETHING WRONG IN THIS PART OF THE CODE
    // Exclude exercises that target user's physical issues
    final hasIssue = exercise.physicalIssues
        .any((issue) => physicalIssuesSet.contains(issue));

    final matchesGender = exercise.gender == 'Any' || exercise.gender == gender;
    final ageAppropriate = exercise.isAgeAppropriate(age);
    final matchesExperience =
        exercise.experienceLevel.contains(experienceLevel);
    final goalMatches =
        exercise.goals.isEmpty || exercise.goals.contains(goal.toLowerCase());

    //debug
    print('Available equipment: $hasEquipment');
    //print(
    //'Exercise: ${exercise.name} | Experience Levels: ${exercise.experienceLevel} | User: $experienceLevel');

    //print('Exercises filtered: ${.map((e) => e.name)}');

    return matchesEquipment &&
        !hasIssue &&
        matchesGender &&
        ageAppropriate &&
        matchesExperience &&
        goalMatches;
  }).toList();
}
