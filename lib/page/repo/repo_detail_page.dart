/**
 *  author : archer
 *  date : 2019-06-26 22:23
 *  description : 仓库详情
 */

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:codehub/page/repo/repo_detail_info_page.dart';
import 'package:codehub/page/repo/repo_detail_readme_page.dart';
import 'package:codehub/page/repo/repo_detail_issue_page.dart';
import 'package:codehub/page/repo/repo_detail_file_page.dart';
import 'package:codehub/widget/tabbar_page_widget.dart';
import 'package:codehub/common/model/repository.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/widget/custom_title_bar.dart';
import 'package:codehub/widget/animation/curves_bezier.dart';
import 'package:codehub/widget/custom_bottom_app_bar.dart';
import 'package:codehub/widget/icon_text_widget.dart';
import 'package:codehub/common/dao/repo_dao.dart';

class RepositoryDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetailPage(this.userName, this.reposName);
  @override
  _RepositoryDetailPageState createState() => _RepositoryDetailPageState();
}

class _RepositoryDetailPageState extends State<RepositoryDetailPage>
    with SingleTickerProviderStateMixin {
  ///仓库详情实体
  final ReposDetailModel reposDetailModel = ReposDetailModel();

  ///动画控制器，用于底部发布 issue 按键动画
  AnimationController animationController;

  /// 仓库底部状态，如 star、watch 控件的显示
  final TarWidgetControl tarBarControl = new TarWidgetControl();

  ///设置四个页面的key, 用于在当前页面控制相应页面的行为
  GlobalKey<RepoDetailInfoPageState> infoListKey = GlobalKey<RepoDetailInfoPageState>();
  GlobalKey<RepoDetailReadmePageState> readmeKey = GlobalKey<RepoDetailReadmePageState>();
  GlobalKey<RepoDetailIssuePageState> issueListKey = GlobalKey<RepoDetailIssuePageState>();
  GlobalKey<RepoDetailFilePageState> fileListKey = GlobalKey<RepoDetailFilePageState>();

  ///分支名字列表
  List<String> branchList = List();
  ///仓库底部状态
  BottomStatusModel bottomStatusModel;

  _getRepoStatus() async {
    var result = await ReposDao.getRepositoryStatusDao(widget.userName, widget.reposName);
    String watchText = result.data["watch"] ? "UnWatch" : "Watch";
    String starText = result.data["star"] ? "UnStar" : "Star";
    IconData watchIcon = result.data["watch"]
        ? CustomIcons.REPOS_ITEM_WATCHED
        : CustomIcons.REPOS_ITEM_WATCH;
    IconData starIcon = result.data["star"]
        ? CustomIcons.REPOS_ITEM_STARED
        : CustomIcons.REPOS_ITEM_STAR;
    BottomStatusModel model = BottomStatusModel(watchText, starText, watchIcon, starIcon, result.data["watch"], result.data["star"]);
    setState(() {
      bottomStatusModel = model;
      tarBarControl.footerButton = _getBottomWidget();
    });
  }

  ///获取分支数据
  _getBranchList() async {
    var result =
    await ReposDao.getBranchesDao(widget.userName, widget.reposName);
    if (result != null && result.result) {
      setState(() {
        branchList = result.data;
      });
    }
  }

  _refresh() {
    this._getRepoStatus();
  }
  ///顶部item
  _renderTabItems() {
    var itemList = ['动态', '详情', 'ISSUE', '文件'];
    renderItem(String item, int i) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          item,
          style: CustomTextStyle.smallTextWhite,
          maxLines: 1,
        ),
      );
    }

    List<Widget> list = List();
    for (int i = 0; i < itemList.length; i++) {
      list.add(renderItem(itemList[i], i));
    }
    return list;
  }

  ///底部widget
  _renderBottomItem(var text, var icon, var onPressed) {
    return FlatButton(
      child: IconTextWidget(
        icon,
        text,
        CustomTextStyle.smallText,
        Color(CustomColors.primaryValue),
        15.0,
        padding: 5.0,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  _getBottomWidget(){
    List<Widget> bottomWidget =
    <Widget>[
      ///star
      _renderBottomItem("Star", CustomIcons.REPOS_ITEM_STAR, null),
      ///watch
      _renderBottomItem("Watch", CustomIcons.REPOS_ITEM_WATCH, null),
      ///fork
      _renderBottomItem("Fork", CustomIcons.REPOS_ITEM_FORK, null),

    ];
    return bottomWidget;
  }

  @override
  void initState() {
    // TODO: implement initState

    ///悬浮按键动画控制器
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    animationController.forward();

    _refresh();
//    _getBranchList();
    tarBarControl.footerButton = _getBottomWidget();
  }

  @override
  Widget build(BuildContext context) {
    //跨tab共享状态
    return ScopedModel(
      model: reposDetailModel,
      child: ScopedModelDescendant<ReposDetailModel>(
        builder: (context, child, model) {
          return CustomTabBarWidget(
            type: CustomTabBarWidget.TOP_TAB,
            tabItems: _renderTabItems(),
            resizeToAvoidBottomPadding: false,
            tabViews: <Widget>[
              RepoDetailInfoPage(),
              RepoDetailReadmePage(),
              RepoDetailIssuePage(),
              RepoDetailFilePage()
            ],
            backgroundColor: CustomColors.primarySwatch,
            indicatorColor: Color(CustomColors.white),
            title: CustomTitleBar(
              widget.reposName,
//              rightWidget: ,//右侧点击下拉
            ),
            onPageChanged: (index) {
              reposDetailModel.setCurrentIndex(index);
            },
            floatingActionButton: ScaleTransition(
              scale: CurvedAnimation(
                parent: animationController,
                curve: CurveBezier(),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  print("发布新issue");
                },
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomBar: CustomBottomAppBar(
              color: Color(CustomColors.white),
              fabLocation: FloatingActionButtonLocation.endDocked,
              shape: CircularNotchedRectangle(),
              rowContents: (tarBarControl.footerButton == null)
                  ? [Container()]
                  : tarBarControl.footerButton.length == 0
                      ? [
                          SizedBox.fromSize(
                            size: Size(100, 50),
                          )
                        ]
                      : tarBarControl.footerButton,
            ),
          );
        },
      ),
    );
  }
}

class BottomStatusModel {
  final String watchText;
  final String starText;
  final IconData watchIcon;
  final IconData starIcon;
  final bool star;
  final bool watch;

  BottomStatusModel(this.watchText, this.starText, this.watchIcon,
      this.starIcon, this.watch, this.star);
}

///仓库详情数据实体，包含有当前index，仓库数据，分支等等
class ReposDetailModel extends Model {
  static ReposDetailModel of(BuildContext context) =>
      ScopedModel.of<ReposDetailModel>(context);
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  String _currentBranch = "master";
  String get currentBranch => _currentBranch;
  Repository _repository = Repository.empty();
  Repository get repository => _repository;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setCurrentBranch(String branch) {
    _currentBranch = branch;
    notifyListeners();
  }

  set repository(Repository data) {
    _repository = data;
    notifyListeners();
  }
}
