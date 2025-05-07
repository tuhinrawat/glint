import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/budget.dart';

class BudgetService {
  final _storage = const FlutterSecureStorage();
  
  const BudgetService();

  Future<void> saveBudget(Budget budget) async {
    final jsonStr = jsonEncode(budget.toJson());
    await _storage.write(key: 'latest_budget', value: jsonStr);
  }

  Future<Budget?> getLatestBudget() async {
    final jsonStr = await _storage.read(key: 'latest_budget');
    if (jsonStr == null) return null;
    return Budget.fromJson(jsonDecode(jsonStr));
  }

  double calculatePerPerson(double totalBudget, int groupSize) {
    if (groupSize <= 0) return 0;
    return totalBudget / groupSize;
  }

  Map<String, double> generateDefaultContributions(double totalBudget, int groupSize) {
    final perPerson = calculatePerPerson(totalBudget, groupSize);
    return Map.fromEntries(
      List.generate(
        groupSize,
        (index) => MapEntry('User${index + 1}', perPerson),
      ),
    );
  }
} 