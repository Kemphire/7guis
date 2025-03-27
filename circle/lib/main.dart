import 'package:circle/stack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Circle Drawer",
      home: MyCanvas(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyCanvas extends StatefulWidget {
  const MyCanvas({super.key});

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  List<Circle> activeCircles = [];
  StackDs<List<Circle>> undoStack = StackDs<List<Circle>>();
  // implement a redo stack, just push to redo stack every time you pop from undoStack
  StackDs<List<Circle>> redoStack = StackDs<List<Circle>>();

  bool showUndo() => !undoStack.isEmpty;
  bool showRedo() => !redoStack.isEmpty;

  void updateStack() {
    var deepCopy = activeCircles.map((circle) => circle.copy()).toList();
    if (undoStack.isEmpty || !listEquals(undoStack.peek, deepCopy)) {
      undoStack.push(deepCopy);
    }
  }

  final canvasKey = GlobalKey();

  void _addCircles(
    TapDownDetails details,
    double screenWidth,
    double screenHeight,
  ) {
    // using our custom key to get the context of our canvas
    RenderBox box = canvasKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);

    setState(() {
      activeCircles.add(
        Circle(
          x: localPosition.dx / screenWidth,
          y: localPosition.dy / screenHeight,
          radius: 30,
          showDialog: false,
          color: Colors.grey,
        ),
      );
      updateStack();
    });
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfCanvas = widthOfScreen / 2;
    var heightOfCanvas = heightOfScreen / 2;
    return Scaffold(
      appBar: AppBar(title: Text("Draw Cricles")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        showUndo()
                            ? () {
                              setState(() {
                                var lastChange = undoStack.pop();
                                redoStack.push(
                                  lastChange
                                      .map((circle) => circle.copy())
                                      .toList(),
                                );

                                if (undoStack.isEmpty) {
                                  activeCircles = [];
                                } else {
                                  activeCircles =
                                      undoStack.peek
                                          .map((c) => c.copy())
                                          .toList();
                                }
                              });
                            }
                            : null,
                    child: Text("Undo"),
                  ),
                  ElevatedButton(
                    onPressed:
                        showRedo()
                            ? () {
                              setState(() {
                                var lastChange = redoStack.pop();
                                activeCircles =
                                    lastChange
                                        .map((circle) => circle.copy())
                                        .toList();
                                var currentState =
                                    activeCircles
                                        .map((circle) => circle.copy())
                                        .toList();
                                undoStack.push(currentState);
                              });
                            }
                            : null,
                    child: Text("Redo"),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTapDown:
                  (details) =>
                      _addCircles(details, widthOfCanvas, heightOfCanvas),
              child: Container(
                key: canvasKey,
                width: widthOfCanvas,
                height: heightOfCanvas,
                decoration: BoxDecoration(color: Colors.greenAccent),
                child: Stack(
                  children: [
                    ...activeCircles.map(
                      (circle) => GestureDetector(
                        onTap: () {
                          setState(() {
                            circle.color = Colors.blueAccent;
                          });
                          final snackbar = SnackBar(
                            content: StatefulBuilder(
                              builder:
                                  (context, localSetState) => Slider.adaptive(
                                    value: circle.radius,
                                    onChanged: (value) {
                                      setState(() {
                                        localSetState(() {
                                          circle.radius = value;
                                        });
                                      });
                                    },
                                    // onChangeEnd: (value) => updateStack(),
                                    min:
                                        widthOfScreen < heightOfScreen
                                            ? widthOfScreen / 50
                                            : heightOfScreen / 50,
                                    max: 150,
                                    autofocus: true,
                                  ),
                            ),
                            showCloseIcon: true,
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackbar).closed.then((_) {
                              setState(() {
                                circle.color = Colors.grey;
                                updateStack();
                              });
                            });
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              left: circle.x * widthOfCanvas - circle.radius,
                              top: circle.y * heightOfCanvas - circle.radius,
                              child: Container(
                                width: circle.radius * 2,
                                height: circle.radius * 2,
                                decoration: BoxDecoration(
                                  color: circle.color,
                                  border: Border.all(
                                    color: Colors.yellowAccent,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Circle {
  double x;
  double y;
  double radius;
  bool showDialog;
  Color color;

  Circle({
    required this.x,
    required this.y,
    required this.radius,
    required this.showDialog,
    required this.color,
  });

  Circle copy() =>
      Circle(x: x, y: y, radius: radius, showDialog: showDialog, color: color);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Circle &&
        other.x == x &&
        other.y == y &&
        other.radius == radius &&
        other.showDialog == showDialog &&
        other.color == color;
  }

  @override
  int get hashCode =>
      x.hashCode ^
      y.hashCode ^
      radius.hashCode ^
      showDialog.hashCode ^
      color.hashCode;
}
