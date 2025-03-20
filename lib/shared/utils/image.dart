import 'package:flutter/painting.dart';

class ImageHelper {
  static NetworkImage? networkImageOrNull(String? src) {
    return src is String ? NetworkImage(src) : null;
  }

  static AssetImage? assetImageOrNull(String? src) {
    return src is String ? AssetImage(src) : null;
  }
}
