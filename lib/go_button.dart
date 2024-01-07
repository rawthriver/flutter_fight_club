import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';

class GoButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback action;

  const GoButton(
      {super.key,
      required this.text,
      required this.color,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        color: color,
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: FightClubColors.whiteText,
              fontWeight: FontWeight.w900,
              fontSize: 16),
        ),
      ),
    );
  }
}
