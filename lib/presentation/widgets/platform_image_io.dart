import 'dart:io';

import 'package:flutter/material.dart';

Widget buildFileImage({
  required String path,
  required BoxFit fit,
  double? width,
  double? height,
  required Widget errorPlaceholder,
}) {
  return Image.file(
    File(path),
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (_, __, ___) => errorPlaceholder,
  );
}
