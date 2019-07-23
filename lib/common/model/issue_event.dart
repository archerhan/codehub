/**
 *  author : archer
 *  date : 2019-06-26 10:39
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:codehub/common/model/user.dart';

part 'issue_event.g.dart';

@JsonSerializable()
class IssueEvent {
  int id;
  User user;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "author_association")
  String authorAssociation;
  String body;
  @JsonKey(name: "body_html")
  String bodyHtml;
  @JsonKey(name: "event")
  String type;
  @JsonKey(name: "html_url")
  String htmlUrl;

  IssueEvent(
    this.id,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.authorAssociation,
    this.body,
    this.bodyHtml,
    this.type,
    this.htmlUrl,
  );

  factory IssueEvent.fromJson(Map<String, dynamic> json) =>
      _$IssueEventFromJson(json);

  Map<String, dynamic> toJson() => _$IssueEventToJson(this);
}
