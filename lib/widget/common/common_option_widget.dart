/**
 *  author : archer
 *  date : 2019-06-29 21:10
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/constant/global_config.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:share/share.dart';
import 'package:codehub/common/constant/global_style.dart';

class CommonOptionWidget extends StatelessWidget {
  final List<OptionModel> otherList;
  final OptionControl control;

  CommonOptionWidget(this.control, {this.otherList});

  _renderHeaderPopItem(List<OptionModel> list) {
    return PopupMenuButton<OptionModel>(
      child: Icon(CustomIcons.MORE),
      onSelected: (model) {
        model.selected(model);
      },
      itemBuilder: (BuildContext contex) {
        return _renderHeaderPopItemChild(list);
      },
    );
  }

  _renderHeaderPopItemChild(List<OptionModel> data) {
    List<PopupMenuEntry<OptionModel>> list = List();
    for (OptionModel item in data) {
      list.add(PopupMenuItem<OptionModel>(
        value: item,
        child: Text(item.name),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<OptionModel> list = [
      new OptionModel("浏览器打开", "浏览器打开", null),
      new OptionModel("复制链接", "复制链接", null),
      new OptionModel("分享", "分享", null),
    ];
    if (otherList != null && otherList.length > 0) {
      list.addAll(otherList);
    }
    return _renderHeaderPopItem(list);
  }
}

class OptionControl {
  String url = CustomTextStyle.app_default_share_url;
}

class OptionModel {
  final String name;
  final String value;
  final PopupMenuItemSelected<OptionModel> selected;
  OptionModel(this.name, this.value, this.selected);
}
