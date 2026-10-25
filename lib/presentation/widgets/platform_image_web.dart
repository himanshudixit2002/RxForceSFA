import 'package:flutter/material.dart';

Widget buildFileImage({
  required String path,
  required BoxFit fit,
  double? width,
  double? height,
  required Widget errorPlaceholder,
}) {
  return Image.network(
    path,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (_, __, ___) => errorPlaceholder,
  );
}
