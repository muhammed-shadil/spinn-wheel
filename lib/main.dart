import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fortune Wheel Example',
      debugShowCheckedModeBanner: false,
      home: WheelPage(),
    );
  }
}

class WheelPage extends StatefulWidget {
  const WheelPage({super.key});

  @override
  ExamplePageState createState() => ExamplePageState();
}

class ExamplePageState extends State<WheelPage> {
  int selected = 0;

  final ConfettiController _controllerCenterRight =
      ConfettiController(duration: const Duration(seconds: 5));
  final TextEditingController textController = TextEditingController();
  final List<String> items = [];
  final List<Color> colors = [
    Color.fromARGB(255, 245, 129, 121),
    const Color.fromARGB(255, 110, 181, 240),
    const Color.fromARGB(255, 125, 244, 129),
    const Color.fromARGB(255, 235, 193, 130),
    const Color.fromARGB(255, 220, 122, 237),
    const Color.fromARGB(255, 236, 226, 135),
  ];

  @override
  void dispose() {
    // selected.close();
    textController.dispose();
    super.dispose();
  }

  void addItem() {
    setState(() {
      if (textController.text.isNotEmpty) {
        items.add(textController.text);
        textController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 254, 249),
      appBar: AppBar(
        title: const Text('LUCK Fortune Wheel'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Expanded(
                child: items.length > 1
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = Fortune.randomInt(0, items.length);

                            print("ssssssssssssssssss$selected");
                          });
                        },
                        child: FortuneWheel(
                          curve: Curves.elasticIn,
                          // hapticImpact: HapticImpact.heavy,
                          onAnimationEnd: () {
                            _controllerCenterRight.play();
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return Stack(
                                    children: [
                                      AlertDialog(
                                        title: const Center(
                                            child: Text("CONGRATULATIONS")),
                                        content: Text(items[selected]),
                                        actions: <Widget>[
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Text('ok'))
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: ConfettiWidget(
                                          confettiController:
                                              _controllerCenterRight,
                                          blastDirectionality:
                                              BlastDirectionality.explosive,
                                          emissionFrequency: 0.6,
                                          minimumSize: const Size(10, 10),
                                          maximumSize: const Size(50, 50),
                                          numberOfParticles: 1,
                                          gravity: 0.1,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          // selected: selected,
                          items: [
                            for (int i = 0; i < items.length; i++)
                              FortuneItem(
                                child: Text(items[i]),
                                style: FortuneItemStyle(
                                  borderColor: Colors.white, borderWidth: 4,
                                  textStyle: TextStyle(fontSize: 18),
                                  color: colors[i %
                                      colors.length], // Cycle through colors
                                ),
                              ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          items.isEmpty
                              ? 'Add at least two items to spin the wheel'
                              : 'Add one more item to spin the wheel',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: addItem,
                child: const Text('ADD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
