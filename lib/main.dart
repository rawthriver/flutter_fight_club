import 'package:flutter/material.dart';
//import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/pages/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const FightClub());

class FightClub extends StatelessWidget {
  const FightClub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MainPage(),
    );
  }
}
