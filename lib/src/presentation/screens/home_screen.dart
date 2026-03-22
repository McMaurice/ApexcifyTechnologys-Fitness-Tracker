import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: .end,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    AppHelpers.greeting(),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'FitTrack Dashboard',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 13),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM d').format(DateTime.now()),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CustomFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.card,
          onRefresh: controller.load,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                      children: [
                        StatCard(
                          label: 'Steps',
                          value: AppHelpers.bigNumberFormater(controller.todaySteps),
                          unit: 'steps',
                          goal: AppHelpers.bigNumberFormater(controller.goal.value.dailySteps),
                          progress: controller.stepsProgress,
                          color: AppColors.steps,
                          icon: Icons.directions_walk,
                        ),
                        StatCard(
                          label: 'Calories',
                          value: controller.todayCalories.toInt().toString(),
                          unit: 'kcal',
                          goal: '${controller.goal.value.dailyCalories.toInt()} kcal',
                          progress: controller.caloriesProgress,
                          color: AppColors.calories,
                          icon: Icons.local_fire_department_outlined,
                        ),
                        StatCard(
                          label: 'Duration',
                          value: controller.todayMinutes.toString(),
                          unit: 'min',
                          goal: '${controller.goal.value.dailyMinutes} min',
                          progress: controller.minutesProgress,
                          color: AppColors.duration,
                          icon: Icons.timer_outlined,
                        ),
                        StatCard(
                          label: 'Weekly',
                          value: controller.weekWorkouts.toString(),
                          unit: 'sessions',
                          goal: '${controller.goal.value.weeklyWorkouts} sessions',
                          progress: controller.workoutsProgress,
                          color: AppColors.workouts,
                          icon: Icons.fitness_center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    WeeklyCaloriesBar(
                      data: controller.weeklyCaloriesList,
                      goal: controller.goal.value.dailyCalories,
                    ),
                    const SizedBox(height: 14),
                    WeeklyStepsLine(
                      data: controller.weeklyStepsList,
                      goal: controller.goal.value.dailySteps,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Today's Activities",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (controller.todayActivities.isEmpty)
                      const EmptyActivites()
                    else
                      ...controller.todayActivities.map(
                        (a) => ActivityTile(
                          activity: a,
                          onDelete: () => controller.removeActivity(a.id!),
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
