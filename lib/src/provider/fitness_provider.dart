import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class AppController extends GetxController {
  // ── Observable State ───────────────────────────────────────────────────────
  final RxList<Activity> allActivities = <Activity>[].obs;
  final RxList<Activity> todayActivities = <Activity>[].obs;
  final RxList<Activity> weekActivities = <Activity>[].obs;
  final Rx<FitnessGoal> goal = FitnessGoal.defaults().obs;
  final RxBool loading = false.obs;
  final RxInt currentIndex = 0.obs; // ← tracks the active bottom nav tab
  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    load(); // auto-load when controller is created
  }

  // ── Today totals ───────────────────────────────────────────────────────────
  int get todaySteps => todayActivities.fold(0, (s, a) => s + a.steps);
  double get todayCalories => todayActivities.fold(0.0, (s, a) => s + a.caloriesBurned);
  int get todayMinutes => todayActivities.fold(0, (s, a) => s + a.durationMinutes);

  // ── Weekly totals ──────────────────────────────────────────────────────────
  int get weekSteps => weekActivities.fold(0, (s, a) => s + a.steps);
  double get weekCalories => weekActivities.fold(0.0, (s, a) => s + a.caloriesBurned);
  int get weekMinutes => weekActivities.fold(0, (s, a) => s + a.durationMinutes);

  /// Distinct workout DAYS this week
  int get weekWorkouts {
    final days = weekActivities.map((a) => '${a.date.year}-${a.date.month}-${a.date.day}').toSet();
    return days.length;
  }

  // ── Progress (0.0 – 1.0) ──────────────────────────────────────────────────
  double get stepsProgress => _clamp(todaySteps / goal.value.dailySteps);
  double get caloriesProgress => _clamp(todayCalories / goal.value.dailyCalories);
  double get minutesProgress => _clamp(todayMinutes / goal.value.dailyMinutes);
  double get workoutsProgress => _clamp(weekWorkouts / goal.value.weeklyWorkouts);

  double _clamp(double v) => v.isNaN ? 0.0 : v.clamp(0.0, 1.0);

  // ── Weekly chart data (7 slots Mon→Sun) ────────────────────────────────────
  DateTime get _weekStart {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  List<double> get weeklyCaloriesList {
    final ws = _weekStart;
    return List.generate(7, (i) {
      final d = ws.add(Duration(days: i));
      return weekActivities
          .where((a) => a.date.year == d.year && a.date.month == d.month && a.date.day == d.day)
          .fold(0.0, (s, a) => s + a.caloriesBurned);
    });
  }

  List<int> get weeklyStepsList {
    final ws = _weekStart;
    return List.generate(7, (i) {
      final d = ws.add(Duration(days: i));
      return weekActivities
          .where((a) => a.date.year == d.year && a.date.month == d.month && a.date.day == d.day)
          .fold(0, (s, a) => s + a.steps);
    });
  }

  List<int> get weeklyMinutesList {
    final ws = _weekStart;
    return List.generate(7, (i) {
      final d = ws.add(Duration(days: i));
      return weekActivities
          .where((a) => a.date.year == d.year && a.date.month == d.month && a.date.day == d.day)
          .fold(0, (s, a) => s + a.durationMinutes);
    });
  }

  // ── Data loading ───────────────────────────────────────────────────────────
  Future<void> load() async {
    loading.value = true;

    final now = DateTime.now();
    final ws = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));

    allActivities.value = await DB.instance.allActivities();
    todayActivities.value = await DB.instance.activitiesForDay(now);
    weekActivities.value = await DB.instance.activitiesForWeek(ws);
    goal.value = await DB.instance.getGoal();

    loading.value = false;
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  /// Write — add a new activity and refresh
  Future<void> addActivity(Activity a) async {
    await DB.instance.insertActivity(a);
    await load();
  }

  /// Write — remove an activity by id and refresh
  Future<void> removeActivity(String id) async {
    await DB.instance.deleteActivity(id);
    await load();
  }

  /// Write — save updated goals (no full reload needed)
  Future<void> saveGoal(FitnessGoal g) async {
    await DB.instance.saveGoal(g);
    goal.value = g; // update observable directly — UI reacts instantly
  }
}
