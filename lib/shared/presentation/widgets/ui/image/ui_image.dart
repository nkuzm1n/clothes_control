import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class UiImage extends StatelessWidget {
  final ImageProvider? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool loading;

  const UiImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      image: image ?? const AssetImage("assets/images/placeholder.png"),
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: OctoPlaceholder.circularProgressIndicator(),
      errorBuilder: OctoError.icon(color: Colors.red),
      // imageBuilder: (context, child) {
      //   if (loading) {
      //     return const Center(child: CircularProgressIndicator());
      //   }
      //   return child;
      // },
    );
  }
}
