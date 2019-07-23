import 'package:flutter/material.dart';
import 'package:codehub/page/root/root_page.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:redux/redux.dart';
import 'package:codehub/common/model/user.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:codehub/page/login/login_page.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/page/welcome/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ///创建store
  final store = Store<MyState>(
    appReducer,
    middleware: middleware,

    ///初始化数据
    initialState: MyState(
      userInfo: User.empty(),
    ),
  );

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<MyState>(
        builder: (context, store) {
          return MaterialApp(
            title: 'codehub',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: {
              WelcomePage.routeName: (context) {
                return WelcomePage();
              },
              RootController.routeName: (context) {
                return RouteManager.pageContainer(RootController());
              },
              LoginPage.routeName: (context) {
                return RouteManager.pageContainer(LoginPage());
              }
            },
          );
        },
      ),
    );
  }
}
