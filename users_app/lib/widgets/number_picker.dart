import 'package:flutter/material.dart';

import '../global/global.dart';

class NumberPicker extends StatefulWidget {
  const NumberPicker({super.key});

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // Match the width of the Row
        decoration: BoxDecoration(
          color: const Color(0xfff5f6fa), // Dark background color
          borderRadius: BorderRadius.circular(50.0), // Rounded corners
        ),
        width: MediaQuery.of(context).size.width * 0.70,
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() {
                  final newValue = currentIntValue - 1;
                  currentIntValue = newValue.clamp(1, 100);
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              Text('$currentIntValue'),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() {
                  final newValue = currentIntValue + 1;
                  currentIntValue = newValue.clamp(1, 100);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
