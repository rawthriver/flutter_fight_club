import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}

class _MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Text('Test'),
      ),
    );
  }
}
