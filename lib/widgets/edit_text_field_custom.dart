import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/theme/style/style_theme.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/text_field_custom.dart';
import 'package:get/get.dart';

class EditTextFieldCustom extends StatelessWidget {
  const EditTextFieldCustom(
      {Key? key,
      required this.label,
      required this.controller,
      this.items = const [],
      this.mapItems = const {},
      this.isDropDown = false,
      this.onTap,
      this.labelStyle,
      this.canEdit = true,
      this.onItemSelected,
      this.emptyNotifier,
      this.errorText = '',
      this.isShowErrorText = false,
      this.textInputType,
      this.isSecure = false,
      this.suffix,
      this.maxLength,
      this.isObscure = false,
      this.hintText = ''})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final String hintText;
  final List<String> items;
  final bool isSecure;
  final Widget? suffix;
  final int? maxLength;

  /// this item use for display value but return key
  final Map<String, String> mapItems;
  final bool isDropDown;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;
  final bool canEdit;
  final ValueNotifier<bool>? emptyNotifier;
  final void Function(String item)? onItemSelected;
  final String errorText;
  final bool isShowErrorText;
  final TextInputType? textInputType;
  final bool isObscure;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle ?? StyleThemeData.bold14()),
        SizedBox(height: 4.h),
        if (isDropDown && (items.isNotEmpty || mapItems.isNotEmpty)) ...[
          DropdownMenu(
            hintText: hintText,
            controller: controller,
            menuHeight: 200.h,
            enableSearch: false,
            textStyle: StyleThemeData.regular16(),
            width: Get.width - 48.w,
            // trailingIcon: _buildIcon(),
            // selectedTrailingIcon: _buildIcon(),
            inputDecorationTheme: InputDecorationTheme(contentPadding: padding(vertical: 16, horizontal: 12)),
            // onSelected: (index) => items.isNotEmpty
            //     ? onItemSelected?.call(items[index ?? 0])
            //     : onItemSelected?.call(mapItems.keys.elementAt(index ?? 0)),
            // menuStyle: MenuStyle(surfaceTintColor: MaterialStateProperty.all(AppTheme.color.white)),
            dropdownMenuEntries: items.isNotEmpty
                ? List.generate(items.length, (index) => DropdownMenuEntry(label: items[index], value: index))
                : List.generate(mapItems.length,
                    (index) => DropdownMenuEntry(label: mapItems.values.elementAt(index), value: index)),
          )
        ] else ...[
          TextFieldCustom(
            controller: controller,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintStyle: StyleThemeData.regular16(),
            contentPadding: padding(vertical: 16, horizontal: 12),
            hintText: hintText,
            onTap: onTap,
            canEdit: canEdit,
            textInputType: textInputType,
            obscureText: isObscure,
            formatter: [if (maxLength != null) LengthLimitingTextInputFormatter(maxLength)],
            suffix: suffix ??
                (isDropDown && items.isEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        // children: [_buildIcon(), SizedBox(width: 16.w)],
                      )
                    : null),
          )
        ],
        if (emptyNotifier != null && isShowErrorText) ...[
          ValueListenableBuilder<bool>(
            valueListenable: emptyNotifier!,
            builder: (context, value, child) {
              return Visibility(
                  visible: value, child: Text(errorText, style: StyleThemeData.regular14(color: appTheme.rejectColor)));
            },
          )
        ]
      ],
    );
  }

  // Widget _buildIcon() {
  //   return Padding(
  //     padding: padding(right: 16),
  //     child: Transform.rotate(
  //       angle: -pi / 2,
  //       child: SvgImageCustom(
  //         imagePath: ImagePaths.back_arrow,
  //         height: width(18),
  //         width: width(24),
  //         color: AppTheme.color.black4,
  //       ),
  //     ),
  //   );
  // }
}
