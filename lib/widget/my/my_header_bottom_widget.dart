/*
 * @Description: 个人中心header底部数据展示部件
 * @Author: ArcherHan
 * @Date: 2019-08-01 10:17:50
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-01 16:53:58
 */

import 'package:flutter/material.dart';

///自定义一个带参数的回调
typedef void SelectItem<int>(int value);

class MyHeaderBottomWidget extends StatelessWidget {
  final List<Map<String, String>> dataList;
  final SelectItem onPressed;
  MyHeaderBottomWidget(this.dataList, {this.onPressed});
  _renderSingleItem(Map<String, String> itemData, int index) {
    return RawMaterialButton(
      onPressed: () {
        onPressed?.call(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            itemData.keys.first,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              itemData.values.first ?? "0",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  _renderMultiItems() {
    List<Widget> list = List();
    for (var i = 0; i < dataList.length; i++) {
      Widget widget = _renderSingleItem(dataList[i], i);

      list.add(Expanded(child: widget));
    }
    list.insert(
        1,
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ));
    list.insert(
        3,
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ));
    list.insert(
        5,
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ));
            list.insert(
        7,
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _renderMultiItems(),
      ),
    );
  }
}
