class AppHelpers {
  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning 🌅';
    if (h < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }

  static String bigNumberFormater(int number) {
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}k';
    return '$number';
  }
}
