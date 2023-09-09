import 'package:bubble_head/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class TmpScreen extends StatefulWidget {
  const TmpScreen({Key? key}) : super(key: key);

  @override
  State<TmpScreen> createState() => _TmpScreenState();
}

class _TmpScreenState extends State<TmpScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    askPremissions();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello"),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    bool inactive = state == AppLifecycleState.inactive;
    bool paused = state == AppLifecycleState.paused;
    bool detached = state == AppLifecycleState.detached;

    if (inactive || detached) return;

    if (paused) {
      // startBubbleHead();
    } else {
      debugPrint("Close bubble");
    }
  }

  final Bubble _bubble = Bubble();

  Future<void> startBubbleHead() async {
    try {
      await _bubble.startBubbleHead(sendAppToBackground: false);
    } catch (exception) {
      debugPrint('Failed to call startBubbleHead ${exception.toString()}');
    }
  }

  Future<void> stopBubbleHead() async {
    try {
      await _bubble.stopBubbleHead();
    } on PlatformException {
      print('Failed to call stopBubbleHead');
    }
  }

  void askPremissions() async {
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }
  }
}
