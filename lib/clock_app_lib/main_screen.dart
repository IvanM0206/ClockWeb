import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'analog_clock.dart';
import 'clock_class.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _score = 0;

  late DateTime _stopTime;

  bool _startButtonIsActive = true;

  bool _stopClock = true;

  String _textOfResultWidget = '';

  List<Widget> _listOfWidget = [];

  UniqueKey _clockKey = UniqueKey(); // Inicialmente tiene una UniqueKey

  ClockController clockController = ClockController();

  void getRandomTime() {
    DateTime todayDate = DateTime.now();
    DateTime res = mockDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            todayDate.hour, todayDate.minute),
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            todayDate.hour + 3, todayDate.minute));
    //DateTime res = DateTime.now();
    _stopTime = res;
  }

  void changeResult() {
    if (clockController.checkEqualityTime(_stopTime)) {
      _score++;
      clockController.textOfResultWidget =
          'You have successfully stopped the timer';
      clockController.colorOfResultWidget = Colors.green;
    } else {
      String timeMissed = DateFormat('HH:mm')
          .format(clockController.differenceInTime(_stopTime));
      clockController.textOfResultWidget =
          'You have not successfully stopped the timer. You missed by $timeMissed';
      clockController.colorOfResultWidget = Colors.red;
    }
  }

  void addTextWidget(bool addWidget) {
    if (addWidget) {
      setState(() {
        _listOfWidget.add(Expanded(
          child: Text(
            clockController.textOfResultWidget,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: clockController.colorOfResultWidget),
          ),
        ));
      });
    } else {
      if (_listOfWidget.isNotEmpty) {
        setState(() {
          _listOfWidget.removeLast();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRandomTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your score is $_score',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text('You have to stop it at ${DateFormat('HH:mm').format(_stopTime)}',
            style: Theme.of(context).textTheme.bodyLarge),
        ..._listOfWidget,
        AnalogClock(
          key: _clockKey,
          updateInterval: Duration(milliseconds: 100),
          // Actualiza cada 100 ms
          speedFactor: 200.0,
          // Velocidad normal
          clockStop: _stopClock,
          clockController: clockController,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 100.0, top: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: !_startButtonIsActive
                    ? () {
                        setState(() {
                          _startButtonIsActive = !_startButtonIsActive;
                          _stopClock = true;
                          _clockKey =
                              UniqueKey(); // Cambia la clave para forzar la reconstrucción
                          changeResult();
                          addTextWidget(_stopClock);
                        });
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.red[900]; // Color cuando está presionado
                      } else if (states.contains(WidgetState.hovered)) {
                        return Colors.red[500]; // Color cuando está en hover
                      } else if (states.contains(WidgetState.disabled)) {
                        return Colors.red; // Color cuando está deshabilitado
                      }
                      return Colors.red; // Color por defecto
                    },
                  ),
                  // Color del texto según el estado
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors
                            .white; // Color del texto cuando está en hover
                      } else if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.black; // Color del texto por defecto
                    },
                  ),
                ),
                child: Text('STOP'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: _startButtonIsActive
                    ? () {
                        setState(() {
                          _startButtonIsActive = !_startButtonIsActive;
                          _stopClock = false;
                          _clockKey =
                              UniqueKey(); // Cambia la clave para forzar la reconstrucción
                          _textOfResultWidget = '';
                          getRandomTime();
                          addTextWidget(_stopClock);
                        });
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors
                            .green[900]; // Color cuando está presionado
                      } else if (states.contains(WidgetState.hovered)) {
                        return Colors.green[500]; // Color cuando está en hover
                      } else if (states.contains(WidgetState.disabled)) {
                        return Colors.green; // Color cuando está deshabilitado
                      }
                      return Colors.green; // Color por defecto
                    },
                  ),
                  // Color del texto según el estado
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors
                            .white; // Color del texto cuando está en hover
                      } else if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.black; // Color del texto por defecto
                    },
                  ),
                ),
                child: Text('START'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
