import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/main_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _StatisticsPageContent();
  }
}

class _StatisticsPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.6,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            FutureBuilder<List<int>>(
                future: SharedPreferences.getInstance().then(
                  (sp) => [
                    sp.getInt('stats_${FightResult.won.result}') ?? 0,
                    sp.getInt('stats_${FightResult.draw.result}') ?? 0,
                    sp.getInt('stats_${FightResult.lost.result}') ?? 0,
                  ],
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  }
                  return Column(children: [
                    Text(
                      'Won: ${snapshot.data![0]}',
                      style: const TextStyle(fontSize: 16, height: 2.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Draw: ${snapshot.data![1]}',
                        style: const TextStyle(fontSize: 16, height: 2.5),
                      ),
                    ),
                    Text(
                      'Lost: ${snapshot.data![2]}',
                      style: const TextStyle(fontSize: 16, height: 2.5),
                    ),
                  ]);
                }),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SecondaryActionButton(
                text: 'Back',
                action: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
