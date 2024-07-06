import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard with Occurrences'),
        ),
        body: KeyboardWidget(),
      ),
    );
  }
}

class KeyboardWidget extends StatefulWidget {
  @override
  _KeyboardWidgetState createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends State<KeyboardWidget> {
  // Initial occurrences of letters
  Map<String, int> letterOccurrences = {
    'A': 1,
    'C': 1,
    'E': 2,
    'L': 1,
    'O': 1,
    'R': 1,
    'S': 2,
  };

  @override
  Widget build(BuildContext context) {
    // Sort letters alphabetically
    final sortedLetters = letterOccurrences.keys.toList()..sort();

    return Column(
      children: [
        const Text(
          'Drop letters here:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Center(
                child: Text(
                  'Letters dropped: ${letterOccurrences.values}',
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
            onWillAcceptWithDetails: (data) => true,
            onAcceptWithDetails: (data) {
              _decrementOccurrences(data.data);
            },
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: sortedLetters.map((letter) {
              final occurrence = letterOccurrences[letter];

              return Draggable(
                data: letter,
                feedback: _buildLetterWidget(letter, occurrence),
                childWhenDragging: _buildLetterWidget(letter, occurrence),
                onDraggableCanceled: (velocity, offset) {
                  // Handle if dragged item is dropped outside the target
                },
                child: _buildLetterWidget(letter, occurrence),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Widget to display a draggable letter with occurrence count
  Widget _buildLetterWidget(String letter, int? occurrence) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.red,
              ),
            ),
          ),
          if (occurrence != null && occurrence > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(-5, 0),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    occurrence.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Method to decrement letter occurrence count
  void _decrementOccurrences(String letter) {
    setState(() {
      if (letterOccurrences[letter]! > 0) {
        letterOccurrences[letter] = letterOccurrences[letter]! - 1;
      }
    });
  }
}
