import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/progress_provider.dart';

class MarketMatcherGame extends ConsumerStatefulWidget {
  const MarketMatcherGame({super.key});

  @override
  ConsumerState<MarketMatcherGame> createState() => _MarketMatcherGameState();
}

class _MarketMatcherGameState extends ConsumerState<MarketMatcherGame> {
  int _currentLevel = 0;
  int _score = 0;
  int _lives = 3;
  bool _showingFeedback = false;
  String? _selectedAnswer;

  final List<MarketScenario> _scenarios = [
    MarketScenario(
      id: 1,
      scenario: '📱 Apple releases a new iPhone with revolutionary features',
      question: 'What happens to the demand for the NEW iPhone?',
      correctAnswer: 'demand_increase',
      explanation: 'New revolutionary features make the product more desirable, increasing demand (curve shifts right).',
    ),
    MarketScenario(
      id: 2,
      scenario: '⛽ Gas prices skyrocket due to oil shortage',
      question: 'What happens to the demand for electric cars?',
      correctAnswer: 'demand_increase',
      explanation: 'Electric cars become more attractive as a substitute when gas is expensive, increasing demand.',
    ),
    MarketScenario(
      id: 3,
      scenario: '🏭 New automation technology makes production cheaper',
      question: 'What happens to the supply of manufactured goods?',
      correctAnswer: 'supply_increase',
      explanation: 'Lower production costs allow companies to produce more profitably, increasing supply (curve shifts right).',
    ),
    MarketScenario(
      id: 4,
      scenario: '❄️ Severe winter storm damages orange crops in Florida',
      question: 'What happens to the supply of oranges?',
      correctAnswer: 'supply_decrease',
      explanation: 'Damaged crops mean less oranges available, decreasing supply (curve shifts left).',
    ),
    MarketScenario(
      id: 5,
      scenario: '💼 Economic recession - people lose their jobs',
      question: 'What happens to the demand for luxury cars?',
      correctAnswer: 'demand_decrease',
      explanation: 'With less income, people buy fewer luxury goods, decreasing demand (curve shifts left).',
    ),
    MarketScenario(
      id: 6,
      scenario: '🌟 Celebrity endorses a brand of sneakers',
      question: 'What happens to the demand for those sneakers?',
      correctAnswer: 'demand_increase',
      explanation: 'Celebrity endorsement makes the product more desirable, increasing demand.',
    ),
    MarketScenario(
      id: 7,
      scenario: '🏗️ Government adds heavy taxes on cigarette production',
      question: 'What happens to the supply of cigarettes?',
      correctAnswer: 'supply_decrease',
      explanation: 'Higher taxes increase production costs, making it less profitable to produce, decreasing supply.',
    ),
    MarketScenario(
      id: 8,
      scenario: '📺 Negative news about health risks of soda',
      question: 'What happens to the demand for soda?',
      correctAnswer: 'demand_decrease',
      explanation: 'Health concerns make the product less desirable, decreasing demand.',
    ),
    MarketScenario(
      id: 9,
      scenario: '🚗 Gas prices drop significantly',
      question: 'What happens to the demand for SUVs and trucks?',
      correctAnswer: 'demand_increase',
      explanation: 'Lower gas costs make gas-guzzling vehicles more affordable to operate, increasing demand.',
    ),
    MarketScenario(
      id: 10,
      scenario: '🌾 Perfect weather creates record wheat harvest',
      question: 'What happens to the supply of wheat?',
      correctAnswer: 'supply_increase',
      explanation: 'Bumper crop means more wheat available, increasing supply.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_currentLevel >= _scenarios.length) {
      return _buildGameComplete();
    }

    final scenario = _scenarios[_currentLevel];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Matcher'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                ...List.generate(
                  3,
                  (index) => Icon(
                    index < _lives ? Icons.favorite : Icons.favorite_border,
                    color: AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress
          LinearProgressIndicator(
            value: _currentLevel / _scenarios.length,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.economicsColor),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Level indicator
                  Text(
                    'Level ${_currentLevel + 1} of ${_scenarios.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.economicsColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Scenario
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.economicsGradient,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Scenario',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scenario.scenario,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Question
                  Text(
                    scenario.question,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Answer options
                  _buildAnswerOption(
                    'demand_increase',
                    '📈 Demand Increases',
                    'Demand curve shifts RIGHT',
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildAnswerOption(
                    'demand_decrease',
                    '📉 Demand Decreases',
                    'Demand curve shifts LEFT',
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildAnswerOption(
                    'supply_increase',
                    '📈 Supply Increases',
                    'Supply curve shifts RIGHT',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildAnswerOption(
                    'supply_decrease',
                    '📉 Supply Decreases',
                    'Supply curve shifts LEFT',
                    Colors.orange,
                  ),

                  const SizedBox(height: 24),

                  // Feedback
                  if (_showingFeedback) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedAnswer == scenario.correctAnswer
                            ? AppColors.successGreen.withOpacity(0.1)
                            : AppColors.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedAnswer == scenario.correctAnswer
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selectedAnswer == scenario.correctAnswer
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: _selectedAnswer == scenario.correctAnswer
                                    ? AppColors.successGreen
                                    : AppColors.errorRed,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedAnswer == scenario.correctAnswer
                                      ? 'Correct! +10 points'
                                      : 'Not quite right. Try again!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedAnswer == scenario.correctAnswer
                                        ? AppColors.successGreen
                                        : AppColors.errorRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            scenario.explanation,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_selectedAnswer == scenario.correctAnswer)
                      ElevatedButton(
                        onPressed: _nextLevel,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.economicsColor,
                        ),
                        child: Text(
                          _currentLevel == _scenarios.length - 1
                              ? 'Complete Game'
                              : 'Next Level',
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
    );
  }

  Widget _buildAnswerOption(
    String answerId,
    String title,
    String subtitle,
    Color color,
  ) {
    final isSelected = _selectedAnswer == answerId;
    final scenario = _scenarios[_currentLevel];
    final isCorrect = answerId == scenario.correctAnswer;

    Color? backgroundColor;
    Color? borderColor;

    if (_showingFeedback) {
      if (isCorrect) {
        backgroundColor = AppColors.successGreen.withOpacity(0.1);
        borderColor = AppColors.successGreen;
      } else if (isSelected) {
        backgroundColor = AppColors.errorRed.withOpacity(0.1);
        borderColor = AppColors.errorRed;
      }
    } else if (isSelected) {
      backgroundColor = color.withOpacity(0.1);
      borderColor = color;
    }

    return InkWell(
      onTap: _showingFeedback ? null : () => _handleAnswer(answerId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (borderColor ?? color).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _showingFeedback && isCorrect
                    ? Icon(Icons.check, color: AppColors.successGreen, size: 28)
                    : _showingFeedback && isSelected
                        ? Icon(Icons.close, color: AppColors.errorRed, size: 28)
                        : Icon(Icons.trending_up, color: color, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAnswer(String answerId) {
    final scenario = _scenarios[_currentLevel];
    final isCorrect = answerId == scenario.correctAnswer;

    setState(() {
      _selectedAnswer = answerId;
      _showingFeedback = true;

      if (isCorrect) {
        _score += 10;
      } else {
        _lives--;
        if (_lives <= 0) {
          _showGameOver();
        }
      }
    });
  }

  void _nextLevel() {
    setState(() {
      _currentLevel++;
      _selectedAnswer = null;
      _showingFeedback = false;
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 64, color: AppColors.errorRed),
            const SizedBox(height: 16),
            Text(
              'You ran out of lives!\nFinal Score: $_score',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Exit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentLevel = 0;
                _score = 0;
                _lives = 3;
                _selectedAnswer = null;
                _showingFeedback = false;
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameComplete() {
    // Award rewards
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProgressProvider.notifier).addXP(150);
      await ref.read(userProgressProvider.notifier).addCoins(100);
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.economicsGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                const SizedBox(height: 24),
                const Text(
                  '🎉 Congratulations! 🎉',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'You completed Market Matcher!',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Final Score',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_score',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.economicsColor,
                        ),
                      ),
                      const Divider(height: 32),
                      _buildReward(Icons.stars, '+150 XP'),
                      const SizedBox(height: 8),
                      _buildReward(Icons.monetization_on, '+100 Coins'),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.economicsColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReward(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.economicsColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class MarketScenario {
  final int id;
  final String scenario;
  final String question;
  final String correctAnswer;
  final String explanation;

  MarketScenario({
    required this.id,
    required this.scenario,
    required this.question,
    required this.correctAnswer,
    required this.explanation,
  });
}
