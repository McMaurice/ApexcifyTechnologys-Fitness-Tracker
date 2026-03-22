import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Activity History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        final Map<String, List<dynamic>> grouped = {};
        for (final a in controller.allActivities) {
          final key = DateFormat('EEEE, MMMM d  yyyy').format(a.date);
          grouped.putIfAbsent(key, () => []).add(a);
        }
        final dateKeys = grouped.keys.toList();

        if (controller.allActivities.isEmpty) {
          return const EmptyHistory();
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.card,
          onRefresh: controller.load,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            itemCount: dateKeys.length,
            itemBuilder: (_, i) {
              final key = dateKeys[i];
              final items = grouped[key]!;
              final cal = items.fold<double>(0, (s, a) => s + (a.caloriesBurned as double));
              final min = items.fold<int>(0, (s, a) => s + (a.durationMinutes as int));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // ── Date header row ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          key,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      _badge('${cal.toInt()} kcal', AppColors.calories),
                      const SizedBox(width: 6),
                      _badge('$min min', AppColors.duration),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...items.map(
                    (a) =>
                        ActivityTile(activity: a, onDelete: () => controller.removeActivity(a.id!)),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
    ),
  );
}
