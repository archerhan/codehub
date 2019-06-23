/**
 *  author : archer
 *  date : 2019-06-18 21:33
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/page/login/login_page.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<String> _titles = [
    "问题反馈",
    "阅读历史",
    "个人信息",
    "切换主题",
    "语言切换",
    "检测更新",
    "关于",
    loadingTag
  ];

  static const loadingTag = "##loading##"; //表尾标记

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide.none
                          ),
                          image: DecorationImage(
                            image: AssetImage("resource/images/snow_sun.jpg"),
                            fit: BoxFit.fill
                          ),
                        ),
                      )
//                      child: Container(
//                        width: 80.0,
//                        height: 80.0,
//                        decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          image: DecorationImage(
//                              image: AssetImage("resource/images/valley.jpg"),
//                              fit: BoxFit.cover)
//                        ),
//                      ),

//                    child: ClipOval(
//                      child: Image.asset("resource/images/valley.jpg",width: 80,),
//                    ),
//                    child: CircleAvatar(
//                      backgroundImage: AssetImage("resource/images/stars.jpg"),
//                      radius: 80,
//                    ),
                  ),
                  Text(
                    "ArcherHan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (_titles[index] == loadingTag) {
                    return Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: RaisedButton(
                          child: Text("退出登录"),
                          onPressed: () {
                            Navigator.push(context, PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (BuildContext context, Animation animation,
                                  Animation secondaryAnimation){
                                  return FadeTransition(
                                    opacity: animation,
                                    child: LoginPage(),
                                  );
                              }

                            ));
                            print("退出登录");
                          },
                        ));
                  }
                  return ListTile(
                    title: Text(_titles[index]),
                  );
                },
                itemCount: _titles.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
