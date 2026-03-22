import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class WeeklyStepsLine extends StatelessWidget {
  final List<int> data;
  final int goal;

  const WeeklyStepsLine({super.key, required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final todayI = DateTime.now().weekday - 1;
    final maxY =
        ([...data.map((e) => e.toDouble()), goal.toDouble()]).reduce((a, b) => a > b ? a : b) * 1.25;

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
              const Icon(Icons.directions_walk, color: AppColors.steps, size: 25),
              const SizedBox(width: 7),
              const Text(
                'Steps This Week',
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
                  color: AppColors.steps.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Goal ${AppHelpers.bigNumberFormater(goal)}/day',
                  style: const TextStyle(
                    color: AppColors.steps,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                minX: 0, // ← pin x range exactly to 0–6
                maxX: 6,
                minY: 0,
                maxY: maxY > 0 ? maxY : (goal * 1.5).toDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 3,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.cardLight.withValues(alpha: 0.6), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: goal.toDouble(),
                      color: AppColors.steps.withValues(alpha: 0.35),
                      strokeWidth: 1.5,
                      dashArray: [5, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 4, bottom: 4),
                        style: const TextStyle(color: AppColors.steps, fontSize: 9),
                        labelResolver: (_) => 'Goal',
                      ),
                    ),
                  ],
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // ← one label per integer step (fixes doubling)
                      getTitlesWidget: (x, _) {
                        final i = x.toInt();
                        if (i < 0 || i > 6) return const SizedBox.shrink();
                        final sel = i == todayI;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            days[i],
                            style: TextStyle(
                              color: sel ? AppColors.steps : AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(7, (i) => FlSpot(i.toDouble(), data[i].toDouble())),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.steps,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, i) => FlDotCirclePainter(
                        radius: i == todayI ? 5 : 3,
                        color: AppColors.steps,
                        strokeWidth: 2,
                        strokeColor: AppColors.card,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.steps.withValues(alpha: 0.3),
                          AppColors.steps.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
