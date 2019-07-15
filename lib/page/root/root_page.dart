/**
 *  author : archer
 *  date : 2019-06-18 11:24
 *  description : 根控制器, 包括appbar, bottom navigation bar, 子控制器等
 */

import 'package:flutter/material.dart';
import 'package:codehub/page/root/drawer_page.dart';
import 'package:codehub/page/follow/my_follow_page.dart';
import 'package:codehub/page/trending/trending_repositories_page.dart';
import 'package:codehub/page/my/me_page.dart';
import 'package:codehub/page/login/login_page.dart';


class RootController extends StatefulWidget {
  static final String routeName = "home";
  @override
  _RootControllerState createState() => _RootControllerState();
}

class _RootControllerState extends State<RootController>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver
{

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('关注')
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.search),
        title: new Text('趋势'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          title: Text('我的')
      )
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        MyFollowPage(),
        TrendingRepositories(),
        MyPage(),
      ],
    );
  }
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        print("paused");
        break;
      case AppLifecycleState.suspending:
        print("suspending");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("标题"),
      ),
      drawer: MyDrawer(),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}




