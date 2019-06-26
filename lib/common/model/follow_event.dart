/**
 *  author : archer
 *  date : 2019-06-24 17:51
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/model/follow_event_payload.dart';
import 'package:codehub/common/model/repository.dart';

part 'follow_event.g.dart';

@JsonSerializable()
class FollowEvent {
  String id;
  String type;
  User actor;
  Repository repo;
  User org;
  EventPayload payload;
  @JsonKey(name: "public")
  bool isPublic;
  @JsonKey(name: "created_at")
  DateTime createdAt;

  FollowEvent(
      this.id,
      this.type,
      this.actor,
      this.repo,
      this.org,
      this.payload,
      this.isPublic,
      this.createdAt,
      );

  factory FollowEvent.fromJson(Map<String, dynamic> json) => _$FollowEventFromJson(json);

  Map<String, dynamic> toJson() => _$FollowEventToJson(this);
}