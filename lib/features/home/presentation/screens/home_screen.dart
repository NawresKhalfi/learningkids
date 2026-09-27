import 'package:flutter/widgets.dart';

import '../../../dashboard/presentation/screens/dashboard_screen.dart';

/// The learner lands directly on the dashboard after signing in.
///
/// This route is kept as a distinct screen for backward-compatible routing,
/// while the dashboard provides the actual home experience.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const DashboardScreen();
}
