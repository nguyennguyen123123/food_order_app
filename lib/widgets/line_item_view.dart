import 'package:flutter/material.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class LineItemView extends StatelessWidget {
  const LineItemView({Key? key, this.title = '', this.content = '', this.titleStyle, this.contentStyle})
      : super(key: key);

  final String title;
  final String content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: titleStyle ?? StyleThemeData.bold16()),
        SizedBox(width: 12.w),
        Expanded(
            child: Text(
          content,
          style: contentStyle ?? StyleThemeData.regular16(),
          textAlign: TextAlign.end,
        ))
      ],
    );
  }
}
