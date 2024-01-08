import 'package:flutter/material.dart';
import 'package:flutter_fight_club/pages/main_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';

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
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: const Text(
                'Statistics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  height: 1.6,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            FutureBuilder<String?>(
                future: Future.value('stats'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  }
                  return Center(
                    child: Text(snapshot.data!),
                  );
                }),
            const Expanded(child: SizedBox()),
            SecondaryActionButton(
              text: 'Back',
              action: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MainPage()),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
