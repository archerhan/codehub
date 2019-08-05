/*
 * @Description: tab trend model
 * @Author: ArcherHan
 * @Date: 2019-08-02 14:14:31
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-02 14:16:05
 */

import 'package:json_annotation/json_annotation.dart';

part 'trend_repo_mode.g.dart';

@JsonSerializable()
class TrendingRepoModel {
  String fullName;
  String url;

  String description;
  String language;
  String meta;
  List<String> contributors;
  String contributorsUrl;

  String starCount;
  String forkCount;
  String name;

  String reposName;

  TrendingRepoModel(
    this.fullName,
    this.url,
    this.description,
    this.language,
    this.meta,
    this.contributors,
    this.contributorsUrl,
    this.starCount,
    this.name,
    this.reposName,
    this.forkCount,
  );

  TrendingRepoModel.empty();

  factory TrendingRepoModel.fromJson(Map<String, dynamic> json) =>
      _$TrendingRepoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingRepoModelToJson(this);
}
