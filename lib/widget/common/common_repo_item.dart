/*
 * @Description: 仓库列表item
 * @Author: ArcherHan
 * @Date: 2019-08-01 18:56:10
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-06 10:33:59
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/model/repository.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/widget/common/icon_text_widget.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/route/route_manager.dart';

class RepoItem extends StatelessWidget {
  final RepoItemViewModel repoItemViewModel;
  final VoidCallback onPressed;

  RepoItem(this.repoItemViewModel, {this.onPressed});

  _renderUserIcon(context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: UserIcon(
              onPressed: () {
                RouteManager.goPerson(context, repoItemViewModel.ownerName);
              },
              height: 45,
              width: 45,
              image: repoItemViewModel.ownerPic ??
                  "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(repoItemViewModel.repositoryName ?? "--",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(repoItemViewModel.repositoryType ?? "--",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  ],
                ),
                IconTextWidget(
                    CustomIcons.USER_ITEM_COMPANY,
                    repoItemViewModel.ownerName ?? "--",
                    TextStyle(color: Colors.grey),
                    Colors.grey,
                    12)
              ],
            ),
          )
        ],
      ),
    );
  }

  _renderRepoDetail() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Text(
        repoItemViewModel.repositoryDes ?? "--",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  _renderBottomItem() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconTextWidget(
                CustomIcons.REPOS_ITEM_STAR,
                repoItemViewModel.repositoryStar ?? "0",
                TextStyle(color: Colors.grey),
                Colors.grey,
                16),
          ),
          Expanded(
            child: IconTextWidget(
                CustomIcons.REPOS_ITEM_FORK,
                repoItemViewModel.repositoryFork ?? "0",
                TextStyle(color: Colors.grey),
                Colors.grey,
                16),
          ),
          Expanded(
            child: IconTextWidget(
                CustomIcons.REPOS_ITEM_ISSUE,
                repoItemViewModel.repositoryIssues.split(" ").first ?? "0",
                TextStyle(color: Colors.grey),
                Colors.grey,
                16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardItem(
      margin: EdgeInsets.all(10),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _renderUserIcon(context),
            _renderRepoDetail(),
            _renderBottomItem()
          ],
        ),
      ),
    );
  }
}

class RepoItemViewModel {
  String ownerName;
  String ownerPic;
  String repositoryName;
  String repositoryStar;
  String repositoryFork;
  String repositoryIssues;
  String hideWatchIcon;
  String repositoryType = "";
  String repositoryDes;

  RepoItemViewModel();

  RepoItemViewModel.fromMap(Repository data) {
    ownerName = data.owner.login;
    ownerPic = data.owner.avatar_url;
    repositoryName = data.name;
    repositoryStar = data.watchersCount.toString();
    repositoryFork = data.forksCount.toString();
    repositoryIssues = data.openIssuesCount.toString();
    repositoryType = data.language ?? '---';
    repositoryDes = data.description ?? '---';
  }

  RepoItemViewModel.fromTrendMap(model) {
    ownerName = model.name;
    if (model.contributors.length > 0) {
      ownerPic = model.contributors[0];
    } else {
      ownerPic = "";
    }
    repositoryName = model.reposName;
    repositoryStar = model.starCount;
    repositoryFork = model.forkCount;
    repositoryIssues = model.meta;
    repositoryType = model.language;
    repositoryDes = model.description;
  }
}
