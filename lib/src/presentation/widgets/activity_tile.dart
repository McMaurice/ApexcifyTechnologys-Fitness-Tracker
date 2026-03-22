import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onDelete;

  const ActivityTile({super.key, required this.activity, required this.onDelete});

  Color _intensityColor(String i) {
    switch (i) {
      case 'High':
        return AppColors.calories;
      case 'Medium':
        return AppColors.workouts;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final emoji = AppStrings.exerciseEmoji[activity.exerciseType] ?? '🏅';
    final iColor = _intensityColor(activity.intensity);
    final time = DateFormat('h:mm a').format(activity.date);

    return Dismissible(
      key: Key(activity.id!),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.card,
            title: const Text('Delete Activity', style: TextStyle(color: AppColors.textPrimary)),
            content: const Text(
              'Remove this activity?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.calories),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.calories.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.calories),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardLight, width: 0.8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          title: Text(
            activity.exerciseType,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Wrap(
                spacing: 10,
                children: [
                  _chip(Icons.timer_outlined, '${activity.durationMinutes} min', AppColors.duration),
                  _chip(
                    Icons.local_fire_department_outlined,
                    '${activity.caloriesBurned.toInt()} kcal',
                    AppColors.calories,
                  ),
                  if (activity.steps > 0)
                    _chip(Icons.directions_walk, '${activity.steps} steps', AppColors.steps),
                ],
              ),
              if (activity.notes.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  activity.notes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ],
          ),
          isThreeLine: activity.notes.isNotEmpty,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: iColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  activity.intensity,
                  style: TextStyle(color: iColor, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 11, color: color),
      const SizedBox(width: 3),
      Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ],
  );
}
