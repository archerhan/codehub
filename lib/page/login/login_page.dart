/**
 *  author : archer
 *  date : 2019-06-19 17:43
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:codehub/common/route/route_manager.dart';



class LoginPage extends StatefulWidget {
  static final String routeName = "login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MyState>(
      builder: (context, store) {
        return Scaffold(
          body: Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      child: Form(
                        key: _formKey, //设置globalKey，用于后面获取FormState
                        autovalidate: true, //打开自动校验
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autofocus: true,
                              controller: _unameController,
                              decoration: InputDecoration(
                                  labelText: "账号",
                                  hintText: "邮箱地址",
                                  icon: Icon(Icons.person)),
                              validator: (v) {
                                return v.trim().length > 0 ? null : "请输入账号";
                              },
                            ),
                            TextFormField(
                              autofocus: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: "密码",
                                  hintText: "登录密码",
                                  icon: Icon(Icons.lock)),
                              obscureText: true,
                              validator: (v) {
                                return v.trim().length > 5 ? null : "密码不能少于6位";
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                      child: Text("登录"),
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if ((_formKey.currentState as FormState)
                                            .validate()) {
                                          UserDao.login(
                                                  _unameController.text.trim(),
                                                  _passwordController.text
                                                      .trim(), store)
                                              .then((res) {
                                            if (res != null && res.result){
                                              Future.delayed(Duration(seconds: 1),(){
                                                RouteManager.goHome(context);
                                                return true;
                                              });
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            color: Colors.black,
          ),
        );
      },
    );
  }
}
