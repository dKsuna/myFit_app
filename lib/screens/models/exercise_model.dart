class Exercise {
  final int id;
  final String name;
  final String gender;
  final String bodyPart;
  final String equipment;
  final String category;
  final String description;
  final List<String> physicalIssues;
  final int? sets;
  final String? reps;
  final int minAge;
  final int maxAge;
  final List<String> experienceLevel;
  final List<String> goals;

  bool isAgeAppropriate(int age) {
    return age >= minAge && age <= maxAge;
  }

  Exercise({
    required this.id,
    required this.name,
    required this.gender,
    required this.bodyPart,
    required this.equipment,
    required this.category,
    required this.description,
    this.physicalIssues = const [],
    this.sets,
    this.reps,
    required this.minAge,
    required this.maxAge,
    this.experienceLevel = const [],
    this.goals = const [],
  });

  // Converts an Exercise object into a Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'category': category,
      'description': description,
      'physicalIssues': physicalIssues.join(','),
      'sets': sets,
      'reps': reps,
      'minAge': minAge,
      'maxAge': maxAge,
      'experienceLevel': experienceLevel.join(','),
      'goals': goals.join(','),
    };
  }

  // Creates an Exercise object from a Map (for fetching from the database)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      bodyPart: map['bodyPart'],
      equipment: map['equipment'],
      category: map['category'],
      description: map['description'],
      physicalIssues: (map['physicalIssues'] as String?)?.split(',') ?? [],
      sets: map['sets'],
      reps: map['reps'],
      minAge: map['minAge'],
      maxAge: map['maxAge'],
      experienceLevel: (map['experienceLevel'] as String?)?.split(',') ?? [],
      goals: (map['goals'] as String?)?.split(',') ?? [],
    );
  }

  // Creates a copy of the Exercise with new set/reps values
  Exercise copyWith({
    int? sets,
    String? reps,
  }) {
    return Exercise(
      id: id,
      name: name,
      gender: gender,
      bodyPart: bodyPart,
      equipment: equipment,
      category: category,
      description: description,
      physicalIssues: physicalIssues,
      sets: sets,
      reps: reps,
      minAge: minAge,
      maxAge: maxAge,
      experienceLevel: experienceLevel,
      goals: goals,
    );
  }

  /// Static list of gym equipment types
  static const List<String> gymEquipmentTypes = [
    'Dumbbell',
    'Barbell',
    'Machine',
  ];
}
