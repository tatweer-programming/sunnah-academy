// build image loading builder functions and imager error builder functions

import 'package:flutter/material.dart';
import 'package:sunnah_academy/src/core/utils/assets_manager.dart';

Widget defaultImageErrorBuilder(context, object, stackTrace) {
  return Image.asset(
    AssetsManager.errorIcon,
    fit: BoxFit.cover,
  );
}
