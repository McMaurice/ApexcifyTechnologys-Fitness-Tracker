import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class EmptyActivites extends StatelessWidget {
  const EmptyActivites({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardLight, width: 0.8),
      ),
      child: const Column(
        children: [
          Text('🏃', style: TextStyle(fontSize: 42)),
          SizedBox(height: 12),
          Text(
            'No activity logged today',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
