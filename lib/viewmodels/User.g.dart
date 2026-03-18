// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      membershipExpiry: json['membershipExpiry'] as String?,
      isWeChatLogin: json['isWeChatLogin'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'phoneNumber': instance.phoneNumber,
      'membershipExpiry': instance.membershipExpiry,
      'isWeChatLogin': instance.isWeChatLogin,
    };
