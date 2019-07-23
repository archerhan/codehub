/**
 *  author : archer
 *  date : 2019-06-26 11:37
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';

part 'notification_subject.g.dart';

@JsonSerializable()
class NotificationSubject {
  String title;
  String url;
  String type;

  NotificationSubject(this.title, this.url, this.type);

  factory NotificationSubject.fromJson(Map<String, dynamic> json) =>
      _$NotificationSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSubjectToJson(this);
}
