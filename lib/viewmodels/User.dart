import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String nickname;
  final String? avatar;
  final String? phoneNumber;
  final String? membershipExpiry;
  final bool isWeChatLogin;

  User({
    required this.id,
    required this.nickname,
    this.avatar,
    this.phoneNumber,
    this.membershipExpiry,
    this.isWeChatLogin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? nickname,
    String? avatar,
    String? phoneNumber,
    String? membershipExpiry,
    bool? isWeChatLogin,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      membershipExpiry: membershipExpiry ?? this.membershipExpiry,
      isWeChatLogin: isWeChatLogin ?? this.isWeChatLogin,
    );
  }
}
