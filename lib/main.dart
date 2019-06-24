import 'package:flutter/material.dart';
import 'package:codehub/page/root/root_page.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:redux/redux.dart';
import 'package:codehub/common/model/user.dart';
import 'package:flutter_redux/flutter_redux.dart';


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
        builder: (context, store){
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: RootController(),
          );
        },
      ),
    );
  }
}