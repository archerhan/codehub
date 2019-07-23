/**
 *  author : archer
 *  date : 2019-07-06 20:08
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/utils/syntax_high_lighter.dart';
import 'package:codehub/common/utils/common_utils.dart';

class CommonMarkdownWidget extends StatelessWidget {
  static const int DARK_WHITE = 0;

  static const int DARK_LIGHT = 1;

  static const int DARK_THEME = 2;

  final String markdownData;

  final int style;

  CommonMarkdownWidget({this.markdownData = "", this.style = DARK_WHITE});

  _getCommonSheet(BuildContext context, Color codeBackground) {
    MarkdownStyleSheet markdownStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context));
    return markdownStyleSheet
        .copyWith(
            codeblockDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: codeBackground,
                border: new Border.all(
                    color: Color(CustomColors.subTextColor), width: 0.3)))
        .copyWith(
            blockquoteDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(CustomColors.subTextColor),
                border: new Border.all(
                    color: Color(CustomColors.subTextColor), width: 0.3)),
            blockquote: CustomTextStyle.smallTextWhite);
  }

  _getStyleSheetDark(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: CustomTextStyle.smallTextWhite,
      h1: CustomTextStyle.largeLargeTextWhite,
      h2: CustomTextStyle.largeTextWhiteBold,
      h3: CustomTextStyle.normalTextMitWhiteBold,
      h4: CustomTextStyle.middleTextWhite,
      h5: CustomTextStyle.smallTextWhite,
      h6: CustomTextStyle.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: CustomTextStyle.middleTextWhiteBold,
      code: CustomTextStyle.smallSubText,
    );
  }

  _getStyleSheetWhite(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: CustomTextStyle.smallText,
      h1: CustomTextStyle.largeLargeText,
      h2: CustomTextStyle.largeTextBold,
      h3: CustomTextStyle.normalTextBold,
      h4: CustomTextStyle.middleText,
      h5: CustomTextStyle.smallText,
      h6: CustomTextStyle.smallText,
      strong: CustomTextStyle.middleTextBold,
      code: CustomTextStyle.smallSubText,
    );
  }

  _getStyleSheetTheme(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: CustomTextStyle.smallTextWhite,
      h1: CustomTextStyle.largeLargeTextWhite,
      h2: CustomTextStyle.largeTextWhiteBold,
      h3: CustomTextStyle.normalTextMitWhiteBold,
      h4: CustomTextStyle.middleTextWhite,
      h5: CustomTextStyle.smallTextWhite,
      h6: CustomTextStyle.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: CustomTextStyle.middleTextWhiteBold,
      code: CustomTextStyle.smallSubText,
    );
  }

  _getBackgroundColor(context) {
    Color background = Color(CustomColors.white);
    switch (style) {
      case DARK_LIGHT:
        background = Color(CustomColors.primaryLightValue);
        break;
      case DARK_THEME:
        background = Theme.of(context).primaryColor;
        break;
    }
    return background;
  }

  _getStyle(BuildContext context) {
    var styleSheet = _getStyleSheetWhite(context);
    switch (style) {
      case DARK_LIGHT:
        styleSheet = _getStyleSheetDark(context);
        break;
      case DARK_THEME:
        styleSheet = _getStyleSheetTheme(context);
        break;
    }
    return styleSheet;
  }

  _getMarkDownData(String markdownData) {
    ///优化图片显示
    RegExp exp = new RegExp(r'!\[.*\]\((.+)\)');
    RegExp expImg = new RegExp("<img.*?(?:>|\/>)");
    RegExp expSrc = new RegExp("src=[\'\"]?([^\'\"]*)[\'\"]?");

    String mdDataCode = markdownData;
    try {
      Iterable<Match> tags = exp.allMatches(markdownData);
      if (tags != null && tags.length > 0) {
        for (Match m in tags) {
          String imageMatch = m.group(0);
          if (imageMatch != null && !imageMatch.contains(".svg")) {
            String match = imageMatch.replaceAll("\)", "?raw=true)");
            if (!match.contains(".svg") && match.contains("http")) {
              ///增加点击
              String src = match
                  .replaceAll(new RegExp(r'!\[.*\]\('), "")
                  .replaceAll(")", "");
              String actionMatch = "[$match]($src)";
              match = actionMatch;
            } else {
              match = "";
            }
            mdDataCode = mdDataCode.replaceAll(m.group(0), match);
          }
        }
      }

      ///优化img标签的src资源
      tags = expImg.allMatches(markdownData);
      if (tags != null && tags.length > 0) {
        for (Match m in tags) {
          String imageTag = m.group(0);
          String match = imageTag;
          if (imageTag != null) {
            Iterable<Match> srcTags = expSrc.allMatches(imageTag);
            for (Match srcMatch in srcTags) {
              String srcString = srcMatch.group(0);
              if (srcString != null && srcString.contains("http")) {
                String newSrc = srcString.substring(
                        srcString.indexOf("http"), srcString.length - 1) +
                    "?raw=true";

                ///增加点击
                match = "[![]($newSrc)]($newSrc)";
              }
            }
          }
          mdDataCode = mdDataCode.replaceAll(imageTag, match);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return mdDataCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      padding: EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: new MarkdownBody(
          styleSheet: _getStyle(context),
          syntaxHighlighter: new Highlighter(),
          data: _getMarkDownData(markdownData),
          onTapLink: (String source) {
            CommonUtils.launchUrl(context, source);
          },
        ),
      ),
    );
  }
}

class Highlighter extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    String showSource = source.replaceAll("&lt;", "<");
    showSource = showSource.replaceAll("&gt;", ">");
    return new DartSyntaxHighlighter().format(showSource);
  }
}
