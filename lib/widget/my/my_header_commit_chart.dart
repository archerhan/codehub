/*
 * @Description: 个人中心提交图表
 * @Author: ArcherHan
 * @Date: 2019-08-01 15:43:56
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-01 16:38:56
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyHeaderCommitChart extends StatelessWidget {
  final User userInfo;
  MyHeaderCommitChart(this.userInfo);

  _renderCommitChart(context) {
    double height = 140.0;
    double width = 3 * MediaQuery.of(context).size.width / 2;
    //组织没有提交图
    if (userInfo.login != null && userInfo.type == "Organization") {
      return Container();
    }
    return userInfo.login != null
        ? Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: width,
                height: height,
                child: SvgPicture.network(
                  CommonUtils.getUserChartAddress(userInfo.login),
                  width: width,
                  height: height - 10,
                  allowDrawingOutsideViewBox: true,
                  placeholderBuilder: (BuildContext context) => Container(
                    height: height,
                    width: width,
                    child: Center(
                      child: SpinKitRipple(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: height,
            child: Center(
              child: SpinKitRipple(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              child: new Text(
                (userInfo.type == "Organization") ? "组织成员" : "个人动态",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              margin: new EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0),
              alignment: Alignment.topLeft),
          _renderCommitChart(context)
        ],
      ),
    );
  }
}
