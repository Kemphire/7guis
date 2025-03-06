import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Converter());
  }
}

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  State<Converter> createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  TextEditingController conrollerCelecius = TextEditingController();
  TextEditingController controllerFar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature Converter"),
      ), // Add AppBar for visibility
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content
          children: [
            Row(
              children: [
                myTextFiedl(conrollerCelecius, "Celcius", () {
                  if (isNumeric(conrollerCelecius.text)) {
                    controllerFar.text = celciusToFar(
                      double.parse(conrollerCelecius.text),
                    ).toStringAsFixed(2);
                  }
                }),
                const SizedBox(width: 10),
                const Text("°C"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                myTextFiedl(controllerFar, "Fahrenheit", () {
                  if (isNumeric(controllerFar.text)) {
                    conrollerCelecius.text = farToCelcius(
                      double.parse(controllerFar.text),
                    ).toStringAsFixed(2);
                  }
                }),
                const SizedBox(width: 10),
                const Text("°F"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

double celciusToFar(double c) {
  return c * (9 / 5) + 32;
}

double farToCelcius(double f) {
  return (f - 32) * (5 / 9);
}

Expanded myTextFiedl(
  TextEditingController controller,
  String labelText,
  void Function() vFunc,
) {
  return Expanded(
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      onEditingComplete: () {
        vFunc();
      },
    ),
  );
}
