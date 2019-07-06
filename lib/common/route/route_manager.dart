/**
 *  author : archer
 *  date : 2019-06-19 21:56
 *  description : 路由管理, 所有页面的路由控制
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:codehub/page/login/login_page.dart';
import 'package:codehub/page/root/root_page.dart';
import 'package:codehub/page/my/me_page.dart';
import 'package:codehub/common/route/size_route.dart';
import 'package:codehub/page/repo/repo_detail_page.dart';
import 'package:codehub/page/repo/push_detail_page.dart';
import 'package:codehub/page/issue/issue_detail_page.dart';
import 'package:codehub/page/common/common_list_page.dart';
import 'package:codehub/page/common/common_webview.dart';

class RouteManager {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
  ///主页(关注, 动态, 我的)
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, RootController.routeName);
  }
  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }
  ///个人中心
  static goPerson(BuildContext context, String userName) {
    NavigatorRouter(context, MyPage());
  }
  ///仓库详情
  static Future goReposDetail(
      BuildContext context, String userName, String reposName) {
    ///利用 SizeRoute 动画大小打开
    return Navigator.push(
        context,
        new SizeRoute(
            widget: pageContainer(RepositoryDetailPage(userName, reposName))));
  }

  ///提交详情
  static Future goPushDetailPage(BuildContext context, String userName,
      String reposName, String sha, bool needHomeIcon) {
    return NavigatorRouter(
        context,
        new PushDetailPage(
          sha,
          userName,
          reposName,
          needHomeIcon: needHomeIcon,
        ));
  }

  ///issue详情
  static Future goIssueDetail(
      BuildContext context, String userName, String reposName, String num,
      {bool needRightLocalIcon = false}) {
    return NavigatorRouter(
        context,
        new IssueDetailPage(
          userName,
          reposName,
          num,
          needHomeIcon: needRightLocalIcon,
        ));
  }



  ///公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => pageContainer(widget)));
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget) {
    return MediaQuery(

      ///不受系统字体缩放影响
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: widget);
  }

  ///通用列表
  static gotoCommonList(
      BuildContext context, String title, String showType, String dataType,
      {String userName, String reposName}) {
    NavigatorRouter(
        context,
        CommonListPage(
          title,
          showType,
          dataType,
          userName: userName,
          reposName: reposName,
        ));
  }

  static Future goWebView(BuildContext context, String url, String title){
    return NavigatorRouter(context, CommonWebView(url, title));
  }
}