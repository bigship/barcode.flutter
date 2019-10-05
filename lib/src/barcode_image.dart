/*
 * Flutter BarCode generator
 * Copyright (c) 2018 the BarCode Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'barcode_painter.dart';
import 'barcode_enum.dart';

class BarCodeImage extends StatelessWidget {
  BarCodeImage({
    @required this.data,
    @required this.codeType,
    this.lineWidth = 2.0,
    this.barHeight = 100.0,
    this.foregroundColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.hasText = false,
    this.fontSize = 15.0,
    this.onError,
  }) : _painter = new BarCodePainter(
          data,
          codeType,
          lineWidth,
          hasText,
          foregroundColor,
          backgroundColor,
          onError: onError,
        );

  final BarCodePainter _painter;
  final String data;
  final BarCodeType codeType;
  final Color foregroundColor;
  final Color backgroundColor;
  final double lineWidth;
  final double barHeight;
  final hasText;
  final BarCodeError onError;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (context, constraints) {
        return new Container(
          width: _calcCanvasWidth(this.data, this.codeType, this.lineWidth),
          height: hasText ? this.barHeight * 1.08 : this.barHeight,
          color: backgroundColor,
          child: new CustomPaint(
            painter: _painter,
          ),
        );
      },
    );
  }

  double _calcCanvasWidth(String content, BarCodeType type, double lineWidth) {
    int strLength = content.length;
    double calculatedWidth = 0;
    switch (type) {
      case BarCodeType.Code39:
        calculatedWidth = (strLength + 2) * 13 * lineWidth;
        //print("calculated width = $calculatedWidth");
        return calculatedWidth;
      case BarCodeType.Code93:
        return (strLength + 5) * 9 * lineWidth - 3;
      case BarCodeType.Code128:
        return (strLength + 2) * 11 * lineWidth + 13 * lineWidth;
      case BarCodeType.CodeEAN13:
        return (lineWidth * 113);
      case BarCodeType.CodeEAN8:
        return (lineWidth * 81);
      case BarCodeType.CodeUPCA:
        return (lineWidth * 113);
      case BarCodeType.CodeUPCE:
        return (lineWidth * 67);
      default:
        return 0.0;
    }
  }
}
