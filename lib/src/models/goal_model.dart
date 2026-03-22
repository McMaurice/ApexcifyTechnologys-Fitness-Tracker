class FitnessGoal {
  final int dailySteps;
  final double dailyCalories;
  final int dailyMinutes;
  final int weeklyWorkouts;

  const FitnessGoal({
    required this.dailySteps,
    required this.dailyCalories,
    required this.dailyMinutes,
    required this.weeklyWorkouts,
  });

  factory FitnessGoal.defaults() => const FitnessGoal(
    dailySteps:      10000,
    dailyCalories:   500,
    dailyMinutes:    45,
    weeklyWorkouts:  5,
  );

  Map<String, dynamic> toMap() => {
    'dailySteps':      dailySteps,
    'dailyCalories':   dailyCalories,
    'dailyMinutes':    dailyMinutes,
    'weeklyWorkouts':  weeklyWorkouts,
  };

  factory FitnessGoal.fromMap(Map<String, dynamic> m) => FitnessGoal(
    dailySteps:     (m['dailySteps']     as num).toInt(),
    dailyCalories:  (m['dailyCalories']  as num).toDouble(),
    dailyMinutes:   (m['dailyMinutes']   as num).toInt(),
    weeklyWorkouts: (m['weeklyWorkouts'] as num).toInt(),
  );

  FitnessGoal copyWith({
    int?    dailySteps,
    double? dailyCalories,
    int?    dailyMinutes,
    int?    weeklyWorkouts,
  }) => FitnessGoal(
    dailySteps:     dailySteps     ?? this.dailySteps,
    dailyCalories:  dailyCalories  ?? this.dailyCalories,
    dailyMinutes:   dailyMinutes   ?? this.dailyMinutes,
    weeklyWorkouts: weeklyWorkouts ?? this.weeklyWorkouts,
  );
}
