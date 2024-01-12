import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FightResultWidget extends StatelessWidget {
  final FightResult result;

  const FightResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ColoredBox(color: Colors.white),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, FightClubColors.backgroundBlock],
                    ),
                  ),
                  child: SizedBox(),
                ),
              ),
              Expanded(
                child: ColoredBox(color: FightClubColors.backgroundBlock),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1,
                      color: FightClubColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    FightClubImages.youAvatar,
                    width: 92,
                    height: 92,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                height: 44,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: ShapeDecoration(
                  color: _getResultColor(result),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  result.result,
                  style: const TextStyle(
                    color: FightClubColors.whiteText,
                    fontSize: 16,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enemy',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1,
                      color: FightClubColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    width: 92,
                    height: 92,
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Color _getResultColor(FightResult result) {
    return switch (result) {
      FightResult.won => FightClubColors.greenButton,
      FightResult.draw => FightClubColors.blueButton,
      FightResult.lost => FightClubColors.redButton,
      FightResult() => FightClubColors.blueButton,
    };
  }
}
