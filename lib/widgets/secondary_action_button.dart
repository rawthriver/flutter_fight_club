import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback action;

  const SecondaryActionButton(
      {super.key, required this.text, required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: FightClubColors.darkGreyText),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: FightClubColors.darkGreyText,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
