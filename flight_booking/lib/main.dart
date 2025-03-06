import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Booker());
  }
}

class Booker extends StatefulWidget {
  const Booker({super.key});

  @override
  State<Booker> createState() => _BookerState();
}

class _BookerState extends State<Booker> {
  DateTime? startDate;
  DateTime? returnDate;
  String? todayDate;
  TextEditingController startDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  String? menuItem = "ow";

  bool buttonDisabled = false;

  @override
  void initState() {
    super.initState();

    todayDate = DateTime.now().toString().split(" ")[0];
    startDate = DateTime.now();
    returnDate = DateTime.now();
    startDateController.text = todayDate!;
    returnDateController.text = todayDate!;
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2050, 8),
    );

    if (picked != null) {
      String formattedDate = picked.toString().split(" ")[0];
      if (controller == startDateController) {
        if (picked != startDate) {
          setState(() {
            startDate = picked;
            startDateController.text = formattedDate;
          });
        }
      }
      if (controller == returnDateController) {
        if (picked != returnDate) {
          setState(() {
            returnDate = picked;
            returnDateController.text = formattedDate;
          });
        }
      }
      validateDates();
    }
  }

  void validateDates() {
    setState(() {
      buttonDisabled =
          menuItem == "re" &&
          returnDate != null &&
          startDate != null &&
          returnDate!.isBefore(startDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    // startDateController.text = startDate.toString().split(" ")[0];
    // returnDateController.text = returnDate.toString().split(" ")[0];
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: widthScreen > 500 ? 0.6 : 0.8,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    value: menuItem,
                    items: [
                      DropdownMenuItem(
                        value: "ow",
                        child: Text("one-way flight"),
                      ),
                      DropdownMenuItem(
                        value: "re",
                        child: Text("return flight"),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        menuItem = value;
                        validateDates();
                      });
                    },
                  ),
                  TextField(
                    controller: startDateController,
                    enabled: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_view_month_outlined),
                        onPressed:
                            () => _selectDate(context, startDateController),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: returnDateController,
                    enabled: menuItem == "re",
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_view_month_outlined),
                        onPressed:
                            () => _selectDate(context, returnDateController),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          buttonDisabled
                              ? null
                              : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      menuItem == "ow"
                                          ? "You have booked a one-way flight on ${startDateController.text}"
                                          : "You have booked a return flight from ${startDateController.text} to ${returnDateController.text}",
                                    ),
                                    duration: Duration(milliseconds: 1000),
                                    showCloseIcon: true,
                                  ),
                                );
                              },
                      child: Text("Book"),
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

DateTime giveDateTime(List<String> date) {
  return DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
}
