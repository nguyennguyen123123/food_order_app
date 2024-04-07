import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:food_delivery_app/widgets/search/search_controller.dart' as search;

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    Key? key,
    this.hintText,
    this.hintStyle,
    this.leading,
    required this.onGetSearchValue,
    this.getSearchStatus,
    this.prefixConstraints,
    this.textFieldConstraints,
    this.style,
    this.isDisposeTextCtrl = true,
    this.textEditingController,
    this.focusNode,
    this.suffix,
    this.suffixConstraints,
  }) : super(key: key);
  final TextEditingController? textEditingController;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? leading;
  final void Function(String keyword) onGetSearchValue;
  final void Function(bool value)? getSearchStatus;
  final BoxConstraints? textFieldConstraints;
  final BoxConstraints? prefixConstraints;
  final TextStyle? style;
  final bool isDisposeTextCtrl;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final FocusNode? focusNode;
  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final controller = widget.textEditingController ?? TextEditingController();
  late final _searchCtrl =
      search.SearchController(onGetValue: widget.onGetSearchValue, updateSearchingStatus: widget.getSearchStatus);

  @override
  void dispose() {
    controller.dispose();
    if (widget.isDisposeTextCtrl) _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _searchCtrl.searchStream,
      builder: (context, snapshot) => TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        onChanged: _searchCtrl.insertNewText,
        cursorHeight: 18,
        style: widget.style,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
            prefixIcon: widget.leading ?? Transform.scale(scale: .4, child: Icon(Icons.search)),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            fillColor: appTheme.blackColor.withOpacity(0.05),
            suffix: widget.suffix,
            suffixIconConstraints: widget.suffixConstraints,
            filled: true,
            constraints: widget.textFieldConstraints,
            prefixIconConstraints: widget.prefixConstraints,
            contentPadding: padding(all: 0, horizontal: 18),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: appTheme.rejectColor, width: 1)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: appTheme.rejectColor, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(style: BorderStyle.none)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(style: BorderStyle.none)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(style: BorderStyle.none)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(style: BorderStyle.none))),
      ),
    );
  }
}
