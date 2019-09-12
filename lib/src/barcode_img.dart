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
    @required this.width,
    @required this.height,
    this.padding = const EdgeInsets.all(5.0),
    this.backgroundColor,
    this.hasText = false,
    this.foregroundColor = const Color(0xFF000000),
    this.onError,
  });

  final String data;
  final BarCodeType codeType;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double width;
  final double height;
  final hasText;
  final BarCodeError onError;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (context, constraints) {
        return new Container(
          width: width,
          height: height,
          color: backgroundColor,
          child: new Padding(
            padding: this.padding,
            child: new CustomPaint(
              painter: BarCodePainter(
                data,
                codeType,
                _calcLineWidth(data, codeType, width),
                hasText,
                foregroundColor,
                onError: onError,
              ),
            ),
          ),
        );
      },
    );
  }

  double _calcLineWidth(String content, BarCodeType type, double width) {
    int strLength = content.length;
    switch (type) {
      case BarCodeType.Code39:
        return width / 13 / (strLength + 2);
      case BarCodeType.Code93:
        return (width + 3) / 9 / (strLength + 5);
      case BarCodeType.Code128:
        return width / ((strLength + 2) * 11 + 13);
      case BarCodeType.CodeEAN13:
        return (width / 113);
      case BarCodeType.CodeEAN8:
        return (width / 81);
      case BarCodeType.CodeUPCA:
        return (width / 113);
      case BarCodeType.CodeUPCE:
        return (width / 67);
      default:
        return 0.0;
    }
  }
}
