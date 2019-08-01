/**
 *  author : archer
 *  date : 2019-07-01 22:36
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/widget/repo/card_item.dart';

typedef void SelectItemChanged<int>(int value);

class SelectItemWidget extends StatefulWidget implements PreferredSizeWidget {
  final List<String> itemNames;

  final SelectItemChanged selectItemChanged;

  final RoundedRectangleBorder shape;

  final double elevation;

  final double height;

  final EdgeInsets margin;
  SelectItemWidget(
    this.itemNames,
    this.selectItemChanged, {
    this.elevation = 5.0,
    this.height = 70.0,
    this.shape,
    this.margin = const EdgeInsets.all(10.0),
  });
  @override
  _SelectItemWidgetState createState() => _SelectItemWidgetState();

  @override
  Size get preferredSize {
    return Size.fromHeight(height);
  }
}

class _SelectItemWidgetState extends State<SelectItemWidget> {
  int selectIndex = 0;
  _SelectItemWidgetState();

  _renderItem(String name, int index) {
    var style = index == selectIndex
        ? CustomTextStyle.middleTextWhite
        : CustomTextStyle.middleSubLightText;
    return new Expanded(
      child: RawMaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          padding: EdgeInsets.all(10.0),
          child: new Text(
            name,
            style: style,
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            if (selectIndex != index) {
              widget.selectItemChanged?.call(index);
            }
            setState(() {
              selectIndex = index;
            });
          }),
    );
  }

  _renderList() {
    List<Widget> list = new List();
    for (int i = 0; i < widget.itemNames.length; i++) {
      if (i == widget.itemNames.length - 1) {
        list.add(_renderItem(widget.itemNames[i], i));
      } else {
        list.add(_renderItem(widget.itemNames[i], i));
        list.add(new Container(
            width: 1.0,
            height: 25.0,
            color: Color(CustomColors.subLightTextColor)));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new CardItem(
        elevation: widget.elevation,
        margin: widget.margin,
        color: Theme.of(context).primaryColor,
        shape: widget.shape ??
            new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
        child: new Row(
          children: _renderList(),
        ));
  }
}
