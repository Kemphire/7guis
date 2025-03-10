import 'package:crud/logic/prefix_search.dart';
import 'package:crud/widets/list_tile.dart';
import 'package:crud/widets/text_field.dart';
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
  final List<List<String>> _posts = [
    ["Kartikey", "Shahi"],
    ["Kapil", "Shahi"],
    ["Ankit", "Pandey"],
  ];
  TextEditingController prefixController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  int? selectedIndex;

  List<String> postToBeDisplayed() {
    if (prefixController.text.isEmpty) {
      return _posts.map((element) => element.join(", ")).toList();
    }
    return topFiveMatchingNames(_posts, prefixController.text);
  }

  @override
  Widget build(BuildContext context) {
    var postToBeDisplayedList = postToBeDisplayed();
    return Scaffold(
      appBar: AppBar(),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
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
                        onchanged: (String value) {
                          setState(() {}); // Just triggers rebuild
                        },
                        onEditingComplete: () {},
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraint.maxWidth / 2,
                            height: (constraint.maxHeight * 2) / 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListView.builder(
                                itemCount: postToBeDisplayedList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Square(
                                    child: postToBeDisplayedList[index],
                                    selected: selectedIndex == index,
                                    onTap: () {
                                      setState(() {
                                        if (selectedIndex == index) {
                                          selectedIndex = null;
                                          return;
                                        }
                                        selectedIndex = index;
                                      });
                                    },
                                  );
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
                                  onchanged: (String value) {},
                                  onEditingComplete: () {},
                                ),
                                MyTextFieldWidget(
                                  controller: surnameController,
                                  nameOfField: "Surname: ",
                                  portionWidth: 1,
                                  onchanged: (String value) {},
                                  onEditingComplete: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: getMyButton("Create", onPressed: () {}),
                          ),
                          Expanded(
                            child: getMyButton(
                              "Update",
                              onPressed: selectedIndex == null ? null : () {},
                            ),
                          ),
                          Expanded(
                            child: getMyButton(
                              "Delete",
                              onPressed:
                                  selectedIndex == null
                                      ? null
                                      : () {
                                        setState(() {
                                          _posts.removeAt(selectedIndex!);
                                          selectedIndex = null;
                                        });
                                      },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding getMyButton(String child, {required Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(onPressed: onPressed, child: Text(child)),
    );
  }
}
