import 'package:flutter/material.dart';
import 'package:flutter_rps_game/game/enum.dart';
import 'package:flutter_rps_game/game/widget/input_card.dart';

class CpuInput extends StatelessWidget {
  final bool isDone;
  final InputType cpuInput;

  const CpuInput({required this.isDone, required this.cpuInput, super.key});

  Widget getCpuInput() {
    if (isDone) {
      return Image.asset(cpuInput.path);
    }
    return Container(
      height: 100,
      child: const Center(
        child: Text(
          "?",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox.shrink()),
        InputCard(
          child: getCpuInput(),
        ),
        Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
