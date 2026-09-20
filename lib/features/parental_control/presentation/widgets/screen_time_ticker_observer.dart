import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/screen_time_controller.dart';

/// Keeps [screenTimeControllerProvider] alive for the app's lifetime and
/// tells it when the app leaves/re-enters the foreground, so screen time
/// (US09) isn't credited while the app is backgrounded.
class ScreenTimeTickerObserver extends ConsumerStatefulWidget {
  const ScreenTimeTickerObserver({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ScreenTimeTickerObserver> createState() => _ScreenTimeTickerObserverState();
}

class _ScreenTimeTickerObserverState extends ConsumerState<ScreenTimeTickerObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref
        .read(screenTimeControllerProvider.notifier)
        .setForeground(state == AppLifecycleState.resumed);
  }

  @override
  Widget build(BuildContext context) {
    // Watching (not reading) keeps the controller alive for as long as
    // this widget is in the tree — i.e. the whole app.
    ref.watch(screenTimeControllerProvider);
    return widget.child;
  }
}
