/**
 *  author : archer
 *  date : 2019-07-09 10:23
 *  description :
 */

import 'package:flutter/material.dart';
//import 'package:codehub/common/constant/global_config.dart';
//import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/common/constant/global_style.dart';

class CustomSearchBarWidget extends StatelessWidget {

  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  final VoidCallback onSubmitPressed;

  CustomSearchBarWidget(this.onChanged, this.onSubmitted, this.onSubmitPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.0), bottomLeft: Radius.circular(0.0)),
        color: Color(CustomColors.white),
        border: new Border.all(color: Theme.of(context).primaryColor, width: 0.3),
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColorDark,  blurRadius: 4.0)]
      ),
      padding: EdgeInsets.only(left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
      child: Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                  autofocus: false,
                  decoration: new InputDecoration.collapsed(
                    hintText: "搜索",
                    hintStyle: CustomTextStyle.middleSubText,
                  ),
                  style: CustomTextStyle.middleText,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted)),
          new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.only(right: 5.0, left: 10.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: new Icon(CustomIcons.SEARCH, size: 15.0, color: Theme.of(context).primaryColorDark,),
              onPressed: onSubmitPressed)
        ],
      ),
    );
  }
}
