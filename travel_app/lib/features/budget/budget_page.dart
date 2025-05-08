import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/budget.dart';
import '../../services/budget_service.dart';
import '../../core/widgets/nav_bar.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _groupSizeController = TextEditingController();
  final _service = const BudgetService();
  int _groupSize = 4;
  Map<String, double> _contributions = {};
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Budget? _budget;

  @override
  void initState() {
    super.initState();
    _loadBudget();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadBudget() async {
    setState(() => _isLoading = true);
    try {
      final budget = await _service.getLatestBudget();
      if (budget != null) {
        setState(() {
          _budget = budget;
          _budgetController.text = budget.totalBudget.toString();
          _groupSize = budget.groupSize;
          _contributions = budget.contributions;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading budget: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _groupSizeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final budget = Budget(
        totalBudget: double.parse(_budgetController.text),
        groupSize: _groupSize,
        contributions: _contributions,
      );
      await _service.saveBudget(budget);
      setState(() => _budget = budget);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving budget: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _initializeContributions() {
    final totalBudget = double.tryParse(_budgetController.text) ?? 0.0;
    final perPerson = totalBudget / _groupSize;
    _contributions = Map.fromIterable(
      List.generate(_groupSize, (i) => 'Person ${i + 1}'),
      value: (_) => perPerson,
    );
  }

  void _updateGroupSize(int newSize) {
    setState(() {
      _groupSize = newSize;
      _initializeContributions();
    });
  }

  void _updateContribution(String person, double amount) {
    setState(() {
      _contributions[person] = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Budget Allocation',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Total Budget Input
                  Card(
                    color: theme.colorScheme.surface.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Budget (₹)',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter total budget',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter total budget';
                              }
                              final budget = double.tryParse(value);
                              if (budget == null || budget < 5000 || budget > 100000) {
                                return 'Budget must be between ₹5,000 and ₹1,00,000';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _initializeContributions();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Group Size Dropdown
                  Card(
                    color: theme.colorScheme.surface.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Group Size',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: _groupSize,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: List.generate(
                              10,
                              (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1} ${index == 0 ? 'Person' : 'People'}'),
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _groupSize = value;
                                  _initializeContributions();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Pie Chart
                  Card(
                    color: theme.colorScheme.surface.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget Split',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: _contributions.entries.map((entry) {
                                  final index = _contributions.keys.toList().indexOf(entry.key);
                                  return PieChartSectionData(
                                    value: entry.value,
                                    title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
                                    color: getChartColor(index),
                                    radius: 100,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Contributions List
                  Card(
                    color: theme.colorScheme.surface.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contributions',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _contributions.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final item = _contributions.entries.elementAt(oldIndex);
                                _contributions.remove(item.key);
                                _contributions = Map.fromEntries([
                                  ..._contributions.entries.take(newIndex),
                                  item,
                                  ..._contributions.entries.skip(newIndex),
                                ]);
                              });
                            },
                            itemBuilder: (context, index) {
                              final entry = _contributions.entries.elementAt(index);
                              return ListTile(
                                key: ValueKey(entry.key),
                                title: Text(entry.key),
                                trailing: SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    initialValue: entry.value.toString(),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      prefixText: '₹',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          _contributions[entry.key] = double.parse(value);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Confirm Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        HapticFeedback.mediumImpact();
                        await _animationController.forward();
                        await _animationController.reverse();
                        await _saveBudget();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Confirm Budget',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2, // Budget tab is selected
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1: // Itineraries
              Navigator.pushReplacementNamed(context, '/itinerary');
              break;
            case 2: // Budget
              // Already on budget page
              break;
            case 3: // Profile
              // TODO: Implement profile page
              break;
          }
        },
      ),
    );
  }

  Color getChartColor(int index) => Theme.of(context).colorScheme.getChartColor(index);
} 