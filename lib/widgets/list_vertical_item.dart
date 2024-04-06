import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class ListVerticalItem<T> extends StatelessWidget {
  const ListVerticalItem({
    required this.itemBuilder,
    Key? key,
    this.items = const [],
    this.lineItemCount = 2,
    this.paddingBetweenItem = 8,
    this.paddingBetweenLine = 4,
    this.divider,
    this.physics,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(int index, T item) itemBuilder;
  final double paddingBetweenItem;
  final double paddingBetweenLine;
  final int lineItemCount;
  final ScrollPhysics? physics;
  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    final itemColumn = items.length ~/ lineItemCount + 1;
    Widget widget = ListView.separated(
        shrinkWrap: true,
        physics: physics ?? NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => buildLineItem(index),
        separatorBuilder: (context, index) => divider ?? SizedBox(),
        itemCount: itemColumn);

    return widget;
  }

  Widget buildLineItem(int index) {
    final currentIndex = index * lineItemCount;
    if (currentIndex >= items.length) return const SizedBox();
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          lineItemCount,
          (index) => Expanded(
            child: Padding(
                padding: padding(left: index == 0 ? paddingBetweenItem : 0, right: index == 0 ? paddingBetweenItem : 0),
                child: currentIndex + index >= items.length
                    ? Container()
                    : itemBuilder(currentIndex + index, items[currentIndex + index])),
          ),
        ),
      ),
    );
  }
}
