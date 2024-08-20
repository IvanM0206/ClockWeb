import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

ValueNotifier<DateTime> timeNotifier = ValueNotifier<DateTime>(DateTime(0));

final StopWatchTimer stopTimer = StopWatchTimer(
  mode: StopWatchMode.countUp,
  onChange: (value) {
    final elapsed = Duration(milliseconds: value);
    timeNotifier.value = DateTime(0).add(elapsed);
  }
);

class Clock extends StatefulWidget {

  final Function() onCall;

  const Clock({super.key, required this.onCall});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  final GlobalKey<AnalogClockState> _analogClockKey = GlobalKey();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("JASDJJAS");
  }

  @override
  void dispose() {
    widget.onCall();
    stopTimer.dispose();  // Asegúrate de liberar los recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: timeNotifier,
      builder: (context, value, child) {
        return AnalogClock(
          isKeepTime: false,
          key: _analogClockKey,
          dateTime: value,
        );
      }
    );
  }
}
