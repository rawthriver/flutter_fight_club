import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/widgets/fight_result_widget.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Text(
                'The\nFight\nClub'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  height: 1.333,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then(
                (sp) => sp.getString('last_fight_result'),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    const Text('Last fight result'),
                    const SizedBox(height: 12),
                    FightResultWidget(
                      result: FightResult.fromString(snapshot.data!),
                    )
                  ],
                );
              },
            ),
            const Expanded(child: SizedBox()),
            SecondaryActionButton(
              text: 'Statistics',
              action: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const StatisticsPage()),
              ),
            ),
            const SizedBox(height: 12),
            ActionButton(
              text: 'Start'.toUpperCase(),
              color: FightClubColors.blackButton,
              action: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FightPage()),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
