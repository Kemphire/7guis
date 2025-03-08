import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Crud(), debugShowCheckedModeBanner: false);
  }
}

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  final List<String> _posts = ["First", "Second", "Third"];
  TextEditingController prefixController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: LayoutBuilder(
        builder: (context, constraint) {
          return SizedBox(
            height: constraint.maxHeight,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextFieldWidget(
                      controller: prefixController,
                      nameOfField: "Prefix: ",
                      portionWidth: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: constraint.maxWidth / 2,
                          height: (constraint.maxHeight * 2) / 3,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListView.builder(
                              itemCount: _posts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Square(child: _posts[index]);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTextFieldWidget(
                                controller: nameController,
                                nameOfField: "Name: ",
                                portionWidth: 1,
                              ),
                              MyTextFieldWidget(
                                controller: surnameController,
                                nameOfField: "Surname: ",
                                portionWidth: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: getMyButton("Create")),
                        Expanded(child: getMyButton("Update")),
                        Expanded(child: getMyButton("Delete")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding getMyButton(String child) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(onPressed: () {}, child: Text(child)),
    );
  }
}

class MyTextFieldWidget extends StatelessWidget {
  const MyTextFieldWidget({
    super.key,
    required this.controller,
    required this.nameOfField,
    required this.portionWidth,
  });

  final TextEditingController controller;
  final String nameOfField;
  final double portionWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return getMyTextField(
            constraint,
            controller,
            nameOfField,
            portionWidth,
          );
        },
      ),
    );
  }
}

SizedBox getMyTextField(
  BoxConstraints constraint,
  TextEditingController controller,
  String nameOfField,
  double portionWidth,
) {
  return SizedBox(
    width: constraint.maxWidth / portionWidth,
    child: Row(
      children: [
        SizedBox(width: 75, child: Text(nameOfField)),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(border: OutlineInputBorder()),
            onChanged: (String value) {},
          ),
        ),
      ],
    ),
  );
}

class Square extends StatelessWidget {
  final String child;
  const Square({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(title: Text(child)),
    );
  }
}
