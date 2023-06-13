///
/// Flutter BarCode generator
/// Copyright (c) 2018 the BarCode Flutter authors.
/// See LICENSE for distribution and usage details.
///
// ignore_for_file: provide_deprecation_message

library barcode_flutter_image;

import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/widgets.dart';

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
/// ITF
/// Codabar
/// ````
///
/// ### Basic usage
/// ```dart
/// BarCodeImage(
///   ITFBarCodeParams(
///     "15400141288763",
///   )
/// )
/// ```
class BarCodeImage<T extends BarCodeParams?> extends StatelessWidget {
  ///
  ///
  BarCodeImage({
    super.key,
    @deprecated this.data,
    @deprecated this.codeType,
    @deprecated this.lineWidth = 2.0,
    @deprecated this.barHeight = 100.0,
    @deprecated this.hasText = false,
    BarCodeParams? params,
    this.padding,
    this.backgroundColor,
    Color foregroundColor = const Color(0xFF000000),
    this.onError,
  })  : assert(
          params != null || (data != null && codeType != null),
          'params or data+codeType must be set',
        ),
        assert(
          (params != null && data == null && codeType == null) ||
              (params == null && data != null && codeType != null),
          'params and data+codeType cannot be set at the same time',
        ),
        _painter = BarCodePainter(
            params ??
                _getBarcodeParams(
                  codeType,
                  data,
                  lineWidth,
                  barHeight,
                  hasText,
                ),
            foregroundColor,
            onError: onError);

  /// deprecated params
  final String? data;

  ///
  final BarCodeType? codeType;

  ///
  final double lineWidth;

  ///
  final double barHeight;

  ///
  final bool hasText;

  ///
  T? get params => _painter.params as T?;

  ///
  final BarCodePainter _painter;

  ///
  final Color? backgroundColor;

  ///
  final EdgeInsets? padding;

  ///
  final BarCodeError? onError;

  ///
  ///
  static BarCodeParams? _getBarcodeParams(BarCodeType? type, String? data,
      double lineWidth, double barHeight, bool hasText) {
    switch (type) {
      //
      case BarCodeType.CodeEAN13:
        return EAN13BarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.CodeEAN8:
        return EAN8BarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.Code39:
        return Code39BarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.Code93:
        return Code93BarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.CodeUPCA:
        return UPCABarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.CodeUPCE:
        return UPCEBarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.Code128:
        return Code128BarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      case BarCodeType.Codabar:
        return CodabarBarCodeParams(data!,
            withText: hasText, lineWidth: lineWidth, barHeight: barHeight);
      //
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        //
        width: params!.barCodeWidth + //
            (padding?.left ?? 0) +
            (padding?.right ?? 0),
        //
        height: params!.barHeight + //
            (padding?.top ?? 0) +
            (padding?.bottom ?? 0),
        //
        padding: padding,
        decoration: BoxDecoration(color: backgroundColor),
        child: CustomPaint(painter: _painter),
      );
}
