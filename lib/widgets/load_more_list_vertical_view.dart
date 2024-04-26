import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/load_more_delegate_custom.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';
import 'package:loadmore/loadmore.dart';

class LoadMoreListVerticalItem<T> extends StatelessWidget {
  const LoadMoreListVerticalItem({
    Key? key,
    required this.lineItemCount,
    required this.loadMore,
    required this.items,
    required this.itemBuilder,
    this.viewPadding,
    this.divider,
  }) : super(key: key);

  final int lineItemCount;
  final Future<bool> Function() loadMore;
  final List<T> items;
  final Widget Function(int index, T item) itemBuilder;
  final EdgeInsets? viewPadding;
  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    return LoadMore(
      onLoadMore: loadMore,
      delegate: LoadMoreDelegateCustom(),
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        padding: viewPadding ?? padding(horizontal: 16),
        separatorBuilder: (context, index) => divider ?? SizedBox(),
        itemCount: items.length,
        itemBuilder: (context, index) => buildLineItem(
          index,
        ),
      ),
    );
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
                padding: padding(left: index == 0 ? 8 : 0, right: index == 0 ? 8 : 0),
                child: currentIndex + index >= items.length
                    ? Container()
                    : itemBuilder(currentIndex + index, items[currentIndex + index])),
          ),
        ),
      ),
    );
  }
}
