import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({this.url, this.size, this.radius = 100, Key? key}) : super(key: key);

  final String? url;
  final double? size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
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
