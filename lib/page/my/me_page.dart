/**
 *  author : archer
 *  date : 2019-06-18 11:24
 *  description :
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:codehub/widget/my/my_header_item.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';

enum UserType { individual,organization }

class MyPage extends StatefulWidget {
  static final String routeName = "my";
  final String userName;
  MyPage({this.userName, Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}



class _MyPageState extends State<MyPage> {

UserType userType = UserType.individual;

///根据type渲染item
_renderItem(index) {
  if (index == 0) {
    return MyHeaderItem();
  } else {

    ///个人帐号，显示个人event
    // if (userType == UserType.individual) {
      return _renderOrganizationItem(index);
    // } else {
    // ///组织帐号，显示组织成员
    //   return _renderOrganizationItem(index);
    // }
  }
}

_renderIndividualItem(index){
  return CardItem(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: UserIcon(
              image: "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  "username"
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  "time",
                  style: TextStyle(
                    color: Colors.grey
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            
          ],
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "event detailevent detailevent detailevent detailevent detailevent detail",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "other infomationother infomationother infomationother infomationother infomation",
            style: TextStyle(
              color: Colors.grey
            ),
            ),
        ),
      ],
    ),
  );
}
_renderOrganizationItem(index){
  return CardItem(
    margin: EdgeInsets.all(5),
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: UserIcon(
            image: "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            "username",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
            ),
        )
      ],
    ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return _renderItem(index);
        },
      ),
    );
  }
}
