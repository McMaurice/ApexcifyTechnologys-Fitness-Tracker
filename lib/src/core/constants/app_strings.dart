class AppStrings {
  AppStrings._();

  static const List<String> exerciseTypes = [
    'Running',
    'Walking',
    'Cycling',
    'Swimming',
    'Yoga',
    'Weight Training',
    'HIIT',
    'Pilates',
    'Jump Rope',
    'Basketball',
    'Football',
    'Tennis',
    'Dancing',
    'Rowing',
    'Hiking',
    'Other',
  ];

  static const List<String> intensities = ['Low', 'Medium', 'High'];

  static const Map<String, String> exerciseEmoji = {
    'Running': '🏃',
    'Walking': '🚶',
    'Cycling': '🚴',
    'Swimming': '🏊',
    'Yoga': '🧘',
    'Weight Training': '🏋️',
    'HIIT': '⚡',
    'Pilates': '🤸',
    'Jump Rope': '🪢',
    'Basketball': '🏀',
    'Football': '⚽',
    'Tennis': '🎾',
    'Dancing': '💃',
    'Rowing': '🚣',
    'Hiking': '🥾',
    'Other': '🏅',
  };

  static const Map<String, double> calPerMin = {
    'Running': 10.5,
    'Walking': 4.0,
    'Cycling': 8.5,
    'Swimming': 9.0,
    'Yoga': 3.5,
    'Weight Training': 6.0,
    'HIIT': 12.0,
    'Pilates': 4.5,
    'Jump Rope': 11.0,
    'Basketball': 7.5,
    'Football': 8.0,
    'Tennis': 7.0,
    'Dancing': 5.5,
    'Rowing': 8.0,
    'Hiking': 6.5,
    'Other': 5.0,
  };

  static const Map<String, double> intensityMultiplier = {'Low': 0.70, 'Medium': 1.00, 'High': 1.35};

  static double estimateCalories(String type, int minutes, String intensity) {
    final base = calPerMin[type] ?? 5.0;
    final mult = intensityMultiplier[intensity] ?? 1.0;
    return base * minutes * mult;
  }
}
