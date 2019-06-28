/**
 *  author : archer
 *  date : 2019-06-28 11:45
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/common/constant/global_style.dart';

class WelcomePage extends StatefulWidget {
  static final String routeName = "/";
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    Store<MyState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    Future.delayed(Duration(seconds: 2, milliseconds: 500),(){
      UserDao.initUserInfo(store).then((res){
        if(res != null && res.result) {
          RouteManager.goHome(context);
        }
        else {
          RouteManager.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MyState>(
      builder: (context, store) {
        double size = 200.0;
        return Container(
          color: Color(CustomColors.white),
          child: Stack(
            children: <Widget>[
              Center(
                child: Image(image: AssetImage("resource/images/white_temple.jpg")),
              ),
            ],
          ),
        );
      },
    );
  }
}
