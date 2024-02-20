import 'package:flutter/material.dart';
import 'package:flutter_rps_game/game/enum.dart';
import 'package:flutter_rps_game/game/widget/input_card.dart';

class GameResult extends StatelessWidget {
  final bool isDone;
  final Result? result;

  const GameResult({required this.isDone, this.result, super.key});

  @override
  Widget build(BuildContext context) {
    if (isDone) {
      return Column(
        children: [
          Text(result!.displayString, style: const TextStyle(fontSize: 32)),
          SizedBox(height: 8,)
          TextButton(
            child: ,
          )
        ],
      );
    }

    return const Center(
      child: Text(
        '가위, 바위, 보 중 하나를 선택 해 주세요.',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
