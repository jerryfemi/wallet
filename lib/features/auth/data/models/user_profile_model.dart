import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    required String uid,
    required String displayName,
    required String email,
    @Default('USD') String preferredCurrency,
    required DateTime createdAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Converts this model to a domain entity
  UserProfile toEntity() {
    return UserProfile(
      uid: uid,
      displayName: displayName,
      email: email,
      preferredCurrency: preferredCurrency,
      createdAt: createdAt,
    );
  }

  /// Creates a model from a domain entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      uid: entity.uid,
      displayName: entity.displayName,
      email: entity.email,
      preferredCurrency: entity.preferredCurrency,
      createdAt: entity.createdAt,
    );
  }
}
