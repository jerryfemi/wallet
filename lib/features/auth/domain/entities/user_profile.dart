import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String displayName,
    required String email,
    @Default('USD') String preferredCurrency,
    required DateTime createdAt,
  }) = _UserProfile;
}
