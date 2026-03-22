import 'package:fitness_tracker_app/fitness_tracker_core.dart';

class CustomFAB extends StatefulWidget {
  const CustomFAB({super.key});

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _navigateAndClose(Widget screen) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    await Future.delayed(const Duration(milliseconds: 200));
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ScaleTransition(
          scale: _expandAnimation,
          child: _buildSpeedDialButton(
            icon: Icons.add_rounded,
            color: AppColors.duration,
            label: 'Log Activity',
            onTap: () => _navigateAndClose(const AddActivityScreen()),
          ),
        ),

        const SizedBox(height: 12),

        ScaleTransition(
          scale: _expandAnimation,
          child: _buildSpeedDialButton(
            icon: Icons.flag_rounded,
            color: AppColors.steps,
            label: 'My Goals',
            onTap: () => _navigateAndClose(const GoalsScreen()),
          ),
        ),
        const SizedBox(height: 12),

        ScaleTransition(
          scale: _expandAnimation,
          child: _buildSpeedDialButton(
            icon: Icons.history_rounded,
            color: AppColors.calories,
            label: 'History',
            onTap: () => _navigateAndClose(const HistoryScreen()),
          ),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 250),
            child: Icon(_isExpanded ? Icons.close : Icons.menu),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.all(color: color),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withValues(alpha: 0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
