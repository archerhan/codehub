/**
 *  author : archer
 *  date : 2019-06-26 11:20
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';

part 'commit_git_user.g.dart';

@JsonSerializable()
class CommitGitUser {
  String name;
  String email;
  DateTime date;

  CommitGitUser(this.name, this.email, this.date);

  factory CommitGitUser.fromJson(Map<String, dynamic> json) =>
      _$CommitGitUserFromJson(json);

  Map<String, dynamic> toJson() => _$CommitGitUserToJson(this);
}
