import 'package:flutter/material.dart';
import 'package:kwh/styles/app_colors.dart';
import 'package:kwh/styles/text_styles.dart';

class CustomWidget {
  static Widget buildSliverAppBar(String text,
      {Widget? leading, List<Widget>? actions}) {
    return SliverAppBar(
      expandedHeight: 80.0,
      pinned: true,
      leading: leading,
      actions: actions,
      backgroundColor: AppColors.AppSliverPrimaryColor,
      flexibleSpace: FlexibleSpaceBar(
        //伸展处布局
        centerTitle: false,
        title: Text(
          text,
          style: KTextStyle.appSliverTitle,
        ),
        titlePadding: const EdgeInsets.only(left: 15, bottom: 15),
        //标题边距
        collapseMode: CollapseMode.parallax,
        //视差效果
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground
        ],
      ),
    );
  }

  static Widget tag(String tagName) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(6),
      margin: EdgeInsets.only(left: 5),
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('#$tagName', style: const TextStyle(color: Colors.orange)),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            const Icon(
              Icons.close,
              size: 12,
            )
          ],
        ),
      ),
    );
  }

  static PopupMenuItem<String> buildPopupItem(String name, IconData _icon) {
    return PopupMenuItem<String>(
      value: name,
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          Icon(_icon, color: Colors.blue),
          Text(name),
        ],
      ),
    );
  }
}
