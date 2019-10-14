/*
 * Flutter BarCode Widget
 * Copyright (c) 2018 the BarCode Flutter authors.
 * See LICENSE for distribution and usage details.
 */

abstract class BarCodeParams {
  String data;
  bool withText;
  double lineWidth;
  double barHeight;
  double get barCodeWidth;

  BarCodeParams(
    this.data,
    this.withText,
    this.lineWidth,
    this.barHeight,
  ) : assert(data != null, "Data must be set for BarCodeParams");
}

/// Params used for the EAN13 BarCode format
///
class EAN13BarCodeParams extends BarCodeParams {
  EAN13BarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (lineWidth * 113);
}

/// Params used for the EAN8 BarCode format
///
class EAN8BarCodeParams extends BarCodeParams {
  EAN8BarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (lineWidth * 81);
}

/// Params used for the Code39 BarCode format
///
class Code39BarCodeParams extends BarCodeParams {
  Code39BarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (data.length + 2) * 13 * lineWidth;
}

/// Params used for the Code93 BarCode format
///
class Code93BarCodeParams extends BarCodeParams {
  Code93BarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (data.length + 5) * 9 * lineWidth - 3;
}

/// Params used for the Code128 BarCode format
///
class Code128BarCodeParams extends BarCodeParams {
  Code128BarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (data.length + 2) * 11 * lineWidth + 13 * lineWidth;
}

/// Params used for the UPCA BarCode format
///
class UPCABarCodeParams extends BarCodeParams {
  UPCABarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (lineWidth * 113);
}

/// Params used for the UPCE BarCode format
///
class UPCEBarCodeParams extends BarCodeParams {
  UPCEBarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
  }) : super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth => (lineWidth * 67);
}

/// Params used for the ITF-14 BarCode format
///
class ITFBarCodeParams extends BarCodeParams {
  /// The width of the wide bars as a multiple of [lineWidth]
  ///
  /// This must be in the range of 2.25 <=> 3.0
  ///
  final double wideBarRatio;

  /// The width of the quiet zone as a multiple of [lineWidth]
  ///
  /// 10 is the minimum value
  ///
  final double quietZoneRatio;

  /// The width of the bearer bar as a multiple of [lineWidth]
  ///
  /// 2 is the minimum value
  ///
  final double bearerBarRatio;

  /// Whether or not to draw bearer bars, this should always be true
  ///
  final bool withBearerBars;

  ITFBarCodeParams(
    String data, {
    bool withText = false,
    double lineWidth = 2.0,
    double barHeight = 100.0,
    this.wideBarRatio = 2.5,
    this.quietZoneRatio = 10.0,
    this.bearerBarRatio = 3.0,
    this.withBearerBars = true,
  })  : assert(wideBarRatio >= 2.25 && wideBarRatio <= 3.0, "wideBarRatio must be between 2.25 and 3.0"),
        assert(quietZoneRatio >= 10, "quietZoneRatio must be greater or equal to 10"),
        assert(bearerBarRatio >= 2, "bearerBarRatio must be greater or equal to 2"),
        super(data, withText, lineWidth, barHeight);

  @override
  double get barCodeWidth =>
      ((data.length / 2).ceil() * (4 * wideBarRatio + 6) + wideBarRatio + 6) * lineWidth +
      (2 * (lineWidth * quietZoneRatio));
}
