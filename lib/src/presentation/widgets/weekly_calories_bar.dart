import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class WeeklyCaloriesBar extends StatelessWidget {
  final List<double> data;
  final double goal;

  const WeeklyCaloriesBar({super.key, required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final todayI = DateTime.now().weekday - 1;
    final maxY = ([...data, goal]).reduce((a, b) => a > b ? a : b) * 1.25;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardLight, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_outlined, color: AppColors.calories, size: 25),
              const SizedBox(width: 7),
              const Text(
                'Weekly Calories',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.calories.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Goal ${goal.toInt()} kcal/day',
                  style: const TextStyle(
                    color: AppColors.calories,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                maxY: maxY > 0 ? maxY : 600,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 3,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.cardLight.withValues(alpha: 0.6), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (x, _) {
                        final i = x.toInt();
                        final sel = i == todayI;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            days[i],
                            style: TextStyle(
                              color: sel ? AppColors.calories : AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Goal line
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: goal,
                      color: AppColors.calories.withValues(alpha: 0.35),
                      strokeWidth: 1.5,
                      dashArray: [5, 4],
                    ),
                  ],
                ),
                barGroups: List.generate(7, (i) {
                  final isToday = i == todayI;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i],
                        width: 18,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isToday
                              ? [AppColors.calories, AppColors.calories.withValues(alpha: 0.65)]
                              : [
                                  AppColors.calories.withValues(alpha: 0.28),
                                  AppColors.calories.withValues(alpha: 0.45),
                                ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
