/**
 *  author : archer
 *  date : 2019-06-26 11:03
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';

part 'repository_permissions.g.dart';

@JsonSerializable()
class RepositoryPermissions {
  bool admin;
  bool push;
  bool pull;

  RepositoryPermissions(
      this.admin,
      this.push,
      this.pull,
      );

  factory RepositoryPermissions.fromJson(Map<String, dynamic> json) => _$RepositoryPermissionsFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryPermissionsToJson(this);
}