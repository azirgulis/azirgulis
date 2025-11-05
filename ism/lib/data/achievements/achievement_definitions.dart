import '../../models/achievement_model.dart';

class AchievementDefinitions {
  static List<AchievementModel> getAllAchievements() {
    return [
      ..._levelMilestones(),
      ..._subjectMastery(),
      ..._quizPerformance(),
      ..._socialAchievements(),
      ..._dailyEngagement(),
      ..._ismContent(),
      ..._miniGameMasters(),
      ..._specialAchievements(),
    ];
  }

  // LEVEL MILESTONES (4 achievements)
  static List<AchievementModel> _levelMilestones() {
    return [
      const AchievementModel(
        id: 'level_10',
        title: 'Rising Star',
        description: 'Reach Level 10',
        category: AchievementCategory.levelMilestone,
        rarity: AchievementRarity.common,
        iconName: 'star',
        coinsReward: 500,
        xpReward: 0,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.reachLevel,
          targetValue: 10,
        ),
      ),
      const AchievementModel(
        id: 'level_25',
        title: 'Scholar',
        description: 'Reach Level 25 - Unlock Application Hub!',
        category: AchievementCategory.levelMilestone,
        rarity: AchievementRarity.rare,
        iconName: 'school',
        coinsReward: 1000,
        xpReward: 0,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.reachLevel,
          targetValue: 25,
        ),
      ),
      const AchievementModel(
        id: 'level_40',
        title: 'Business Expert',
        description: 'Reach Level 40',
        category: AchievementCategory.levelMilestone,
        rarity: AchievementRarity.epic,
        iconName: 'business_center',
        coinsReward: 2000,
        xpReward: 0,
        gemsReward: 15,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.reachLevel,
          targetValue: 40,
        ),
      ),
      const AchievementModel(
        id: 'level_50',
        title: 'Master of Business',
        description: 'Reach Maximum Level 50!',
        category: AchievementCategory.levelMilestone,
        rarity: AchievementRarity.legendary,
        iconName: 'emoji_events',
        coinsReward: 5000,
        xpReward: 0,
        gemsReward: 25,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.reachLevel,
          targetValue: 50,
        ),
      ),
    ];
  }

  // SUBJECT MASTERY (12 achievements - Bronze/Silver/Gold for each pillar)
  static List<AchievementModel> _subjectMastery() {
    final subjects = [
      {'id': 'economics', 'name': 'Economics'},
      {'id': 'management', 'name': 'Management'},
      {'id': 'business', 'name': 'Business'},
      {'id': 'marketing', 'name': 'Marketing'},
    ];

    final achievements = <AchievementModel>[];

    for (final subject in subjects) {
      achievements.addAll([
        AchievementModel(
          id: '${subject['id']}_bronze',
          title: '${subject['name']} Bronze',
          description: 'Complete 3 ${subject['name']} lessons',
          category: AchievementCategory.subjectMastery,
          rarity: AchievementRarity.common,
          iconName: 'bronze_medal',
          coinsReward: 200,
          xpReward: 50,
          gemsReward: 0,
          criteria: AchievementCriteria(
            type: AchievementCriteriaType.completeLessons,
            targetValue: 3,
            additionalData: {'pillar': subject['id']},
          ),
        ),
        AchievementModel(
          id: '${subject['id']}_silver',
          title: '${subject['name']} Silver',
          description: 'Complete 6 ${subject['name']} lessons',
          category: AchievementCategory.subjectMastery,
          rarity: AchievementRarity.rare,
          iconName: 'silver_medal',
          coinsReward: 400,
          xpReward: 100,
          gemsReward: 5,
          criteria: AchievementCriteria(
            type: AchievementCriteriaType.completeLessons,
            targetValue: 6,
            additionalData: {'pillar': subject['id']},
          ),
        ),
        AchievementModel(
          id: '${subject['id']}_gold',
          title: '${subject['name']} Gold',
          description: 'Complete all 10 ${subject['name']} lessons',
          category: AchievementCategory.subjectMastery,
          rarity: AchievementRarity.epic,
          iconName: 'gold_medal',
          coinsReward: 1000,
          xpReward: 250,
          gemsReward: 10,
          criteria: AchievementCriteria(
            type: AchievementCriteriaType.completePillar,
            targetValue: 1,
            additionalData: {'pillar': subject['id']},
          ),
        ),
      ]);
    }

    return achievements;
  }

  // QUIZ PERFORMANCE (8 achievements)
  static List<AchievementModel> _quizPerformance() {
    return [
      const AchievementModel(
        id: 'perfect_score_1',
        title: 'Perfect!',
        description: 'Get a perfect score on your first quiz',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.common,
        iconName: 'check_circle',
        coinsReward: 100,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 1,
        ),
      ),
      const AchievementModel(
        id: 'perfect_score_5',
        title: 'Quiz Master',
        description: 'Get 5 perfect quiz scores',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.rare,
        iconName: 'stars',
        coinsReward: 500,
        xpReward: 150,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'perfect_score_10',
        title: 'Flawless',
        description: 'Get 10 perfect quiz scores',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.epic,
        iconName: 'workspace_premium',
        coinsReward: 1000,
        xpReward: 300,
        gemsReward: 15,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 10,
        ),
      ),
      const AchievementModel(
        id: 'perfect_score_20',
        title: 'Genius',
        description: 'Get 20 perfect quiz scores',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.legendary,
        iconName: 'psychology',
        coinsReward: 2000,
        xpReward: 500,
        gemsReward: 25,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 20,
        ),
      ),
      const AchievementModel(
        id: 'quiz_streak_5',
        title: 'On Fire!',
        description: 'Complete quizzes 5 days in a row',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.rare,
        iconName: 'local_fire_department',
        coinsReward: 300,
        xpReward: 100,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.loginStreak,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete a quiz in under 2 minutes',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.rare,
        iconName: 'speed',
        coinsReward: 200,
        xpReward: 75,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'comeback_kid',
        title: 'Comeback Kid',
        description: 'Retake a quiz and improve your score by 40%',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.rare,
        iconName: 'trending_up',
        coinsReward: 250,
        xpReward: 100,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'overachiever',
        title: 'Overachiever',
        description: 'Score 100% on all quizzes in a pillar',
        category: AchievementCategory.quizPerformance,
        rarity: AchievementRarity.legendary,
        iconName: 'military_tech',
        coinsReward: 1500,
        xpReward: 500,
        gemsReward: 20,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.perfectQuizzes,
          targetValue: 10,
        ),
      ),
    ];
  }

  // SOCIAL ACHIEVEMENTS (10 achievements)
  static List<AchievementModel> _socialAchievements() {
    return [
      const AchievementModel(
        id: 'friend_1',
        title: 'Making Friends',
        description: 'Add your first friend',
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        iconName: 'person_add',
        coinsReward: 100,
        xpReward: 25,
        gemsReward: 0,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.addFriends,
          targetValue: 1,
        ),
      ),
      const AchievementModel(
        id: 'friend_5',
        title: 'Social Butterfly',
        description: 'Add 5 friends',
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        iconName: 'people',
        coinsReward: 250,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.addFriends,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'friend_25',
        title: 'Popular',
        description: 'Add 25 friends',
        category: AchievementCategory.social,
        rarity: AchievementRarity.rare,
        iconName: 'groups',
        coinsReward: 500,
        xpReward: 100,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.addFriends,
          targetValue: 25,
        ),
      ),
      const AchievementModel(
        id: 'challenge_winner',
        title: 'Champion',
        description: 'Win your first challenge',
        category: AchievementCategory.social,
        rarity: AchievementRarity.rare,
        iconName: 'emoji_events',
        coinsReward: 300,
        xpReward: 100,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.winChallenges,
          targetValue: 1,
        ),
      ),
      const AchievementModel(
        id: 'challenge_winner_5',
        title: 'Unstoppable',
        description: 'Win 5 challenges',
        category: AchievementCategory.social,
        rarity: AchievementRarity.epic,
        iconName: 'workspace_premium',
        coinsReward: 1000,
        xpReward: 300,
        gemsReward: 15,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.winChallenges,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'leaderboard_top_10',
        title: 'Top 10',
        description: 'Reach top 10 on the leaderboard',
        category: AchievementCategory.social,
        rarity: AchievementRarity.epic,
        iconName: 'leaderboard',
        coinsReward: 1000,
        xpReward: 250,
        gemsReward: 15,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.earnCoins,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'leaderboard_top_1',
        title: '#1 Rank',
        description: 'Reach #1 on the leaderboard!',
        category: AchievementCategory.social,
        rarity: AchievementRarity.legendary,
        iconName: 'grade',
        coinsReward: 5000,
        xpReward: 1000,
        gemsReward: 50,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.earnCoins,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'helping_hand',
        title: 'Helping Hand',
        description: 'Help a friend complete a lesson',
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        iconName: 'volunteer_activism',
        coinsReward: 150,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.addFriends,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'team_player',
        title: 'Team Player',
        description: 'Complete 5 co-op challenges',
        category: AchievementCategory.social,
        rarity: AchievementRarity.rare,
        iconName: 'groups_3',
        coinsReward: 400,
        xpReward: 150,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.winChallenges,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'rival',
        title: 'Friendly Rival',
        description: 'Beat a friend in a VS challenge',
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        iconName: 'sports_kabaddi',
        coinsReward: 200,
        xpReward: 75,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.winChallenges,
          targetValue: 1,
        ),
      ),
    ];
  }

  // DAILY ENGAGEMENT (6 achievements)
  static List<AchievementModel> _dailyEngagement() {
    return [
      const AchievementModel(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Login 7 days in a row',
        category: AchievementCategory.dailyEngagement,
        rarity: AchievementRarity.common,
        iconName: 'calendar_today',
        coinsReward: 300,
        xpReward: 100,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.loginStreak,
          targetValue: 7,
        ),
      ),
      const AchievementModel(
        id: 'streak_30',
        title: 'Monthly Master',
        description: 'Login 30 days in a row',
        category: AchievementCategory.dailyEngagement,
        rarity: AchievementRarity.rare,
        iconName: 'event',
        coinsReward: 1000,
        xpReward: 300,
        gemsReward: 15,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.loginStreak,
          targetValue: 30,
        ),
      ),
      const AchievementModel(
        id: 'streak_100',
        title: 'Dedication',
        description: 'Login 100 days in a row!',
        category: AchievementCategory.dailyEngagement,
        rarity: AchievementRarity.legendary,
        iconName: 'verified',
        coinsReward: 3000,
        xpReward: 1000,
        gemsReward: 30,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.loginStreak,
          targetValue: 100,
        ),
      ),
      const AchievementModel(
        id: 'early_bird',
        title: 'Early Bird',
        description: 'Complete a lesson before 8 AM',
        category: AchievementCategory.dailyEngagement,
        rarity: AchievementRarity.common,
        iconName: 'wb_sunny',
        coinsReward: 150,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Complete a lesson after 11 PM',
        category: AchievementCategory.dailyEngagement,
        rarity: AchievementRarity.common,
        iconName: 'nightlight',
        coinsReward: 150,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'weekend_warrior',
        title: 'Weekend Warrior',
        description: 'Complete 10 lessons on weekends',
        category: AchievementCategory.dailyEngagement,
        rarity: AchievementRarity.rare,
        iconName: 'weekend',
        coinsReward: 400,
        xpReward: 150,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 10,
        ),
      ),
    ];
  }

  // ISM CONTENT (5 achievements)
  static List<AchievementModel> _ismContent() {
    return [
      const AchievementModel(
        id: 'tour_1',
        title: 'Campus Explorer',
        description: 'Complete your first campus tour',
        category: AchievementCategory.ismContent,
        rarity: AchievementRarity.common,
        iconName: 'tour',
        coinsReward: 200,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.watchVideos,
          targetValue: 1,
        ),
      ),
      const AchievementModel(
        id: 'tour_all',
        title: 'ISM Expert',
        description: 'Complete all campus tours',
        category: AchievementCategory.ismContent,
        rarity: AchievementRarity.rare,
        iconName: 'school',
        coinsReward: 500,
        xpReward: 150,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.watchVideos,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'story_5',
        title: 'Inspired',
        description: 'Watch 5 success stories',
        category: AchievementCategory.ismContent,
        rarity: AchievementRarity.common,
        iconName: 'auto_stories',
        coinsReward: 300,
        xpReward: 75,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.watchVideos,
          targetValue: 5,
        ),
      ),
      const AchievementModel(
        id: 'story_all',
        title: 'Future Leader',
        description: 'Watch all success stories',
        category: AchievementCategory.ismContent,
        rarity: AchievementRarity.rare,
        iconName: 'stars',
        coinsReward: 1000,
        xpReward: 250,
        gemsReward: 15,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.watchVideos,
          targetValue: 20,
        ),
      ),
      const AchievementModel(
        id: 'application_started',
        title: 'Taking Action',
        description: 'Visit the Application Hub',
        category: AchievementCategory.ismContent,
        rarity: AchievementRarity.epic,
        iconName: 'rocket_launch',
        coinsReward: 0,
        xpReward: 0,
        gemsReward: 25,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.reachLevel,
          targetValue: 25,
        ),
      ),
    ];
  }

  // MINI-GAME MASTERS (8 achievements)
  static List<AchievementModel> _miniGameMasters() {
    final games = [
      {'id': 'market_matcher', 'name': 'Market Matcher'},
      {'id': 'inflation_station', 'name': 'Inflation Station'},
      {'id': 'team_builder', 'name': 'Team Builder'},
      {'id': 'crisis_manager', 'name': 'Crisis Manager'},
      {'id': 'budget_boss', 'name': 'Budget Boss'},
      {'id': 'pitch_perfect', 'name': 'Pitch Perfect'},
      {'id': 'brand_battle', 'name': 'Brand Battle'},
      {'id': 'ad_analytics', 'name': 'Ad Analytics'},
    ];

    return games.map((game) {
      return AchievementModel(
        id: '${game['id']}_master',
        title: '${game['name']} Master',
        description: 'Complete ${game['name']} with a perfect score',
        category: AchievementCategory.miniGameMaster,
        rarity: AchievementRarity.rare,
        iconName: 'emoji_events',
        coinsReward: 400,
        xpReward: 150,
        gemsReward: 10,
        criteria: const AchievementCriteria(
          type: AchievementCriteriaType.earnCoins,
          targetValue: 1,
        ),
      );
    }).toList();
  }

  // SPECIAL ACHIEVEMENTS (7 achievements)
  static List<AchievementModel> _specialAchievements() {
    return [
      const AchievementModel(
        id: 'first_lesson',
        title: 'First Steps',
        description: 'Complete your first lesson',
        category: AchievementCategory.special,
        rarity: AchievementRarity.common,
        iconName: 'celebration',
        coinsReward: 100,
        xpReward: 50,
        gemsReward: 5,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 1,
        ),
      ),
      const AchievementModel(
        id: 'millionaire',
        title: 'Millionaire',
        description: 'Accumulate 10,000 coins',
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        iconName: 'paid',
        coinsReward: 0,
        xpReward: 500,
        gemsReward: 25,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.earnCoins,
          targetValue: 10000,
        ),
      ),
      const AchievementModel(
        id: 'gem_collector',
        title: 'Gem Collector',
        description: 'Collect 100 gems',
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        iconName: 'diamond',
        coinsReward: 1000,
        xpReward: 0,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.earnGems,
          targetValue: 100,
        ),
      ),
      const AchievementModel(
        id: 'completionist',
        title: 'Completionist',
        description: 'Complete all 40 lessons',
        category: AchievementCategory.special,
        rarity: AchievementRarity.legendary,
        iconName: 'workspace_premium',
        coinsReward: 5000,
        xpReward: 2000,
        gemsReward: 50,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 40,
        ),
      ),
      const AchievementModel(
        id: 'speed_runner',
        title: 'Speed Runner',
        description: 'Complete a full pillar in one day',
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        iconName: 'flash_on',
        coinsReward: 1500,
        xpReward: 500,
        gemsReward: 20,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 10,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'explorer',
        title: 'Explorer',
        description: 'Try every feature in the app',
        category: AchievementCategory.special,
        rarity: AchievementRarity.rare,
        iconName: 'explore',
        coinsReward: 500,
        xpReward: 200,
        gemsReward: 10,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.completeLessons,
          targetValue: 1,
        ),
        isSecret: true,
      ),
      const AchievementModel(
        id: 'welcome',
        title: 'Welcome!',
        description: 'Create your ISM account',
        category: AchievementCategory.special,
        rarity: AchievementRarity.common,
        iconName: 'waving_hand',
        coinsReward: 50,
        xpReward: 25,
        gemsReward: 0,
        criteria: AchievementCriteria(
          type: AchievementCriteriaType.reachLevel,
          targetValue: 1,
        ),
      ),
    ];
  }

  // Get achievement by ID
  static AchievementModel? getById(String id) {
    try {
      return getAllAchievements().firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get achievements by category
  static List<AchievementModel> getByCategory(AchievementCategory category) {
    return getAllAchievements()
        .where((achievement) => achievement.category == category)
        .toList();
  }

  // Get achievements by rarity
  static List<AchievementModel> getByRarity(AchievementRarity rarity) {
    return getAllAchievements()
        .where((achievement) => achievement.rarity == rarity)
        .toList();
  }
}
