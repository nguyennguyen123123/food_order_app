import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/reponsive/extension.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    this.url,
    Key? key,
    this.size,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  final String? url;
  final double? size;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        width: width?.w ?? size ?? 50.w,
        height: height?.h ?? size ?? 50.w,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Image.asset('assets/logo.jpg'),
      ),
    );
  }
}
