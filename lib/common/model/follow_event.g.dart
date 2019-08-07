// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowEvent _$FollowEventFromJson(Map<String, dynamic> json) {
  return FollowEvent(
    json['id'] as String,
    json['type'] as String,
    json['actor'] == null
        ? null
        : User.fromJson(json['actor'] as Map<String, dynamic>),
    json['repo'] == null
        ? null
        : Repository.fromJson(json['repo'] as Map<String, dynamic>),
    json['org'] == null
        ? null
        : User.fromJson(json['org'] as Map<String, dynamic>),
    json['payload'] == null
        ? null
        : EventPayload.fromJson(json['payload'] as Map<String, dynamic>),
    json['public'] as bool,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> _$FollowEventToJson(FollowEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'actor': instance.actor,
      'repo': instance.repo,
      'org': instance.org,
      'payload': instance.payload,
      'public': instance.isPublic,
      'created_at': instance.createdAt?.toIso8601String(),
    };
