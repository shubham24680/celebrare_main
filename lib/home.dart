// All dynamic methods are above the build method.
// All static method are below the build method.

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Colors
  Color white = Colors.white;
  Color grey = Colors.grey.shade300;

  // Name Data
  String text = "";
  List<String> fonts = ['Metal', 'Niramit', 'Saira Stencil One'];
  String initialFont = 'Metal';
  double fontSize = 30;
  double textLength = 0;

  // Formata Data
  bool bold = false;
  bool italic = false;
  bool underline = false;
  bool center = false;

  // Position Data
  Offset position = const Offset(0, 0);
  List<Offset> allPositions = [];
  int currentPosition = 0;

  // update text length for not exceed the boundary.
  _updateTextLength() {
    textLength = text.length * fontSize * 0.5;
  }

  // MARK: Set new position
  void _updatePosition(Offset newPosition) {
    setState(() {
      if (currentPosition < allPositions.length - 1) {
        allPositions.removeRange(currentPosition + 1, allPositions.length);
      }

      allPositions.add(newPosition);
      currentPosition = allPositions.length - 1;
    });
  }

  // back to previous position
  void undo() {
    if (currentPosition > 0) {
      setState(() {
        position = allPositions[--currentPosition];
      });
    }
  }

  // next positon
  void redo() {
    if (currentPosition < allPositions.length - 1) {
      setState(() {
        position = allPositions[++currentPosition];
      });
    }
  }

  // MARK: Build
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height - 244;
    final width = size.width;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Draggable area
          _top(width, height),
          const SizedBox(height: 10),
          // Font Size, Bold, Italic, Underline and Center.
          _middle(),
          // Font Family
          _bottom(),
          // Add text buttons
          _buildButton(width / 2, height / 2),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // MARK: App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset(
        'assets/images/celebrarecompany_logo.jpeg',
        height: 50,
      ),
      actions: [
        // undo
        IconButton(
          onPressed: undo,
          icon: const Icon(Icons.undo_outlined),
        ),

        // redo
        IconButton(
          onPressed: redo,
          icon: const Icon(Icons.redo_outlined),
        ),
      ],
    );
  }

  // MARK: Top
  GestureDetector _top(double width, double height) {
    return GestureDetector(
      // update every move.
      onPanUpdate: (details) {
        setState(() {
          position = Offset(
            (position.dx + details.delta.dx).clamp(0, width - textLength),
            (position.dy + details.delta.dy).clamp(0, height - 40),
          );
        });

        // print("updated ${allPositions.length}");
      },

      // mark every end position for redo and undo.
      onPanEnd: (details) => _updatePosition(position),
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: grey,
              ),
            ),
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Transform.translate(
                offset: Offset.zero,
                child: name(),
              ),
            )
          ],
        ),
      ),
    );
  }

  // The text is here and its style.
  Text name() {
    return Text(
      text,
      style: TextStyle(
        fontFamily: initialFont,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  // MARK: Middle
  Row _middle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Font Size
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // decrease the font by 1.
            IconButton(
              onPressed: () {
                if (fontSize > 1) {
                  setState(() {
                    fontSize--;
                    _updateTextLength();
                  });
                }
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              fontSize.toInt().toString(),
              style: const TextStyle(fontSize: 20),
            ),
            // Increase the font by 1.
            IconButton(
              onPressed: () {
                setState(() {
                  fontSize++;
                  _updateTextLength();
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        // Format
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Bold
            formatButton(
              Icons.format_bold_outlined,
              () {
                setState(() {
                  bold = !bold;
                });
              },
              bold,
            ),

            // Italic
            formatButton(
              Icons.format_italic_outlined,
              () {
                setState(() {
                  italic = !italic;
                });
              },
              italic,
            ),

            // Underline
            formatButton(
              Icons.format_underline_outlined,
              () {
                setState(() {
                  underline = !underline;
                });
              },
              underline,
            ),

            // Align center
            formatButton(
              Icons.format_align_center,
              () {
                setState(() {
                  center = !center;
                });
              },
              center,
            ),
          ],
        ),
      ],
    );
  }

  // Format button used for bold, italic, underline and center.
  Container formatButton(IconData icons, Function()? onPressed, bool check) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: check ? grey : white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icons),
      ),
    );
  }

  // MARK: Bottom
  Padding _bottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton<String>(
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        dropdownColor: white,
        value: initialFont,
        items: fonts.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            initialFont = value!;
          });
        },
      ),
    );
  }

  // MARK: Button
  ElevatedButton _buildButton(double dx, double dy) {
    return ElevatedButton(
      onPressed: () {
        if (text == "") {
          setState(() {
            text += "Shubham";
            _updateTextLength();
            position = Offset(dx - 50, dy);
            _updatePosition(position);
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: grey,
      ),
      child: const Text(
        "Add Text",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
