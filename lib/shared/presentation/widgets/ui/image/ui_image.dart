import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class UiImage extends StatelessWidget {
  final ImageProvider? image;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const UiImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    print("UI_IMAGE");
    print(image);
    return OctoImage(
      image: image ?? const AssetImage("assets/images/placeholder.jpg"),
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: OctoPlaceholder.circularProgressIndicator(),
      errorBuilder: OctoError.icon(color: Colors.red),
    );
  }
}
