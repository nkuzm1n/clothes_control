import 'dart:io';

import 'package:flutter/painting.dart';

class ImageHelper {
  static NetworkImage? networkImageOrNull(String? src) {
    return src != null ? NetworkImage(src) : null;
  }

  static AssetImage? assetImageOrNull(String? src) {
    return src != null ? AssetImage(src) : null;
  }

  static FileImage? fileImageOrNull(String? src) {
    return src != null ? FileImage(File(src)) : null;
  }
}
