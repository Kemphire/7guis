import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CounterScreen());
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final ValueNotifier<int> counter = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: counter,
                      builder: (context, value, child) {
                        return Text("$value");
                      },
                    ),
                    VerticalDivider(
                      color: Colors.black54,
                      thickness: 2,
                      width: 20,
                    ),
                    FilledButton.tonal(
                      onPressed: () => counter.value++,
                      child: const Icon(Icons.plus_one_sharp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
