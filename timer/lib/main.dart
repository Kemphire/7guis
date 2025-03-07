import 'dart:async' as async_lib;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Timer",
      home: Timer(),
    );
  }
}

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  late int _elapsedTime = 0;
  late async_lib.Timer _timer;
  late Duration duration;
  late double maxDurationSlider;
  late double minDurationSlider;
  double sliderValue = 10.0;

  @override
  void initState() {
    super.initState();
    maxDurationSlider = 20.0;
    minDurationSlider = 0;
    sliderValue = maxDurationSlider / 2;
    duration = Duration(seconds: (maxDurationSlider / 2).toInt());

    _startTimer();
  }

  void _startTimer() {
    _timer = async_lib.Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _elapsedTime += 10;

        if (_elapsedTime == duration.inMilliseconds) {
          _timer.cancel();
          return;
        }

        if (_elapsedTime >= duration.inMilliseconds) {
          _timer.cancel();
        }
      });
    });
  }

  void _resetTime() {
    _timer.cancel();
    setState(() {
      _elapsedTime = 0;
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87, width: 5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Text("Elapsed Time: "),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _elapsedTime / duration.inMilliseconds,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.cyan,
                          ),
                          backgroundColor: Colors.grey,
                          minHeight: 20,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("${(_elapsedTime / 1000).toStringAsFixed(1)}s"),
                  Row(
                    children: [
                      Text("Duration: "),
                      Expanded(
                        child: SfSlider(
                          value: sliderValue,
                          min: minDurationSlider + 1,
                          max: maxDurationSlider,
                          onChanged: (dynamic value) {
                            setState(() {
                              sliderValue = value;
                              duration = Duration(seconds: value.toInt());
                              if (!_timer.isActive &&
                                  _elapsedTime < value * 1000) {
                                _startTimer();
                              }
                            });
                          },
                          enableTooltip: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _resetTime(),
                      child: Text("Reset"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
