import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'clock_class.dart';

class AnalogClock extends StatefulWidget {
  final Duration updateInterval; // Intervalo de actualización del reloj
  final double
      speedFactor; // Factor de velocidad para ajustar la velocidad de cronometraje
  final bool clockStop;
  late ClockController clockController;

  AnalogClock({
    Key? key,
    this.updateInterval = const Duration(milliseconds: 100),
    this.speedFactor = 1.0,
    required this.clockController,
    required this.clockStop,
  }) : super(key: key);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  Timer? _timer;
  late DateTime _currentTime;
  late double _speedFactor;

  @override
  void initState() {
    super.initState();
    _speedFactor = widget.speedFactor;
    _currentTime = widget.clockController.clockTime;
    if (!widget.clockStop) {
      _startClock();
    }
  }

  void _startClock() {
    _timer = Timer.periodic(widget.updateInterval, (timer) {
      setState(() {
        _currentTime = _currentTime.add(Duration(
            milliseconds:
                (widget.updateInterval.inMilliseconds * _speedFactor).toInt()));
        widget.clockController.changeTime(_currentTime);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    print("final");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(400, 400),
      painter: AnalogClockPainter(_currentTime),
    );
  }
}

class AnalogClockPainter extends CustomPainter {
  final DateTime time;

  AnalogClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    // Dibujar la cara del reloj
    paint.strokeWidth =
        radius * 0.04; // Ajustar el grosor en proporción al radio
    canvas.drawCircle(center, radius - 10, paint);

    // Dibujar las marcas de los minutos y las horas
    _drawClockMarks(canvas, center, radius);

    // Dibujar los números del reloj
    _drawClockNumbers(canvas, center, radius * 0.9);

    // Dibujar la manecilla de la hora
    paint.strokeWidth = radius * 0.05;
    double hourAngle = (time.hour % 12 + time.minute / 60) * 30.0;
    canvas.drawLine(
      center,
      center +
          Offset(
            radius * 0.5 * cos((hourAngle - 90) * pi / 180),
            radius * 0.5 * sin((hourAngle - 90) * pi / 180),
          ),
      paint,
    );

    // Dibujar la manecilla de los minutos
    paint.strokeWidth = radius * 0.05;
    double minuteAngle = (time.minute + time.second / 60) * 6.0;
    canvas.drawLine(
      center,
      center +
          Offset(
            radius * 0.7 * cos((minuteAngle - 90) * pi / 180),
            radius * 0.7 * sin((minuteAngle - 90) * pi / 180),
          ),
      paint,
    );

    // Dibujar la manecilla de los segundos
    paint.color = Colors.red;
    paint.strokeWidth = radius * 0.03;
    double secondAngle = time.second * 6.0;
    canvas.drawLine(
      center,
      center +
          Offset(
            radius * 0.9 * cos((secondAngle - 90) * pi / 180),
            radius * 0.9 * sin((secondAngle - 90) * pi / 180),
          ),
      paint,
    );
  }

  void _drawClockNumbers(Canvas canvas, Offset center, double radius) {
    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final double padding =
        radius * 0.15; // Ajustar padding en proporción al radio
    final double textRadius = radius - padding;
    final double fontSize =
        radius * 0.12; // Ajustar tamaño de fuente en proporción al radio

    for (int i = 1; i <= 12; i++) {
      final double angle = (i * 30.0) * pi / 180.0; // 30 grados por cada hora
      final Offset position = Offset(
        center.dx + textRadius * cos(angle - pi / 2),
        center.dy + textRadius * sin(angle - pi / 2),
      );

      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawClockMarks(Canvas canvas, Offset center, double radius) {
    final Paint markPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      final double angle = (i * 6.0) * pi / 180.0; // 6 grados por cada minuto
      final double outerRadius = radius - 10;
      final double innerRadius = i % 5 == 0 ? radius * 0.85 : radius * 0.9;

      // Marcas de minutos
      canvas.drawLine(
        Offset(
          center.dx + outerRadius * cos(angle),
          center.dy + outerRadius * sin(angle),
        ),
        Offset(
          center.dx + innerRadius * cos(angle),
          center.dy + innerRadius * sin(angle),
        ),
        markPaint
          ..strokeWidth =
              i % 5 == 0 ? 3 : 1, // Marcas más gruesas para las horas
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
