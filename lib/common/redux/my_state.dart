/**
 *  author : archer
 *  date : 2019-06-24 11:01
 *  description : redux 全局state
 */

import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/redux/middleware/epic_middleware.dart';
import 'package:codehub/common/redux/user_redux.dart';
import 'package:redux/redux.dart';

class MyState {
  User userInfo;
  MyState({this.userInfo});
}

///创建 Reducer
///源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
///我们自定义了 appReducer 用于创建 store
MyState appReducer(MyState state, action) {
  return MyState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),
  );
}

final List<Middleware<MyState>> middleware = [
  EpicMiddleware<MyState>(UserInfoEpic()),
  UserInfoMiddleware(),
];
