/**
 *  author : archer
 *  date : 2019-06-26 11:02
 *  description :
 */

import 'package:json_annotation/json_annotation.dart';

part 'licence.g.dart';

@JsonSerializable()
class License {

  String name;

  License(this.name);

  factory License.fromJson(Map<String, dynamic> json) => _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}
