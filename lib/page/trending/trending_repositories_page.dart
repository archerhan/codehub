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

  ///bloc
  final TrendBloc trendBloc = new TrendBloc();

  _renderItem(e) {
    RepoItemViewModel repoItemViewModel = RepoItemViewModel.fromTrendMap(e);
    return RepoItem(repoItemViewModel);
  }

  Future<void> onRefresh() async {
    return trendBloc.reqeustRefresh(selectTime, selectType);
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
    List<Map<String,List<TrendTypeModel>>> data = [{"今日":trendTime(context)},{"全部":trendType(context)}];
    
    return StoreBuilder<MyState>(
      builder: (context, store) {
        return Scaffold(
          backgroundColor: Color(CustomColors.mainBackgroundColor),
          body: StreamBuilder(
            stream: trendBloc.stream,
            builder: (context, snapShot) {
              return EasyRefresh(
                autoLoad: true,
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
                          print(model.value);
                          // selectTime = 
                          onRefresh();
                        },),
                      ),

                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _renderItem(snapShot.data[index]);
                        },
                        childCount: snapShot.data.length,
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
