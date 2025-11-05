import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';

/// Firestore database service for managing app data
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _users =>
      _firestore.collection(AppConstants.usersCollection);
  CollectionReference get _progress =>
      _firestore.collection(AppConstants.progressCollection);
  CollectionReference get _leaderboard =>
      _firestore.collection(AppConstants.leaderboardCollection);
  CollectionReference get _achievements =>
      _firestore.collection(AppConstants.achievementsCollection);
  CollectionReference get _challenges =>
      _firestore.collection(AppConstants.challengesCollection);

  // ==================== USER OPERATIONS ====================

  /// Create or update user document
  Future<void> createUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _users.doc(userId).set(
        {
          ...userData,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user data
  Future<void> updateUser(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _users.doc(userId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Stream user data
  Stream<DocumentSnapshot> streamUser(String userId) {
    return _users.doc(userId).snapshots();
  }

  // ==================== PROGRESS OPERATIONS ====================

  /// Save user progress
  Future<void> saveProgress(
    String userId,
    Map<String, dynamic> progressData,
  ) async {
    try {
      await _progress.doc(userId).set(
        {
          ...progressData,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save progress: $e');
    }
  }

  /// Get user progress
  Future<Map<String, dynamic>?> getProgress(String userId) async {
    try {
      final doc = await _progress.doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get progress: $e');
    }
  }

  /// Stream user progress
  Stream<DocumentSnapshot> streamProgress(String userId) {
    return _progress.doc(userId).snapshots();
  }

  /// Add XP to user
  Future<void> addXP(String userId, int amount) async {
    try {
      await _progress.doc(userId).update({
        'xp': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add XP: $e');
    }
  }

  /// Add coins to user
  Future<void> addCoins(String userId, int amount) async {
    try {
      await _progress.doc(userId).update({
        'coins': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add coins: $e');
    }
  }

  /// Add gems to user
  Future<void> addGems(String userId, int amount) async {
    try {
      await _progress.doc(userId).update({
        'gems': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add gems: $e');
    }
  }

  /// Update level
  Future<void> updateLevel(String userId, int newLevel) async {
    try {
      await _progress.doc(userId).update({
        'level': newLevel,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update level: $e');
    }
  }

  /// Mark lesson as completed
  Future<void> completeLesson(
    String userId,
    String pillar,
    int lessonNumber,
  ) async {
    try {
      await _progress.doc(userId).update({
        'completedLessons.$pillar.$lessonNumber': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to complete lesson: $e');
    }
  }

  /// Save quiz result
  Future<void> saveQuizResult(
    String userId,
    String pillar,
    int lessonNumber,
    Map<String, dynamic> quizData,
  ) async {
    try {
      await _progress.doc(userId).update({
        'quizResults.$pillar.$lessonNumber': quizData,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  // ==================== LEADERBOARD OPERATIONS ====================

  /// Get global leaderboard
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({
    int limit = 100,
  }) async {
    try {
      final snapshot = await _leaderboard
          .orderBy('totalXP', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => {
                'userId': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get leaderboard: $e');
    }
  }

  /// Get user's leaderboard rank
  Future<int> getUserRank(String userId) async {
    try {
      final userDoc = await _leaderboard.doc(userId).get();
      if (!userDoc.exists) return -1;

      final userXP = (userDoc.data() as Map<String, dynamic>)['totalXP'] ?? 0;

      final higherRanked = await _leaderboard
          .where('totalXP', isGreaterThan: userXP)
          .count()
          .get();

      return higherRanked.count! + 1;
    } catch (e) {
      throw Exception('Failed to get user rank: $e');
    }
  }

  /// Update leaderboard entry
  Future<void> updateLeaderboardEntry(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _leaderboard.doc(userId).set(
        {
          ...data,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to update leaderboard: $e');
    }
  }

  // ==================== ACHIEVEMENTS OPERATIONS ====================

  /// Unlock achievement
  Future<void> unlockAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      await _achievements.doc(userId).set({
        'unlocked.$achievementId': {
          'unlockedAt': FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to unlock achievement: $e');
    }
  }

  /// Get user achievements
  Future<Map<String, dynamic>?> getUserAchievements(String userId) async {
    try {
      final doc = await _achievements.doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get achievements: $e');
    }
  }

  // ==================== CHALLENGES OPERATIONS ====================

  /// Get active challenges
  Future<List<Map<String, dynamic>>> getActiveChallenges() async {
    try {
      final now = Timestamp.now();
      final snapshot = await _challenges
          .where('endDate', isGreaterThan: now)
          .where('startDate', isLessThanOrEqualTo: now)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get challenges: $e');
    }
  }

  /// Join challenge
  Future<void> joinChallenge(String userId, String challengeId) async {
    try {
      await _challenges.doc(challengeId).update({
        'participants.$userId': {
          'joinedAt': FieldValue.serverTimestamp(),
          'score': 0,
        },
      });
    } catch (e) {
      throw Exception('Failed to join challenge: $e');
    }
  }

  /// Update challenge progress
  Future<void> updateChallengeProgress(
    String userId,
    String challengeId,
    int score,
  ) async {
    try {
      await _challenges.doc(challengeId).update({
        'participants.$userId.score': score,
        'participants.$userId.lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update challenge progress: $e');
    }
  }

  // ==================== FRIENDS OPERATIONS ====================

  /// Send friend request
  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    try {
      await _users.doc(toUserId).update({
        'friendRequests': FieldValue.arrayUnion([fromUserId]),
      });
    } catch (e) {
      throw Exception('Failed to send friend request: $e');
    }
  }

  /// Accept friend request
  Future<void> acceptFriendRequest(
    String userId,
    String friendId,
  ) async {
    try {
      final batch = _firestore.batch();

      // Add to both users' friends lists
      batch.update(_users.doc(userId), {
        'friends': FieldValue.arrayUnion([friendId]),
        'friendRequests': FieldValue.arrayRemove([friendId]),
      });

      batch.update(_users.doc(friendId), {
        'friends': FieldValue.arrayUnion([userId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to accept friend request: $e');
    }
  }

  /// Remove friend
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      final batch = _firestore.batch();

      batch.update(_users.doc(userId), {
        'friends': FieldValue.arrayRemove([friendId]),
      });

      batch.update(_users.doc(friendId), {
        'friends': FieldValue.arrayRemove([userId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to remove friend: $e');
    }
  }

  /// Get friends' progress
  Future<List<Map<String, dynamic>>> getFriendsProgress(
    List<String> friendIds,
  ) async {
    try {
      if (friendIds.isEmpty) return [];

      // Firestore 'in' query limit is 10
      final chunks = <List<String>>[];
      for (var i = 0; i < friendIds.length; i += 10) {
        chunks.add(
          friendIds.sublist(
            i,
            i + 10 > friendIds.length ? friendIds.length : i + 10,
          ),
        );
      }

      final results = <Map<String, dynamic>>[];
      for (final chunk in chunks) {
        final snapshot = await _progress.where(
          FieldPath.documentId,
          whereIn: chunk,
        ).get();

        results.addAll(
          snapshot.docs
              .map((doc) => {
                    'userId': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  })
              .toList(),
        );
      }

      return results;
    } catch (e) {
      throw Exception('Failed to get friends progress: $e');
    }
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Batch write operation
  Future<void> batchWrite(
    List<Map<String, dynamic>> operations,
  ) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final type = operation['type'] as String;
        final collection = operation['collection'] as String;
        final docId = operation['docId'] as String;
        final data = operation['data'] as Map<String, dynamic>;

        final docRef = _firestore.collection(collection).doc(docId);

        switch (type) {
          case 'set':
            batch.set(docRef, data, SetOptions(merge: true));
            break;
          case 'update':
            batch.update(docRef, data);
            break;
          case 'delete':
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to execute batch write: $e');
    }
  }

  /// Delete user data (GDPR compliance)
  Future<void> deleteUserData(String userId) async {
    try {
      final batch = _firestore.batch();

      batch.delete(_users.doc(userId));
      batch.delete(_progress.doc(userId));
      batch.delete(_achievements.doc(userId));
      batch.delete(_leaderboard.doc(userId));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }
}
