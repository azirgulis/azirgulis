import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/progress_provider.dart';
import '../../../../providers/achievement_provider.dart';
import '../../../../widgets/notifications/achievement_notification.dart';

class InflationScenario {
  final String item;
  final double originalPrice;
  final double inflationRate; // as percentage
  final String context;
  final String explanation;

  const InflationScenario({
    required this.item,
    required this.originalPrice,
    required this.inflationRate,
    required this.context,
    required this.explanation,
  });

  double get correctPrice => originalPrice * (1 + inflationRate / 100);
}

class InflationStationGame extends ConsumerStatefulWidget {
  const InflationStationGame({super.key});

  @override
  ConsumerState<InflationStationGame> createState() =>
      _InflationStationGameState();
}

class _InflationStationGameState extends ConsumerState<InflationStationGame> {
  int _currentScenarioIndex = 0;
  int _score = 0;
  int _lives = 3;
  bool _gameOver = false;
  bool _isAnswered = false;
  double? _userAnswer;
  late ConfettiController _confettiController;

  final TextEditingController _priceController = TextEditingController();

  final List<InflationScenario> _scenarios = const [
    InflationScenario(
      item: 'Gallon of Milk',
      originalPrice: 3.50,
      inflationRate: 8.0,
      context: 'Annual inflation is 8%. What will milk cost next year?',
      explanation:
          'With 8% inflation, prices increase by 8%. Calculate: \$3.50 × 1.08 = \$3.78',
    ),
    InflationScenario(
      item: 'Movie Ticket',
      originalPrice: 12.00,
      inflationRate: 5.0,
      context: 'Inflation is 5%. What will a movie ticket cost?',
      explanation:
          'With 5% inflation, add 5% to the price: \$12.00 × 1.05 = \$12.60',
    ),
    InflationScenario(
      item: 'Loaf of Bread',
      originalPrice: 2.50,
      inflationRate: 10.0,
      context: 'High inflation of 10%! What will bread cost?',
      explanation:
          'With 10% inflation, prices rise significantly: \$2.50 × 1.10 = \$2.75',
    ),
    InflationScenario(
      item: 'Coffee',
      originalPrice: 4.00,
      inflationRate: 6.5,
      context: 'Inflation is 6.5%. What will your coffee cost?',
      explanation:
          'With 6.5% inflation, calculate: \$4.00 × 1.065 = \$4.26',
    ),
    InflationScenario(
      item: 'Gasoline (per gallon)',
      originalPrice: 3.20,
      inflationRate: 12.0,
      context: 'Energy inflation at 12%! What will gas cost?',
      explanation:
          'High energy inflation: \$3.20 × 1.12 = \$3.58',
    ),
    InflationScenario(
      item: 'Smartphone',
      originalPrice: 800.00,
      inflationRate: 4.0,
      context: 'Tech inflation is 4%. What will a new phone cost?',
      explanation:
          'With 4% inflation on electronics: \$800 × 1.04 = \$832',
    ),
    InflationScenario(
      item: 'Monthly Rent',
      originalPrice: 1200.00,
      inflationRate: 7.0,
      context: 'Housing inflation at 7%. What will rent be?',
      explanation:
          'With 7% housing inflation: \$1,200 × 1.07 = \$1,284',
    ),
    InflationScenario(
      item: 'Grocery Bill',
      originalPrice: 150.00,
      inflationRate: 9.0,
      context: 'Food inflation is 9%. What will groceries cost?',
      explanation:
          'With 9% food inflation: \$150 × 1.09 = \$163.50',
    ),
    InflationScenario(
      item: 'Textbook',
      originalPrice: 85.00,
      inflationRate: 3.5,
      context: 'Education inflation at 3.5%. What will a textbook cost?',
      explanation:
          'With 3.5% inflation: \$85 × 1.035 = \$87.98',
    ),
    InflationScenario(
      item: 'Restaurant Meal',
      originalPrice: 25.00,
      inflationRate: 8.5,
      context: 'Restaurant inflation is 8.5%. What will dinner cost?',
      explanation:
          'With 8.5% inflation on dining: \$25 × 1.085 = \$27.13',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a price')),
      );
      return;
    }

    final userAnswer = double.tryParse(_priceController.text);
    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    setState(() {
      _userAnswer = userAnswer;
      _isAnswered = true;
    });

    final scenario = _scenarios[_currentScenarioIndex];
    final correctPrice = scenario.correctPrice;
    final difference = (userAnswer - correctPrice).abs();
    final percentageError = (difference / correctPrice) * 100;

    // Allow 2% margin of error for correct answer
    final isCorrect = percentageError <= 2.0;

    if (isCorrect) {
      setState(() {
        _score += 10;
      });
    } else {
      setState(() {
        _lives--;
        if (_lives <= 0) {
          _gameOver = true;
        }
      });
    }
  }

  void _nextScenario() {
    if (_currentScenarioIndex < _scenarios.length - 1) {
      setState(() {
        _currentScenarioIndex++;
        _isAnswered = false;
        _userAnswer = null;
        _priceController.clear();
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    // Award rewards
    final xpReward = 150;
    final coinsReward = 100;

    await ref.read(userProgressProvider.notifier).addXP(xpReward);
    await ref.read(userProgressProvider.notifier).addCoins(coinsReward);

    // Check for achievements
    final newAchievements = await ref
        .read(achievementCheckerProvider.notifier)
        .checkAfterMiniGame('inflation_station');

    _confettiController.play();

    if (mounted) {
      // Show achievement notifications
      if (newAchievements.isNotEmpty) {
        for (var i = 0; i < newAchievements.length; i++) {
          final achievement = newAchievements[i];
          Future.delayed(Duration(milliseconds: i * 4500), () {
            if (mounted) {
              AchievementNotificationOverlay.show(
                context,
                achievement,
                onTap: () => context.push('/achievements'),
              );
            }
          });
        }
      }

      // Show completion dialog
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showCompletionDialog();
        }
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _score >= 70 ? Icons.emoji_events : Icons.school,
              color: _score >= 70
                  ? AppColors.badgeLegendary
                  : AppColors.primaryColor,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(_score >= 70 ? 'Excellent!' : 'Good Try!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Final Score: $_score',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              _score >= 70
                  ? 'You have a great understanding of inflation!'
                  : 'Keep practicing to master inflation calculations!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, color: AppColors.xpColor, size: 20),
                      SizedBox(width: 4),
                      Text('+150 XP',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on,
                          color: AppColors.coinsColor, size: 20),
                      SizedBox(width: 4),
                      Text('+100 Coins',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/economics');
            },
            child: const Text('Back to Economics'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentScenarioIndex = 0;
                _score = 0;
                _lives = 3;
                _gameOver = false;
                _isAnswered = false;
                _userAnswer = null;
                _priceController.clear();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      _finishGame();
    }

    final scenario = _scenarios[_currentScenarioIndex];
    final correctPrice = scenario.correctPrice;
    final isCorrect = _isAnswered &&
        _userAnswer != null &&
        ((_userAnswer! - correctPrice).abs() / correctPrice * 100) <= 2.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inflation Station'),
        backgroundColor: AppColors.economicsColor,
        actions: [
          // Score
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.star, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Lives indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.favorite,
                        color: index < _lives ? Colors.red : Colors.grey[300],
                        size: 32,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Progress
                Text(
                  'Scenario ${_currentScenarioIndex + 1} of ${_scenarios.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentScenarioIndex + 1) / _scenarios.length,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.economicsColor,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Scenario card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Item
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.economicsColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: AppColors.economicsColor,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                scenario.item,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.economicsColor,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Original price
                        Text(
                          'Current Price',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${scenario.originalPrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.economicsColor,
                                  ),
                        ),

                        const SizedBox(height: 24),

                        // Context
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.warningYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.warningYellow.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: AppColors.warningYellow,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Inflation: ${scenario.inflationRate}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.warningYellow,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                scenario.context,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Answer input
                        if (!_isAnswered) ...[
                          TextField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Enter New Price',
                              prefixText: '\$ ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _checkAnswer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.economicsColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Check Answer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],

                        // Result
                        if (_isAnswered) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (isCorrect
                                      ? AppColors.successGreen
                                      : AppColors.errorRed)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (isCorrect
                                        ? AppColors.successGreen
                                        : AppColors.errorRed)
                                    .withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect
                                      ? AppColors.successGreen
                                      : AppColors.errorRed,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  isCorrect ? 'Correct!' : 'Not Quite!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect
                                        ? AppColors.successGreen
                                        : AppColors.errorRed,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your answer: \$${_userAnswer!.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  'Correct price: \$${correctPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  scenario.explanation,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _nextScenario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.economicsColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _currentScenarioIndex < _scenarios.length - 1
                                  ? 'Next Scenario'
                                  : 'Finish Game',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
