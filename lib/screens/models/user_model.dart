class User {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final double weightKg;
  final int heightFeet;
  final int heightInches;
  final String fitnessGoal;
  final String experienceLevel;
  final String physicalIssues;

  // Store these fields as comma-separated Strings in the database
  final String workoutDays;
  final String equipmentAccess;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightFeet,
    required this.heightInches,
    required this.fitnessGoal,
    required this.experienceLevel,
    required this.physicalIssues,
    required this.workoutDays,
    required this.equipmentAccess,
  });

  // Convert comma-separated string back to List<String>
  List<String> get workoutDaysList => workoutDays.split(',');
  List<String> get equipmentAccessList => equipmentAccess.split(',');

  // Static method to create a User from a Map (used for fetching data from SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      weightKg: map['weightKg'],
      heightFeet: map['heightFeet'],
      heightInches: map['heightInches'],
      fitnessGoal: map['fitnessGoal'],
      experienceLevel: map['experienceLevel'],
      physicalIssues: map['physicalIssues'],
      workoutDays: map['workoutDays'],
      equipmentAccess: map['equipmentAccess'],
    );
  }

  // Convert User object to Map (used for inserting data into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'weightKg': weightKg,
      'heightFeet': heightFeet,
      'heightInches': heightInches,
      'fitnessGoal': fitnessGoal,
      'experienceLevel': experienceLevel,
      'physicalIssues': physicalIssues,
      'workoutDays': workoutDays,
      'equipmentAccess': equipmentAccess,
    };
  }
}
