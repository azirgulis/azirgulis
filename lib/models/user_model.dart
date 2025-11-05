import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    String? displayName,
    String? photoUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(false) bool isAnonymous,
    @Default('en') String preferredLanguage,
    @Default([]) List<String> friends,
    @Default([]) List<String> friendRequests,
    AvatarCustomization? avatar,
    BusinessProfile? business,
    LearningPreferences? learningPreferences,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class AvatarCustomization with _$AvatarCustomization {
  const factory AvatarCustomization({
    @Default('default') String baseStyle,
    @Default('default') String hairstyle,
    @Default('default') String outfit,
    @Default([]) List<String> accessories,
    @Default('#FFFFFF') String skinColor,
    @Default('#000000') String hairColor,
    @Default([]) List<String> ownedItems,
  }) = _AvatarCustomization;

  factory AvatarCustomization.fromJson(Map<String, dynamic> json) =>
      _$AvatarCustomizationFromJson(json);
}

@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String name,
    required String industry,
    @Default('') String logo,
    @Default('') String description,
    @Default(0) int revenue,
    @Default(0) int employees,
    @Default(0.0) double marketShare,
    DateTime? foundedDate,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);
}

@freezed
class LearningPreferences with _$LearningPreferences {
  const factory LearningPreferences({
    @Default('standard') String pace, // fast, standard, leisurely
    @Default('balanced') String contentFormat, // video, text, interactive, balanced
    @Default('intermediate') String difficulty, // beginner, intermediate, advanced
    @Default([]) List<String> interests,
    @Default([]) List<String> careerGoals,
  }) = _LearningPreferences;

  factory LearningPreferences.fromJson(Map<String, dynamic> json) =>
      _$LearningPreferencesFromJson(json);
}
