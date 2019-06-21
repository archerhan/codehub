/**
 *  author : archer
 *  date : 2019-06-19 17:43
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/local/local_storage.dart';
import 'package:codehub/common/constant/global_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var _uname = "";
  var _pwd = "";
  TextEditingController _unameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _uname = LocalStorage.get(GlobalConfig.USER_ACCOUNT_KEY);
    _pwd = LocalStorage.get(GlobalConfig.USER_PWD_KEY);
    _unameController.value = TextEditingValue(text: _uname ?? "");
    _passwordController.value = TextEditingValue(text: _pwd ?? "");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Form(
                  key: _formKey,//设置globalKey，用于后面获取FormState
                  autovalidate: true,//打开自动校验
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        controller: _unameController,
                        decoration: InputDecoration(
                            labelText: "账号",
                            hintText: "邮箱地址",
                            icon: Icon(Icons.person)
                        ),
                        validator: (v){
                          return v
                              .trim()
                              .length > 0 ? null : "请输入账号";
                        },
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: "密码",
                            hintText: "登录密码",
                            icon: Icon(Icons.lock)
                        ),
                        obscureText: true,
                        validator: (v){
                          return v
                              .trim()
                              .length > 5 ? null : "密码不能少于6位";
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
                                  if ((_formKey.currentState as FormState).validate()) {
                                    print("$_unameController.text,$_passwordController.text");
                                    UserDao.login(_unameController.text, _passwordController.text).then((res) {
                                      print(res);
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
              )
          ),
        ),
      ),
      color: Colors.black,
    );
  }
}


