/*
 * Flutter BarCode generator
 * Copyright (c) 2018 the BarCode Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/widgets.dart';
import 'barcode_painter.dart';
import 'barcode_params.dart';

/// A barcode custom painter
/// 
/// ## BarCodeParam Types
/// ```dart 
/// EAN13
/// EAN8
/// Code39
/// Code93
/// Code128
/// UPCA
/// UPCE
/// ITF14
/// ````
/// 
/// ### Basic usage
/// ```dart
/// BarCodeImage(
///   ITF14BarCodeParams(
///     "15400141288763",
///   )
/// )
/// ```
class BarCodeImage<T extends BarCodeParams> extends StatelessWidget {
  BarCodeImage(
    this.params, {
    this.padding,
    this.backgroundColor,
    Color foregroundColor = const Color(0xFF000000),
    this.onError,
  }) : _painter = new BarCodePainter(params, foregroundColor, onError: onError);

  final BarCodeParams params;

  final BarCodePainter _painter;
  final Color backgroundColor;

  final EdgeInsets padding;
  final BarCodeError onError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: params.barCodeWidth + (padding?.left ?? 0) + (padding?.right ?? 0),
      height: params.barHeight + (padding?.top ?? 0) + (padding?.bottom ?? 0),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: padding,
      child: CustomPaint(
        painter: _painter,
      ),
    );
  }
}
