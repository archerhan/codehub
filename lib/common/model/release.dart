/**
 *  author : archer
 *  date : 2019-06-26 10:36
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/model/release_asset.dart';

part 'release.g.dart';

@JsonSerializable()
class Release {
  int id;
  @JsonKey(name: "tag_name")
  String tagName;
  @JsonKey(name: "target_commitish")
  String targetCommitish;
  String name;
  String body;
  @JsonKey(name: "body_html")
  String bodyHtml;
  @JsonKey(name: "tarball_url")
  String tarballUrl;
  @JsonKey(name: "zipball_url")
  String zipballUrl;

  bool draft;
  @JsonKey(name: "prerelease")
  bool preRelease;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "published_at")
  DateTime publishedAt;

  User author;
  List<ReleaseAsset> assets;

  Release(
      this.id,
      this.tagName,
      @JsonKey(name: "target_commitish") this.targetCommitish,
      this.name,
      this.body,
      this.bodyHtml,
      this.tarballUrl,
      this.zipballUrl,
      this.draft,
      this.preRelease,
      this.createdAt,
      this.publishedAt,
      this.author,
      this.assets,
      );

  factory Release.fromJson(Map<String, dynamic> json) => _$ReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseToJson(this);
}

