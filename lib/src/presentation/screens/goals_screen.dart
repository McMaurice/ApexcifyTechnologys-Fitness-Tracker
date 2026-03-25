import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final AppController _ctrl;
  late TextEditingController _stepsCtrl;
  late TextEditingController _calCtrl;
  late TextEditingController _minCtrl;
  late TextEditingController _wkCtrl;

  final RxBool _editing = false.obs;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<AppController>(); 
    final g = _ctrl.goal.value;
    _stepsCtrl = TextEditingController(text: g.dailySteps.toString());
    _calCtrl = TextEditingController(text: g.dailyCalories.toInt().toString());
    _minCtrl = TextEditingController(text: g.dailyMinutes.toString());
    _wkCtrl = TextEditingController(text: g.weeklyWorkouts.toString());
  }

  @override
  void dispose() {
    _stepsCtrl.dispose();
    _calCtrl.dispose();
    _minCtrl.dispose();
    _wkCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final g = FitnessGoal(
      dailySteps: int.tryParse(_stepsCtrl.text) ?? 10000,
      dailyCalories: double.tryParse(_calCtrl.text) ?? 500,
      dailyMinutes: int.tryParse(_minCtrl.text) ?? 45,
      weeklyWorkouts: int.tryParse(_wkCtrl.text) ?? 5,
    );
    await _ctrl.saveGoal(g);
    _editing.value = false;
    Get.snackbar(
      '🎯 Goals Saved',
      'Your fitness targets have been updated.',
      backgroundColor: AppColors.card,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final editing = _editing.value;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar with back button ─────────────────────────────────
            SliverAppBar(
              title: const Text('My Goals'),
              pinned: true,
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                onPressed: Get.back,
              ),
              actions: [
                TextButton(
                  onPressed: editing ? _save : () => _editing.value = true,
                  child: Text(
                    editing ? 'Save' : 'Edit',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Daily targets ──────────────────────────────────────
                  _sectionTitle('Daily Targets'),
                  const SizedBox(height: 12),
                  _GoalRow(
                    icon: Icons.directions_walk,
                    color: AppColors.steps,
                    label: 'Steps Goal',
                    ctrl: _stepsCtrl,
                    unit: 'steps',
                    editing: editing,
                    current: _ctrl.todaySteps,
                    goal: _ctrl.goal.value.dailySteps,
                  ),
                  const SizedBox(height: 12),
                  _GoalRow(
                    icon: Icons.local_fire_department_outlined,
                    color: AppColors.calories,
                    label: 'Calories Goal',
                    ctrl: _calCtrl,
                    unit: 'kcal',
                    editing: editing,
                    current: _ctrl.todayCalories.toInt(),
                    goal: _ctrl.goal.value.dailyCalories.toInt(),
                  ),
                  const SizedBox(height: 12),
                  _GoalRow(
                    icon: Icons.timer_outlined,
                    color: AppColors.duration,
                    label: 'Workout Duration',
                    ctrl: _minCtrl,
                    unit: 'min',
                    editing: editing,
                    current: _ctrl.todayMinutes,
                    goal: _ctrl.goal.value.dailyMinutes,
                  ),
                  const SizedBox(height: 28),

                  // ── Weekly targets ─────────────────────────────────────
                  _sectionTitle('Weekly Targets'),
                  const SizedBox(height: 12),
                  _GoalRow(
                    icon: Icons.fitness_center,
                    color: AppColors.workouts,
                    label: 'Workouts per Week',
                    ctrl: _wkCtrl,
                    unit: 'sessions',
                    editing: editing,
                    current: _ctrl.weekWorkouts,
                    goal: _ctrl.goal.value.weeklyWorkouts,
                  ),
                  const SizedBox(height: 32),

                  // ── Weekly summary ─────────────────────────────────────
                  _WeeklySummaryCard(ctrl: _ctrl),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800),
  );
}

// ─── Goal Row ─────────────────────────────────────────────────────────────────
class _GoalRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final TextEditingController ctrl;
  final String unit;
  final bool editing;
  final int current;
  final int goal;

  const _GoalRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.ctrl,
    required this.unit,
    required this.editing,
    required this.current,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (editing)
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      filled: true,
                      fillColor: color.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                      suffix: Text(
                        unit,
                        style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 9),
                      ),
                    ),
                  ),
                )
              else
                Text(
                  '${ctrl.text} $unit',
                  style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.13),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today: $current $unit',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              Text(
                '${(progress * 100).toInt()}% complete',
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Weekly Summary Card ──────────────────────────────────────────────────────
class _WeeklySummaryCard extends StatelessWidget {
  final AppController ctrl;
  const _WeeklySummaryCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.14),
            AppColors.primaryDark.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                "This Week's Summary",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _row('Total Steps', '${ctrl.weekSteps}', AppColors.steps),
          const SizedBox(height: 10),
          _row('Total Calories', '${ctrl.weekCalories.toInt()} kcal', AppColors.calories),
          const SizedBox(height: 10),
          _row('Total Duration', '${ctrl.weekMinutes} min', AppColors.duration),
          const SizedBox(height: 10),
          _row(
            'Workout Days',
            '${ctrl.weekWorkouts} / ${ctrl.goal.value.weeklyWorkouts}',
            AppColors.workouts,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      Text(
        value,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
