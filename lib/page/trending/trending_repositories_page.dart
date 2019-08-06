/**
 *  author : archer
 *  date : 2019-06-18 11:23
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/common/common_repo_item.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/widget/trend/trend_header.dart';
import 'package:codehub/widget/repo/sliver_header_delegate.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/bloc/trend_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:codehub/common/route/route_manager.dart';

class TrendingRepositories extends StatefulWidget {
  @override
  _TrendingRepositoriesState createState() => _TrendingRepositoriesState();
}

class _TrendingRepositoriesState extends State<TrendingRepositories>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ///显示数据时间
  TrendTypeModel selectTime;

  ///显示过滤语言
  TrendTypeModel selectType;

  ///刷新控件，主动刷新
  EasyRefreshController _controller;

  String timeStr = "今日";
  String lanStr = "全部"; 

  ///bloc
  final TrendBloc trendBloc = new TrendBloc();

  _renderItem(e) {
    RepoItemViewModel repoItemViewModel = RepoItemViewModel.fromTrendMap(e);
    return RepoItem(repoItemViewModel,onPressed: (){
      RouteManager.goReposDetail(context, repoItemViewModel.ownerName, repoItemViewModel.repositoryName);
    },);
  }

  Future<void> onRefresh() async {
    return trendBloc.reqeustRefresh(selectTime, selectType);
  }
@override
  void initState() {
     _controller = EasyRefreshController();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (!trendBloc.requested) {
      setState(() {
        selectTime = trendTime(context)[0];
        selectType = trendType(context)[0];
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Map<String,List<TrendTypeModel>>> data = [{timeStr:trendTime(context)},{lanStr:trendType(context)}];
    
    return StoreBuilder<MyState>(
      builder: (context, store) {
        return Scaffold(
          backgroundColor: Color(CustomColors.mainBackgroundColor),
          body: StreamBuilder(
            stream: trendBloc.stream,
            builder: (context, snapShot) {
              return EasyRefresh(
                controller: _controller,
                firstRefresh: true,
                onRefresh: onRefresh,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverHeaderDelegate(
                        minHeight: 80,
                        maxHeight: 80,
                        snapConfig: FloatingHeaderSnapConfiguration(
                          vsync:this,
                          curve: Curves.bounceInOut,
                          duration: const Duration(milliseconds: 10),
                        ),
                        child: TrendPopupHeader(data,onSelected: (model){
                          // print(model.name);
                          
                          for (TrendTypeModel item in trendTime(context)) {
                            if (model.value == item.value) {
                              selectTime = model;
                              timeStr = model.name;
                            }
                          }
                          for (TrendTypeModel item in trendType(context)) {
                            if (model.value == item.value) {
                              selectType = model;
                              lanStr = model.name;
                            }
                          }
                          setState(() {
                            
                          });
                          _controller.callRefresh();
                        },),
                      ),

                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _renderItem(snapShot.data[index]);
                        },
                        childCount: snapShot.hasData ? snapShot.data.length : 0,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///趋势数据过滤显示item
class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}

///趋势数据时间过滤
trendTime(BuildContext context) {
  return [
    new TrendTypeModel("每日", "daily"),
    new TrendTypeModel("每周", "weekly"),
    new TrendTypeModel("每月", "monthly"),
  ];
}

///趋势数据语言过滤
trendType(BuildContext context) {
  return [
    TrendTypeModel("全部", null),
    TrendTypeModel("Java", "Java"),
    TrendTypeModel("Kotlin", "Kotlin"),
    TrendTypeModel("Dart", "Dart"),
    TrendTypeModel("Objective-C", "Objective-C"),
    TrendTypeModel("Swift", "Swift"),
    TrendTypeModel("JavaScript", "JavaScript"),
    TrendTypeModel("PHP", "PHP"),
    TrendTypeModel("Go", "Go"),
    TrendTypeModel("C++", "C++"),
    TrendTypeModel("C", "C"),
    TrendTypeModel("HTML", "HTML"),
    TrendTypeModel("CSS", "CSS"),
    TrendTypeModel("Python", "Python"),
    TrendTypeModel("C#", "c%23"),
  ];
}
