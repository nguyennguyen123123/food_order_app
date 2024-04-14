import 'package:flutter/material.dart';

class TwoValueNotifier<A, B> extends StatelessWidget {
  const TwoValueNotifier({
    required this.firstNotifier,
    required this.secondNotifier,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<A> firstNotifier;
  final ValueNotifier<B> secondNotifier;

  final Widget Function(A, B) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: firstNotifier,
      builder: (context, first, child) => ValueListenableBuilder<B>(
          valueListenable: secondNotifier, builder: (context, second, child) => itemBuilder(first, second)),
    );
  }
}
