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
      height: 160,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Center(
                      child: Text(
                        'You',
                        style: TextStyle(
                          fontSize: 14,
                          color: FightClubColors.darkGreyText,
                        ),
                      ),
                    ),
                  ),
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
                decoration: const ShapeDecoration(
                  color: FightClubColors.blueButton,
                  shape: StadiumBorder(),
                ),
                child: Text(
                  result.result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: FightClubColors.whiteText,
                    fontSize: 16,
                  ),
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Center(
                      child: Text(
                        'Enemy',
                        style: TextStyle(
                          fontSize: 14,
                          color: FightClubColors.darkGreyText,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    width: 92,
                    height: 92,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
