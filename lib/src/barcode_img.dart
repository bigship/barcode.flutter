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
    this.padding = const EdgeInsets.all(5.0),
    this.backgroundColor,
    this.hasText = false,
    Color foregroundColor = const Color(0xFF000000),
    this.onError,
  }) : _painter = new BarCodePainter(
            data, codeType, lineWidth, hasText, foregroundColor, onError: onError);

  final String data;
  final BarCodeType codeType;
  final BarCodePainter _painter;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double lineWidth;
  final double barHeight;
  final hasText;
  final BarCodeError onError;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (context, constraints) {
        return new Container(
          width: _calcCanvasWidth(this.data, this.codeType, this.lineWidth),
          height: hasText ? this.barHeight * 1.08 : this.barHeight,
          color: backgroundColor,
          child: new Padding(
            padding: this.padding,
            child: new CustomPaint(
              painter: _painter,
            ),
          ),
        );
      },
    );
  }

  double _calcCanvasWidth(String content, BarCodeType type, double lineWidth) {
    int strLength = content.length;
    switch(type) {
      case BarCodeType.Code39:
        return (strLength+2)*13*lineWidth;
      case BarCodeType.Code93:
        return (strLength+5)*9*lineWidth-3;
      case BarCodeType.Code128:
        return (strLength+2)*11*lineWidth+13*lineWidth; 
      case BarCodeType.CodeEAN13:
        return (lineWidth*113);
      case BarCodeType.CodeEAN8:
        return (lineWidth*81);
      case BarCodeType.CodeUPCA:
        return (lineWidth*113);
      case BarCodeType.CodeUPCE:
        return (lineWidth*67);
      default:
        return 0.0;
    }
  }
}
