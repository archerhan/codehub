/**
 *  author : archer
 *  date : 2019-06-18 11:24
 *  description : 根控制器, 包括appbar, bottom navigation bar, 子控制器等
 */

import 'package:flutter/material.dart';


class RootController extends StatefulWidget {
  @override
  _RootControllerState createState() => _RootControllerState();
}

class _RootControllerState extends State<RootController> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("标题"),
      ),
//      drawer: ,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add),title: Text("关注")),
          BottomNavigationBarItem(icon: Icon(Icons.store),title: Text("趋势")),
          BottomNavigationBarItem(icon: Icon(Icons.person),title: Text("我的")),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}



