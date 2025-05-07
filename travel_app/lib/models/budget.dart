class Budget {
  final double totalBudget;
  final int groupSize;
  final Map<String, double> contributions;

  Budget({
    required this.totalBudget,
    required this.groupSize,
    required this.contributions,
  });

  Map<String, dynamic> toJson() => {
        'totalBudget': totalBudget,
        'groupSize': groupSize,
        'contributions': contributions,
      };

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      totalBudget: (json['totalBudget'] as num).toDouble(),
      groupSize: json['groupSize'] as int,
      contributions: Map<String, double>.from(
        (json['contributions'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
    );
  }

  double get perPersonAmount => totalBudget / groupSize;

  bool get isBalanced {
    final totalContributions = contributions.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );
    return (totalContributions - totalBudget).abs() < 0.01;
  }
} 