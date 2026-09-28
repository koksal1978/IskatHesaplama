/// Devir dağılımındaki bir grubu temsil eder.
class DevirGroup {
  final String groupName;
  final int personCount;
  final int roundsPerPerson;
  final int totalRounds;

  const DevirGroup({
    required this.groupName,
    required this.personCount,
    required this.roundsPerPerson,
    required this.totalRounds,
  });
}

/// Kişi sayısına göre devir dağılımının tamamını temsil eder.
class DevirDistribution {
  final int totalMonths;
  final int totalPeople;
  final List<DevirGroup> groups;
  final int grandTotalRounds;

  const DevirDistribution({
    required this.totalMonths,
    required this.totalPeople,
    required this.groups,
    required this.grandTotalRounds,
  });
}
