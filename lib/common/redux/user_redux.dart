/**
 *  author : archer
 *  date : 2019-06-24 11:07
 *  description : 用户相关redux
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/redux/middleware/epic.dart';
import 'package:codehub/common/redux/middleware/epic_store.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:codehub/common/redux/my_state.dart';

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final UserReducer = combineReducers<User>([
  TypedReducer<User, UpdateUserAction>(_updateLoaded),
]);

/// 如果有 UpdateUserAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的userInfo，并返回
User _updateLoaded(User user, action) {
  user = action.userInfo;
  return user;
}

class FetchUserAction {

}

///定一个 UpdateUserAction ，用于发起 userInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateUserAction {
  final User userInfo;
  UpdateUserAction(this.userInfo);
}

class UserInfoMiddleware implements MiddlewareClass<MyState> {

  @override
  void call(Store<MyState> store, dynamic action, NextDispatcher next) {
    if (action is UpdateUserAction) {
      print("*********** UserInfoMiddleware *********** ");
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

class UserInfoEpic implements EpicClass<MyState> {
  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<MyState> store) {
    return Observable(actions)
    // to UpdateUserAction actions
        .ofType(TypeToken<FetchUserAction>())
    // Don't start  until the 10ms
        .debounce(((_) => TimerStream(true, const Duration(milliseconds: 10))))
        .switchMap((action) => _loadUserInfo());
  }

  // Use the async* function to make easier
  Stream<dynamic> _loadUserInfo() async* {
    print("*********** userInfoEpic _loadUserInfo ***********");
    var res = await UserDao.getUserInfo(null);
    yield UpdateUserAction(res.data);
  }
}