/**
 *  author : archer
 *  date : 2019-06-26 10:34
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:codehub/common/model/user.dart';

part 'push_event_commit.g.dart';

@JsonSerializable()
class PushEventCommit {
  String sha;
  User author;
  String message;
  bool distinct;
  String url;

  PushEventCommit(
      this.sha,
      this.author,
      this.message,
      this.distinct,
      this.url,
      );

  factory PushEventCommit.fromJson(Map<String, dynamic> json) => _$PushEventCommitFromJson(json);

  Map<String, dynamic> toJson() => _$PushEventCommitToJson(this);
}