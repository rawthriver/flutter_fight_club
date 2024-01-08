class FightResult {
  final String result;

  const FightResult._(this.result);

  static const won = FightResult._('won');
  static const lost = FightResult._('lost');
  static const draw = FightResult._('draw');

  static final List<FightResult> _values = [won, lost, draw];

  static FightResult fromString(String result) {
    return _values.firstWhere((e) => e.result == result);
  }

  static FightResult? calculate(int myLives, int enemyLives) {
    return enemyLives < 1
        ? (myLives < 1 ? draw : won)
        : (myLives < 1 ? lost : null);
  }

  @override
  String toString() {
    return 'FightResult: {$result}';
  }
}
