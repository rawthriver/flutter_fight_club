import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme:
            GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const maxLives = 5;

  int myLives = maxLives;
  int enemyLives = maxLives;

  BodyPart? _defendingBodyPart;
  BodyPart? _attackingBodyPart;

  BodyPart _whatEnemyDefends = BodyPart.random();
  BodyPart _whatEnemyAttacks = BodyPart.random();

  bool _readyToFight = false;
  bool _gameOver = true;
  String _fightingResult = 'Ready to go';

//EdgeInsets.only(left: 16, top: 30, right: 16, bottom: 30),

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
            Expanded(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 30, right: 16, bottom: 30),
                  child: ColoredBox(
                    color: FightClubColors.backgroundBlock,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            _fightingResult,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: const TextStyle(height: 2, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ControlsWidget(
              defendingBodyPart: _defendingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              attackingBodyPart: _attackingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            GoButton(
              text: _gameOver ? 'Start new game' : 'Go',
              color: _readyToFight || _gameOver
                  ? FightClubColors.blackButton
                  : FightClubColors.greyButton,
              action: _startFighting,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _setReadyState() {
    _readyToFight = _defendingBodyPart != null && _attackingBodyPart != null;
  }

  void _selectDefendingBodyPart(BodyPart value) {
    if (_gameOver) return;
    setState(() {
      _defendingBodyPart = value;
      _setReadyState();
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    if (_gameOver) return;
    setState(() {
      _attackingBodyPart = value;
      _setReadyState();
    });
  }

  void _calculateFightingResult() {
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
    _gameOver = myLives < 1 || enemyLives < 1;
    if (_gameOver) {
      _fightingResult =
          enemyLives < 1 ? (myLives < 1 ? 'Draw' : 'You won') : 'You lost';
    } else {
      _fightingResult = results.join('\n');
    }
  }

  void _startFighting() {
    if (_gameOver) {
      setState(() {
        myLives = maxLives;
        enemyLives = maxLives;
        _gameOver = false;
        _fightingResult = '';
      });
      return;
    }
    if (!_readyToFight) return;
    setState(() {
      _calculateFightingResult();
      _whatEnemyDefends = BodyPart.random();
      _whatEnemyAttacks = BodyPart.random();
      _defendingBodyPart = null;
      _attackingBodyPart = null;
      _setReadyState();
    });
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: action,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                    color: FightClubColors.whiteText,
                    fontWeight: FontWeight.w900,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
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
                Text('Defend'.toUpperCase()),
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
                Text('Attack'.toUpperCase()),
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
            children: [
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: SizedBox(
                    height: 160,
                  ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: FightClubColors.backgroundBlock,
                  child: SizedBox(
                    height: 160,
                  ),
                ),
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
                    child: Center(child: Text('You')),
                  ),
                  Image.asset(
                    FightClubImages.youAvatar,
                    width: 92,
                    height: 92,
                  ),
                ],
              ),
              const ColoredBox(
                color: Colors.green,
                child: SizedBox(
                  width: 44,
                  height: 44,
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Center(child: Text('Enemy')),
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
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
          child: Center(child: Text(bodyPart.name.toUpperCase())),
        ),
      ),
    );
  }
}
