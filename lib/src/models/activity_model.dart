class Activity {
  final String? id;
  final String exerciseType;
  final int durationMinutes;
  final double caloriesBurned;
  final int steps;
  final String intensity;   
  final String notes;
  final DateTime date;

  const Activity({
    this.id,
    required this.exerciseType,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.steps,
    required this.intensity,
    required this.notes,
    required this.date,
  });

  // ── SQLite helpers ──────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() => {
    'id':              id,
    'exerciseType':    exerciseType,
    'durationMinutes': durationMinutes,
    'caloriesBurned':  caloriesBurned,
    'steps':           steps,
    'intensity':       intensity,
    'notes':           notes,
    'date':            date.toIso8601String(),
  };

  factory Activity.fromMap(Map<String, dynamic> m) => Activity(
    id:              m['id'] as String,
    exerciseType:    m['exerciseType'] as String,
    durationMinutes: m['durationMinutes'] as int,
    caloriesBurned:  (m['caloriesBurned'] as num).toDouble(),
    steps:           m['steps'] as int,
    intensity:       m['intensity'] as String,
    notes:           m['notes'] as String,
    date:            DateTime.parse(m['date'] as String),
  );

  Activity copyWith({
    String?   id,
    String?   exerciseType,
    int?      durationMinutes,
    double?   caloriesBurned,
    int?      steps,
    String?   intensity,
    String?   notes,
    DateTime? date,
  }) => Activity(
    id:              id              ?? this.id,
    exerciseType:    exerciseType    ?? this.exerciseType,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    caloriesBurned:  caloriesBurned  ?? this.caloriesBurned,
    steps:           steps           ?? this.steps,
    intensity:       intensity       ?? this.intensity,
    notes:           notes           ?? this.notes,
    date:            date            ?? this.date,
  );
}
