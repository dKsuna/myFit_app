class Exercise {
  final int id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String category; // E.g. Full Body, Upper, Lower, etc.
  final String description;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.category,
    required this.description,
  });

  // Converts an Exercise object into a Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'category': category,
      'description': description,
    };
  }

  // Creates an Exercise object from a Map (for fetching from the database)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      bodyPart: map['bodyPart'],
      equipment: map['equipment'],
      category: map['category'],
      description: map['description'],
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
      bodyPart: bodyPart,
      equipment: equipment,
      category: category,
      description: description,
    );
  }
}
