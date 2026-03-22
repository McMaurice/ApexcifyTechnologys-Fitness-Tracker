import 'package:fitness_tracker_app/fitness_tracker_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppController());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const FitTrackApp());
}

class FitTrackApp extends GetView<AppController> {
  const FitTrackApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      title: 'FitTrack',
      home: const SplashScreen(),
    );
  }
}
