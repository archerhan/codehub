/**
 *  author : archer
 *  date : 2019-06-19 09:47
 *  description :
 */

import 'package:flutter/material.dart';

class TabbarPageWidget extends StatefulWidget {

  TabbarPageWidget({
    Key key,
    this.type,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.floatingActionButton,
    this.tarWidgetControl,
    this.topPageControl,
  }) : super(key: key);
  //tabbar在底部
  static const int BOTTOM_TAB = 1;
  //tabbar在顶部
  static const int TOP_TAB = 2;
  //类型
  final int type;
  //按钮item
  final List<Widget> tabItems;
  //页面
  final List<Widget> tabViews;
  final Color backgroundColor;
  //指示条颜色
  final Color indicatorColor;

  final Widget title;
  //抽屉
  final Widget drawer;

  final Widget floatingActionButton;

  final TarWidgetControl tarWidgetControl;

  final PageController topPageControl;


  @override
  _TabbarPageWidgetState createState() => _TabbarPageWidgetState(
      type,
      tabItems,
      tabViews,
      backgroundColor,
      indicatorColor,
      title,
      drawer,
      floatingActionButton,
      topPageControl
  );
}

class _TabbarPageWidgetState extends State<TabbarPageWidget> with SingleTickerProviderStateMixin{

  _TabbarPageWidgetState(
      this._type,
      this._tabItems,
      this._tabViews,
      this._backgroundColor,
      this._indicatorColor,
      this._title,
      this._drawer,
      this._floatingActionButton,
      this._pageController)
      : super();
  final int _type;

  final List<Widget> _tabItems;

  final List<Widget> _tabViews;

  final Color _backgroundColor;

  final Color _indicatorColor;

  final Widget _title;

  final Widget _drawer;

  final Widget _floatingActionButton;

  final PageController _pageController;


  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabItems.length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    if (this._type == TabbarPageWidget.TOP_TAB) {
      return Scaffold(
        appBar: AppBar(
          title: _title,
          backgroundColor: _backgroundColor,
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: _tabItems,
            indicatorColor: _indicatorColor,
          ),
        ),
        drawer: _drawer,
        floatingActionButton: _floatingActionButton,
        body: PageView(
          controller: _pageController,
          children: _tabViews,
          onPageChanged: (index){
            _tabController.animateTo(index);
          },
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: _title,
          backgroundColor: _backgroundColor,
        ),
        drawer: _drawer,
        floatingActionButton: _floatingActionButton,
        body: PageView(
          controller: _pageController,
          children: _tabViews,
          onPageChanged: (index) {
            _tabController.animateTo(index);
          },
        ),
        bottomNavigationBar: Material(
          color: _backgroundColor,
          child: TabBar(
            controller: _tabController,
            tabs: _tabItems,
            indicatorColor: _indicatorColor,
          ),
        ),
      );
    }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}


class TarWidgetControl {
  List<Widget> footerButton = [];
}