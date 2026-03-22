import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  late final AppController _controller;

  String _type = AppStrings.exerciseTypes.first;
  String _intensity = 'Medium';
  DateTime _date = DateTime.now();

  final _durationController = TextEditingController();
  final _stepsController = TextEditingController();
  final _notesController = TextEditingController();

  double _estimatedCalories = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AppController>();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  void _recalc() {
    final dur = int.tryParse(_durationController.text) ?? 0;
    setState(() {
      _estimatedCalories = AppStrings.estimateCalories(_type, dur, _intensity);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.black,
            surface: AppColors.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final a = Activity(
      exerciseType: _type,
      durationMinutes: int.parse(_durationController.text),
      caloriesBurned: _estimatedCalories,
      steps: int.tryParse(_stepsController.text) ?? 0,
      intensity: _intensity,
      notes: _notesController.text.trim(),
      date: _date,
    );

    await _controller.addActivity(a);

    Get.back();
    Get.snackbar(
      '✅ Activity Logged',
      '${a.exerciseType} added successfully.',
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
      appBar: AppBar(
        title: const Text('Log Activity'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
          onPressed: Get.back,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _label('Exercise Type'),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppStrings.exerciseTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final t = AppStrings.exerciseTypes[i];
                  final sel = t == _type;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _type = t);
                      _recalc();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary.withValues(alpha: 0.13) : AppColors.card,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.cardLight,
                          width: sel ? 1.8 : 0.8,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.exerciseEmoji[t] ?? '🏅',
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            t,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: sel ? AppColors.primary : AppColors.textSecondary,
                              fontSize: 9.5,
                              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),

            _label('Intensity'),
            const SizedBox(height: 10),
            Row(
              children: AppStrings.intensities.map((lvl) {
                final sel = lvl == _intensity;
                final c = lvl == 'High'
                    ? AppColors.calories
                    : lvl == 'Medium'
                    ? AppColors.workouts
                    : AppColors.primary;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _intensity = lvl);
                      _recalc();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: sel ? c.withValues(alpha: 0.13) : AppColors.card,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: sel ? c : AppColors.cardLight,
                          width: sel ? 1.8 : 0.8,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            lvl == 'Low'
                                ? '🟢'
                                : lvl == 'Medium'
                                ? '🟡'
                                : '🔴',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lvl,
                            style: TextStyle(
                              color: sel ? c : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            _label('Duration (minutes)'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: _dec('e.g. 30', Icons.timer_outlined),
              onChanged: (_) => _recalc(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Duration is required';
                final n = int.tryParse(v);
                if (n == null || n <= 0) return 'Enter a valid number of minutes';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Steps ─────────────────────────────────────────────────────
            _label('Steps  (optional)'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _stepsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: _dec('e.g. 5000', Icons.directions_walk),
            ),
            const SizedBox(height: 16),


            _label('Date'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardLight),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(_date),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),


            _label('Notes  (optional)'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: _dec('How did it go?', Icons.edit_note_outlined),
            ),
            const SizedBox(height: 24),


            if (_estimatedCalories > 0)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.calories.withValues(alpha: 0.14),
                      AppColors.calories.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.calories.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: AppColors.calories, size: 30),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Calories Burned',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        Text(
                          '${_estimatedCalories.toInt()} kcal',
                          style: const TextStyle(
                            color: AppColors.calories,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                    )
                  : const Text('Save Activity'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.7,
    ),
  );

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, color: AppColors.textMuted, size: 19),
  );
}
