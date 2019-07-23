/**
 *  author : archer
 *  date : 2019-07-06 20:39
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/common/common_option_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CommonWebView extends StatelessWidget {
  final String url;
  final String title;
  final OptionControl optionControl = OptionControl();

  CommonWebView(this.url, this.title);

  _renderTitle() {
    if (url == null || url.length == 0) {
      return Text(title);
    }
    optionControl.url = url;
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        CommonOptionWidget(optionControl)
      ],
    );
  }

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      withJavascript: true,
      url: url,
      scrollBar: true,
      withLocalUrl: true,
      appBar: AppBar(
        title: _renderTitle(),
      ),
    );
  }
}
