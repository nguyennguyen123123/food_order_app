import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({this.url, this.size, Key? key}) : super(key: key);

  final String? url;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        width: size ?? 50.w,
        height: size ?? 50.w,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Image.asset('assets/logo.jpg'),
      ),
    );
  }
}
