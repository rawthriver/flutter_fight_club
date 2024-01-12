import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/main_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({super.key});

  @override
  State<FightPage> createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  int myLives = maxLives;
  int enemyLives = maxLives;

  BodyPart? _defendingBodyPart;
  BodyPart? _attackingBodyPart;

  BodyPart _whatEnemyDefends = BodyPart.random();
  BodyPart _whatEnemyAttacks = BodyPart.random();

  bool _readyToFight = false;
  FightResult? _fightResult;
  String _fightResultString = 'Ready to fight!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              myLivesCount: myLives,
              enemyLivesCount: enemyLives,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ColoredBox(
                  color: FightClubColors.backgroundBlock,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        _fightResultString,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                          height: 2,
                          fontSize: 10,
                          color: FightClubColors.darkGreyText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ControlsWidget(
              defendingBodyPart: _defendingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              attackingBodyPart: _attackingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            ActionButton(
              text: _fightResult != null ? 'Back' : 'Go',
              color: _readyToFight || _fightResult != null
                  ? FightClubColors.blackButton
                  : FightClubColors.greyButton,
              action: _startFightClicked,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _updateReadyToFightState() {
    _readyToFight = _defendingBodyPart != null && _attackingBodyPart != null;
  }

  void _selectDefendingBodyPart(BodyPart value) {
    if (_fightResult != null) return;
    setState(() {
      _defendingBodyPart = value;
      _updateReadyToFightState();
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    if (_fightResult != null) return;
    setState(() {
      _attackingBodyPart = value;
      _updateReadyToFightState();
    });
  }

  String _calculateFightResult() {
    var results = [];
    if (_attackingBodyPart != _whatEnemyDefends) {
      results.add('You hit enemy’s ${_attackingBodyPart?.name.toLowerCase()}.');
      enemyLives--;
    } else {
      results.add('Your attack was blocked.');
    }
    if (_defendingBodyPart != _whatEnemyAttacks) {
      results.add('Enemy hit your ${_defendingBodyPart?.name.toLowerCase()}.');
      myLives--;
    } else {
      results.add('Enemy’s attack was blocked.');
    }
    _fightResult = FightResult.calculate(myLives, enemyLives);
    if (_fightResult == null) return results.join('\n');
    return enemyLives < 1 ? (myLives < 1 ? 'Draw' : 'You won') : 'You lost';
  }

  void _startFightClicked() {
    if (_fightResult != null) {
      _fightResult = null;
      Navigator.of(context)
          .pop(); //to update state have to use .push(MaterialPageRoute(builder: (context) => const MainPage()));
      return;
    }
    if (!_readyToFight) return;
    setState(() {
      _fightResultString = _calculateFightResult();
      _whatEnemyDefends = BodyPart.random();
      _whatEnemyAttacks = BodyPart.random();
      _defendingBodyPart = null;
      _attackingBodyPart = null;
      _updateReadyToFightState();
    });
    if (_fightResult != null) {
      SharedPreferences.getInstance().then((sp) {
        sp.setString('last_fight_result', _fightResult!.result);
        var statKey = 'stats_${_fightResult!.result}';
        int currentValue = sp.getInt(statKey) ?? 0;
        sp.setInt(statKey, ++currentValue);
      });
    }
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;

  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget({
    super.key,
    this.defendingBodyPart,
    required this.selectDefendingBodyPart,
    this.attackingBodyPart,
    required this.selectAttackingBodyPart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Defend'.toUpperCase(),
                  style: const TextStyle(
                    color: FightClubColors.darkGreyText,
                  ),
                ),
                const SizedBox(height: 13),
                BodyPartButton(
                  bodyPart: BodyPart.head,
                  selected: defendingBodyPart == BodyPart.head,
                  bodyPartSetter: selectDefendingBodyPart,
                ),
                const SizedBox(height: 14),
                BodyPartButton(
                  bodyPart: BodyPart.torso,
                  selected: defendingBodyPart == BodyPart.torso,
                  bodyPartSetter: selectDefendingBodyPart,
                ),
                const SizedBox(height: 14),
                BodyPartButton(
                  bodyPart: BodyPart.legs,
                  selected: defendingBodyPart == BodyPart.legs,
                  bodyPartSetter: selectDefendingBodyPart,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Attack'.toUpperCase(),
                  style: const TextStyle(
                    color: FightClubColors.darkGreyText,
                  ),
                ),
                const SizedBox(height: 13),
                BodyPartButton(
                  bodyPart: BodyPart.head,
                  selected: attackingBodyPart == BodyPart.head,
                  bodyPartSetter: selectAttackingBodyPart,
                ),
                const SizedBox(height: 14),
                BodyPartButton(
                  bodyPart: BodyPart.torso,
                  selected: attackingBodyPart == BodyPart.torso,
                  bodyPartSetter: selectAttackingBodyPart,
                ),
                const SizedBox(height: 14),
                BodyPartButton(
                  bodyPart: BodyPart.legs,
                  selected: attackingBodyPart == BodyPart.legs,
                  bodyPartSetter: selectAttackingBodyPart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int myLivesCount;
  final int enemyLivesCount;

  const FightersInfo({
    super.key,
    required this.maxLivesCount,
    required this.myLivesCount,
    required this.enemyLivesCount,
  });

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
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: myLivesCount,
              ),
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
              const SizedBox(
                width: 44,
                height: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FightClubColors.blueButton,
                  ),
                  child: Center(
                    child: Text(
                      'vs',
                      style: TextStyle(
                        color: FightClubColors.whiteText,
                        fontSize: 16,
                      ),
                    ),
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
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: enemyLivesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget(
      {super.key,
      required this.overallLivesCount,
      required this.currentLivesCount})
      : assert(overallLivesCount > 0),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (i) {
        Widget w = Image.asset(
          i < currentLivesCount
              ? FightClubIcons.heartFull
              : FightClubIcons.heartEmpty,
          width: 18,
          height: 18,
        );
        if (i > 0) {
          w = Padding(padding: const EdgeInsets.only(bottom: 4), child: w);
        }
        return w;
      }).reversed.toList(),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._('head');
  static const torso = BodyPart._('torso');
  static const legs = BodyPart._('legs');

  static final List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }

  @override
  String toString() {
    return 'BodyPart: name $name';
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    super.key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: FightClubColors.darkGreyText,
              style: selected ? BorderStyle.none : BorderStyle.solid,
              width: 2,
            ),
            color: selected ? FightClubColors.blueButton : null,
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                color: selected
                    ? FightClubColors.whiteText
                    : FightClubColors.darkGreyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
