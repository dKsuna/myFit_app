class User {
  final String name;
  final int age;
  final double weightKg;
  final int heightFeet;
  final int heightInches;
  final String fitnessGoal;
  final String experienceLevel;
  final List physicalIssues;
  final List workoutDays;
  final String equipmentAccess;

  User({
    required this.name,
    required this.age,
    required this.weightKg,
    required this.heightFeet,
    required this.heightInches,
    required this.fitnessGoal,
    required this.experienceLevel,
    required this.physicalIssues,
    required this.workoutDays,
    required this.equipmentAccess,
  });

  User copyWith({
    String? name,
    int? age,
    double? weightKg,
    int? heightFeet,
    int? heightInches,
    String? fitnessGoal,
    String? experienceLevel,
    List? physicalIssues,
    List? workoutDays,
    String? equipmentAccess,
  }) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      physicalIssues: physicalIssues ?? this.physicalIssues,
      workoutDays: workoutDays ?? this.workoutDays,
      equipmentAccess: equipmentAccess ?? this.equipmentAccess,
    );
  }
/*
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'weightKg': weightKg,
      'heightFeet': heightFeet,
      'heightInches': heightInches,
      'fitnessGoal': fitnessGoal,
      'experienceLevel': experienceLevel,
      'physicalIssues': physicalIssues,
      'workoutDays': workoutDays.join(', '),
      'equipmentAccess': equipmentAccess,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      age: map['age'],
      weightKg: map['weightKg'],
      heightFeet: map['heightFeet'],
      heightInches: map['heightInches'],
      fitnessGoal: map['fitnessGoal'],
      experienceLevel: map['experienceLevel'],
      physicalIssues: map['physicalIssues'],
      workoutDays: map['workoutDays'].split(', '),
      equipmentAccess: map['equipmentAccess'],
    );
  }
}*/
}
