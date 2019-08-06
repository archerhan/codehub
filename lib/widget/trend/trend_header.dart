/*
 * @Description: 趋势的头部，包含点击下拉
 * @Author: ArcherHan
 * @Date: 2019-08-05 10:35:49
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-06 11:35:45
 */

import 'package:flutter/material.dart';
import 'package:codehub/page/trending/trending_repositories_page.dart';
import 'package:codehub/common/constant/global_style.dart';

class TrendPopupHeader extends StatelessWidget {
  
  final List<Map<String,List<TrendTypeModel>>> dataList;
  final PopupMenuItemSelected<TrendTypeModel> onSelected;
  TrendPopupHeader(this.dataList,{this.onSelected});

  _renderHeaderItem(String data, List<TrendTypeModel> list){
    return new Expanded(
      child: new PopupMenuButton<TrendTypeModel>(
        child: new Center(
            child: new Text(data, style: TextStyle(color: Colors.white))),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return _renderPopupItem(list);
        },
      ),
    );
  }

  _renderPopupItem(List<TrendTypeModel> data){
    List<PopupMenuEntry<TrendTypeModel>> list = new List();
        for (TrendTypeModel item in data) {
      list.add(PopupMenuItem<TrendTypeModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }

  _renderHeader(){
    List<Widget> itemList = List();
    assert(itemList.length == 0,"itemList不能为空");

    for (var item in dataList) {
      Widget widget = _renderHeaderItem(item.keys.first, item.values.first);
      itemList.add(widget);
    }
    itemList.insert(1, Container(width: 1,height: 40,color: Colors.white,));
    return itemList;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(CustomColors.mainBackgroundColor),
      padding: EdgeInsets.all(5),
      child: Container(
        color: Colors.black,
        child: Row(
          children: _renderHeader(),
        ),
      ),
    );
  }
}