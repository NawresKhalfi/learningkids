import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Wraps any widget so it can be captured as a base64 PNG — used for a
/// project's thumbnail at a low `pixelRatio` (EP07/US39, since it's stored
/// inline in Firestore rather than Firebase Storage) and for a full-quality
/// certificate image to share (EP08/US45). See `docs/FEATURES.md` for the
/// thumbnail-storage trade-off.
class PreviewCapture extends StatelessWidget {
  const PreviewCapture({super.key, required this.boundaryKey, required this.child});

  final GlobalKey boundaryKey;
  final Widget child;

  static Future<String?> captureBase64(GlobalKey boundaryKey, {double pixelRatio = 0.3}) async {
    final boundary = boundaryKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) return null;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    return base64Encode(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(key: boundaryKey, child: child);
}

/// Decodes a stored/captured base64 image back into displayable bytes, or
/// `null` for missing/corrupted data.
Uint8List? decodeThumbnail(String? base64Image) {
  if (base64Image == null) return null;
  try {
    return base64Decode(base64Image);
  } on FormatException {
    return null;
  }
}
