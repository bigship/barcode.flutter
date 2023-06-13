///
/// Flutter BarCode generator
/// Copyright (c) 2018 the BarCode Flutter authors.
/// See LICENSE for distribution and usage details.
///
// ignore_for_file: avoid_print

library barcode_flutter_painter;

import 'dart:typed_data';

import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';

///
///
typedef BarCodeError = void Function(dynamic error);

///
///
///
class BarCodePainter extends CustomPainter {
  ///
  BarCodePainter(this.params, this.color, {this.onError});

  ///
  final BarCodeParams? params;

  ///
  final Color color;

  ///
  final BarCodeError? onError;

  @override
  void paint(Canvas canvas, Size size) {
    /// https://github.com/dart-lang/sdk/issues/2949 😭

    if (params is Code39BarCodeParams) {
      _drawBarCode39(canvas, size);
    }
    //
    else if (params is Code93BarCodeParams) {
      _drawBarCode93(canvas, size);
    }
    //
    else if (params is Code128BarCodeParams) {
      _drawBarCode128(canvas, size);
    }
    //
    else if (params is EAN13BarCodeParams) {
      _drawBarCodeEAN13(canvas, size);
    }
    //
    else if (params is EAN8BarCodeParams) {
      _drawBarCodeEAN8(canvas, size);
    }
    //
    else if (params is UPCABarCodeParams) {
      _drawBarCodeUPCA(canvas, size);
    }
    //
    else if (params is UPCEBarCodeParams) {
      _drawBarCodeUPCE(canvas, size);
    }
    //
    else if (params is ITFBarCodeParams) {
      _drawBarCodeITF(canvas, size);
    }
    //
    else if (params is CodabarBarCodeParams) {
      _drawBarCodeCodabar(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  ///
  ///
  void _drawBarCode39(Canvas canvas, Size size) {
    const binSet = <int>[
      ...[0xa6d, 0xd2b, 0xb2b, 0xd95, 0xa6b, 0xd35, 0xb35, 0xa5b, 0xd2d, 0xb2d],
      ...[0xd4b, 0xb4b, 0xda5, 0xacb, 0xd65, 0xb65, 0xa9b, 0xd4d, 0xb4d, 0xacd],
      ...[0xd53, 0xb53, 0xda9, 0xad3, 0xd69, 0xb69, 0xab3, 0xd59, 0xb59, 0xad9],
      ...[0xcab, 0x9ab, 0xcd5, 0x96b, 0xcb5, 0x9b5, 0x95b, 0xcad, 0x9ad, 0x925],
      ...[0x929, 0x949, 0xa49, 0x96d]
    ];

    const patterns = <String, int>{
      ...{'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7},
      ...{'8': 8, '9': 9, 'A': 10, 'B': 11, 'C': 12, 'D': 13, 'E': 14},
      ...{'F': 15, 'G': 16, 'H': 17, 'I': 18, 'J': 19, 'K': 20, 'L': 21},
      ...{'M': 22, 'N': 23, 'O': 24, 'P': 25, 'Q': 26, 'R': 27, 'S': 28},
      ...{'T': 29, 'U': 30, 'V': 31, 'W': 32, 'X': 33, 'Y': 34, 'Z': 35},
      ...{'-': 36, '.': 37, ' ': 38, '\$': 39, '/': 40, '+': 41, '%': 42},
    };

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    int codeValue = 0;
    bool hasError = false;
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < data.length; i++) {
      codeValue = patterns[data[i]] ?? 0;

      if (codeValue == 0) {
        hasError = true;
      }

      if (hasError) {
        const errorMsg = 'Invalid content for Code39. Please check '
            'https://en.wikipedia.org/wiki/Code_39 for reference.';

        if (onError != null) {
          onError!(errorMsg);
        }
        //
        else {
          print(errorMsg);
        }

        return;
      }

      for (int j = 0; j < 12; j++) {
        final rect = Rect.fromLTWH(
          13 * lineWidth + 13 * i * lineWidth + j * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x800 & (binSet[codeValue] << j)) == 0x800)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 12; i++) {
      final rect = Rect.fromLTWH(i * lineWidth, 0.0, lineWidth, height);

      ((0x800 & (binSet[43] << i)) == 0x800)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 12; i++) {
      final rect = Rect.fromLTWH(
        (13 + i) * lineWidth + 13 * (data.length) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x800 & (binSet[43] << i)) == 0x800)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        final span = TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
          text: data[i],
        );

        final textPainter = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(
                (size.width - data.length * 13 * lineWidth) / 2 +
                    13 * i * lineWidth,
                height));
      }
    }
  }

  ///
  ///
  void _drawBarCode93(Canvas canvas, Size size) {
    const binSet = <int>[
      ...[0x8a, 0xa4, 0xa2, 0xa1, 0x94, 0x92, 0x91, 0xa8, 0x89, 0x85, 0xd4],
      ...[0xd2, 0xd1, 0xca, 0xc9, 0xc5, 0xb4, 0xb2, 0xb1, 0x9a, 0x8d, 0xac],
      ...[0xa6, 0xa3, 0x96, 0x8b, 0xda, 0xd9, 0xd6, 0xd3, 0xcb, 0xcd, 0xb6],
      ...[0xb3, 0x9b, 0x9d, 0x97, 0xea, 0xe9, 0xe5, 0xb7, 0xbb, 0xd7, 0x93],
      ...[0xed, 0xeb, 0x99, 0xaf]
    ];

    const patterns = <String, int>{
      ...{'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7},
      ...{'8': 8, '9': 9, 'A': 10, 'B': 11, 'C': 12, 'D': 13, 'E': 14},
      ...{'F': 15, 'G': 16, 'H': 17, 'I': 18, 'J': 19, 'K': 20, 'L': 21},
      ...{'M': 22, 'N': 23, 'O': 24, 'P': 25, 'Q': 26, 'R': 27, 'S': 28},
      ...{'T': 29, 'U': 30, 'V': 31, 'W': 32, 'X': 33, 'Y': 34, 'Z': 35},
      ...{'-': 36, '.': 37, ' ': 38, '\$': 39, '/': 40, '+': 41, '%': 42},
    };

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    int codeValue = 0, checkCodeC, checkCodeK;
    int sumC = 0, sumK = 0;
    bool hasError = false;
    final strValue = ByteData(data.length);
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 8; i++) {
      final rect = Rect.fromLTWH(i * lineWidth, 0.0, lineWidth, height);

      ((0x80 & (binSet[47] << i)) == 0x80)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < data.length; i++) {
      codeValue = patterns[data[i]] ?? 0;

      if (codeValue == 0) {
        hasError = true;
      }

      if (hasError) {
        const errorMsg = 'Invalid content for Code93. Please check '
            'https://en.wikipedia.org/wiki/Code_93 for reference.';

        if (onError != null) {
          onError!(errorMsg);
        }
        //
        else {
          print(errorMsg);
        }

        return;
      }

      strValue.setUint8(i, codeValue);
      sumC += strValue.getUint8(i) * (data.length - i);
      sumK += strValue.getUint8(i) * (data.length - i + 1);

      for (int j = 0; j < 8; j++) {
        final rect = Rect.fromLTWH(
          9 * lineWidth + 9 * i * lineWidth + j * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x80 & (binSet[codeValue] << j)) == 0x80)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    checkCodeC = sumC % 47;

    for (int i = 0; i < 8; i++) {
      final rect = Rect.fromLTWH(
        9 * lineWidth + (data.length * 9 + i) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x80 & (binSet[checkCodeC] << i)) == 0x80)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    checkCodeK = (sumK + checkCodeC) % 47;

    for (int i = 0; i < 8; i++) {
      final rect = Rect.fromLTWH(
        9 * lineWidth + ((data.length + 1) * 9 + i) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x80 & (binSet[checkCodeK] << i)) == 0x80)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 8; i++) {
      final rect = Rect.fromLTWH(
        9 * lineWidth + ((data.length + 2) * 9 + i) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x80 & (binSet[47] << i)) == 0x80)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 8; i++) {
      final rect = Rect.fromLTWH(
        9 * lineWidth + ((data.length + 3) * 9 + i) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x80 & (binSet[1] << i)) == 0x80)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        final span = TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
          text: data[i],
        );

        final textPainter = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
              (size.width - data.length * 8 * lineWidth) / 2 +
                  8 * i * lineWidth,
              height),
        );
      }
    }
  }

  ///
  ///
  void _drawBarCode128(Canvas canvas, Size size) {
    const code128 = <int>[
      ...[0x6cc, 0x66c, 0x666, 0x498, 0x48c, 0x44c, 0x4c8, 0x4c4, 0x464, 0x648],
      ...[0x644, 0x624, 0x59c, 0x4dc, 0x4ce, 0x5cc, 0x4ec, 0x4e6, 0x672, 0x65c],
      ...[0x64e, 0x6e4, 0x674, 0x76e, 0x74c, 0x72c, 0x726, 0x764, 0x734, 0x732],
      ...[0x6d8, 0x6c6, 0x636, 0x518, 0x458, 0x446, 0x588, 0x468, 0x462, 0x688],
      ...[0x628, 0x622, 0x5b8, 0x58e, 0x46e, 0x5d8, 0x5c6, 0x476, 0x776, 0x68e],
      ...[0x62e, 0x6e8, 0x6e2, 0x6ee, 0x758, 0x746, 0x716, 0x768, 0x762, 0x71a],
      ...[0x77a, 0x642, 0x78a, 0x530, 0x50c, 0x4b0, 0x486, 0x42c, 0x426, 0x590],
      ...[0x584, 0x4d0, 0x4c2, 0x434, 0x432, 0x612, 0x650, 0x7ba, 0x614, 0x47a],
      ...[0x53c, 0x4bc, 0x49e, 0x5e4, 0x4f4, 0x4f2, 0x7a4, 0x794, 0x792, 0x6de],
      ...[0x6f6, 0x7b6, 0x578, 0x51e, 0x45e, 0x5e8, 0x5e2, 0x7a8, 0x7a2, 0x5de],
      ...[0x5ee, 0x75e, 0x7ae, 0x684, 0x690, 0x69c],
    ];

    const patterns = <String, int>{
      ...{' ': 0, '!': 1, '"': 2, '#': 3, '\$': 4, '%': 5, '&': 6, '…': 7},
      ...{'(': 8, ')': 9, '*': 10, '+': 11, ',': 12, '-': 13, '.': 14},
      ...{'/': 15, '0': 16, '1': 17, '2': 18, '3': 19, '4': 20, '5': 21},
      ...{'6': 22, '7': 23, '8': 24, '9': 25, ':': 26, ';': 27, '<': 28},
      ...{'=': 29, '>': 30, '?': 31, '@': 32, 'A': 33, 'B': 34, 'C': 35},
      ...{'D': 36, 'E': 37, 'F': 38, 'G': 39, 'H': 40, 'I': 41, 'J': 42},
      ...{'K': 43, 'L': 44, 'M': 45, 'N': 46, 'O': 47, 'P': 48, 'Q': 49},
      ...{'R': 50, 'S': 51, 'T': 52, 'U': 53, 'V': 54, 'W': 55, 'X': 56},
      ...{'Y': 57, 'Z': 58, '[': 59, '、': 0, ']': 61, '^': 62, '_': 63},
      ...{'`': 64, 'a': 65, 'b': 66, 'c': 67, 'd': 68, 'e': 69, 'f': 70},
      ...{'g': 71, 'h': 72, 'i': 73, 'j': 74, 'k': 75, 'l': 76, 'm': 77},
      ...{'n': 78, 'o': 79, 'p': 80, 'q': 81, 'r': 82, 's': 83, 't': 84},
      ...{'u': 85, 'v': 86, 'w': 87, 'x': 88, 'y': 89, 'z': 90, '{': 91},
      ...{'|': 92, '}': 93, '~': 94},
    };

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    int codeValue;
    int checkCode;
    int sum = 0;

    final strlen = data.length;
    final strValue = ByteData(strlen);

    const startValue = 0x690;
    const endFlag = 0x18eb;

    bool hasError = false;
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 11; i++) {
      final rect = Rect.fromLTWH(i * lineWidth, 0.0, lineWidth, height);

      ((0x400 & (startValue << i)) == 0x400)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < strlen; i++) {
      codeValue = patterns[data[i]] ?? 0;

      if (codeValue == 0) {
        hasError = true;
      }

      if (hasError) {
        const errorMsg = 'Invalid content for Code128. Please check '
            'https://en.wikipedia.org/wiki/Code_128 for reference.';

        if (onError != null) {
          onError!(errorMsg);
        }
        //
        else {
          print(errorMsg);
        }

        return;
      }

      strValue.setUint8(i, codeValue);
      sum += strValue.getUint8(i) * (i + 1);

      for (int j = 0; j < 11; j++) {
        final rect = Rect.fromLTWH(
          11 * lineWidth + 11 * i * lineWidth + j * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x400 & (code128[codeValue] << j)) == 0x400)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    checkCode = (sum + 104) % 103;
    for (int i = 0; i < 11; i++) {
      final rect = Rect.fromLTWH(
        11 * lineWidth + (strlen * 11 + i) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x400 & (code128[checkCode] << i)) == 0x400)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 13; i++) {
      final rect = Rect.fromLTWH(
        22 * lineWidth + (strlen * 11 + i) * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x1000 & (endFlag << i)) == 0x1000)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        final span = TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
          text: data[i],
        );

        final textPainter = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
              (size.width - data.length * 8 * lineWidth) / 2 +
                  8 * i * lineWidth,
              height),
        );
      }
    }
  }

  ///
  ///
  void _drawBarCodeEAN13(Canvas canvas, Size size) {
    const codeA = <int>[
      ...[0x0d, 0x19, 0x13, 0x3d, 0x23],
      ...[0x31, 0x2f, 0x3b, 0x37, 0x0b]
    ];

    const codeB = <int>[
      ...[0x27, 0x33, 0x1b, 0x21, 0x1d],
      ...[0x39, 0x05, 0x11, 0x09, 0x17]
    ];

    const codeC = <int>[
      ...[0x72, 0x66, 0x6c, 0x42, 0x5c],
      ...[0x4e, 0x50, 0x44, 0x48, 0x74]
    ];

    const flagCode = <int>[
      ...[0x00, 0x0b, 0x0d, 0x0e, 0x13],
      ...[0x19, 0x1c, 0x15, 0x17, 0x1a]
    ];

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    const startCodeSep = 0x05;
    const midCodeSep = 0x0a;
    const endCodeSep = 0x05;

    late int tmpCode,
        tmpBarCode,
        checkCode,
        sum2nd,
        sum3rd,
        flagbit,
        strlen = data.length;

    bool hasError = false;

    final st = ByteData(12);
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    if (strlen > 12) {
      strlen = 13;
    }
    //
    else {
      hasError = true;
    }

    for (int i = 0; i < 12; i++) {
      st.setUint8(i, data.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
      }
    }

    if (hasError) {
      const errorMsg = 'Invalid content for code EAN13. Please check '
          'https://en.wikipedia.org/wiki/International_Article_Number for reference.';

      if (onError != null) {
        onError!(errorMsg);
      }
      //
      else {
        print(errorMsg);
      }

      return;
    }

    for (int j = 0; j < 3; j++) {
      final rect = Rect.fromLTWH(
        11 * lineWidth + j * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (startCodeSep >> j)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 7; i++) {
      tmpCode = data.codeUnitAt(i) - 48;

      if (i == 0) {
        flagbit = tmpCode;
      }
      //
      else {
        if ((0x20 & (flagCode[flagbit] << (i - 1))) == 0) {
          for (int j = 0; j < 7; j++) {
            final rect = Rect.fromLTWH(
              14 * lineWidth + 7 * (i - 1) * lineWidth + j * lineWidth,
              0.0,
              lineWidth,
              height,
            );

            ((0x40 & (codeA[tmpCode] << j)) == 0x40)
                ? painter.color = Colors.black
                : painter.color = Colors.white;

            canvas.drawRect(rect, painter);
          }
        }
        //
        else {
          for (int n = 0; n < 7; n++) {
            final rect = Rect.fromLTWH(
              14 * lineWidth + 7 * (i - 1) * lineWidth + n * lineWidth,
              0.0,
              lineWidth,
              height,
            );

            ((0x40 & (codeB[tmpCode] << n)) == 0x40)
                ? painter.color = Colors.black
                : painter.color = Colors.white;

            canvas.drawRect(rect, painter);
          }
        }
      }
    }

    for (int i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(
        56 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (midCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 5; i++) {
      tmpBarCode = data.codeUnitAt(i + 7) - 48;

      for (int j = 0; j < 7; j++) {
        final rect = Rect.fromLTWH(
          61 * lineWidth + j * lineWidth + 7 * i * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x40 & (codeC[tmpBarCode] << j)) == 0x40)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    sum3rd = (st.getUint8(0) + st.getUint8(2) + st.getUint8(4)) +
        (st.getUint8(6) + st.getUint8(8) + st.getUint8(10));

    sum2nd = (st.getUint8(1) + st.getUint8(3) + st.getUint8(5)) +
        (st.getUint8(7) + st.getUint8(9) + st.getUint8(11));

    if ((sum2nd * 3 + sum3rd) % 10 == 0) {
      checkCode = 0;
    }
    //
    else {
      checkCode = 10 - (sum2nd * 3 + sum3rd) % 10;
    }

    for (int i = 0; i < 7; i++) {
      final rect = Rect.fromLTWH(
        96 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x40 & (codeC[checkCode] << i)) == 0x40)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(
        103 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (endCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      (data.length > 13) //
          ? strlen = 13
          : strlen = data.length;

      for (int i = 0; i < strlen; i++) {
        if (i == 0) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(canvas, Offset(2 * lineWidth, height));
        }
        //
        else if (i < 7) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(13 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
        //
        else if (i == 12) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: checkCode.toString(),
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(17 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
        //
        else {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(17 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
      }
    }
  }

  ///
  ///
  void _drawBarCodeEAN8(Canvas canvas, Size size) {
    const codeA = <int>[
      ...[0x0d, 0x19, 0x13, 0x3d, 0x23],
      ...[0x31, 0x2f, 0x3b, 0x37, 0x0b]
    ];

    const codeC = <int>[
      ...[0x72, 0x66, 0x6c, 0x42, 0x5c],
      ...[0x4e, 0x50, 0x44, 0x48, 0x74]
    ];

    const startCodeSep = 0x05;
    const midCodeSep = 0x0a;
    const endCodeSep = 0x05;

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    int tmpCode, tmpBarCode, checkCode, sum2nd, sum3rd, strlen = data.length;
    bool hasError = false;

    final st = ByteData(7);
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 7; i++) {
      st.setUint8(i, data.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
      }
    }

    if (hasError) {
      const errorMsg = 'Invalid content for code EAN8. Please check '
          'https://en.wikipedia.org/wiki/EAN-8 for reference.';

      if (onError != null) {
        onError!(errorMsg);
      }
      //
      else {
        print(errorMsg);
      }

      return;
    }

    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(7 * lineWidth + i * lineWidth, 0.0, lineWidth,
          hasText ? height * 1.08 : height);
      ((0x01 & (startCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 4; i++) {
      tmpCode = data.codeUnitAt(i) - 48;
      for (int j = 0; j < 7; j++) {
        final rect = Rect.fromLTWH(
            10 * lineWidth + j * lineWidth + 7 * i * lineWidth,
            0.0,
            lineWidth,
            height);
        ((0x40 & (codeA[tmpCode] << j)) == 0x40)
            ? painter.color = Colors.black
            : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(
        38 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x01 & (midCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 4; i < 7; i++) {
      tmpBarCode = data.codeUnitAt(i) - 48;
      for (int j = 0; j < 7; j++) {
        final rect = Rect.fromLTWH(
          43 * lineWidth + j * lineWidth + 7 * (i - 4) * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x40 & (codeC[tmpBarCode] << j)) == 0x40)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    sum2nd = st.getUint8(6) + st.getUint8(4) + st.getUint8(2) + st.getUint8(0);
    sum3rd = st.getUint8(5) + st.getUint8(3) + st.getUint8(1);

    if ((sum3rd + sum2nd * 3) % 10 == 0) {
      checkCode = 0;
    }
    //
    else {
      checkCode = 10 - (sum3rd + sum2nd * 3) % 10;
    }

    for (int i = 0; i < 7; i++) {
      final rect = Rect.fromLTWH(
        64 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x40 & (codeC[checkCode] << i)) == 0x40)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(
        71 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (endCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      strlen > 8 //
          ? strlen = 8
          : strlen = data.length;

      for (int i = 0; i < strlen; i++) {
        if (i < 4) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(11 * lineWidth + 7 * i * lineWidth, height),
          );
        }
        //
        else if (i == 7) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: checkCode.toString(),
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(15 * lineWidth + 7 * i * lineWidth, height),
          );
        }
        //
        else {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(15 * lineWidth + 7 * i * lineWidth, height),
          );
        }
      }
    }
  }

  ///
  ///
  void _drawBarCodeUPCA(Canvas canvas, Size size) {
    const codeA = <int>[
      ...[0x0d, 0x19, 0x13, 0x3d, 0x23],
      ...[0x31, 0x2f, 0x3b, 0x37, 0x0b]
    ];

    const codeC = <int>[
      ...[0x72, 0x66, 0x6c, 0x42, 0x5c],
      ...[0x4e, 0x50, 0x44, 0x48, 0x74]
    ];

    const startCodeSep = 0x05;
    const midCodeSep = 0x0a;
    const endCodeSep = 0x05;

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    int tmpCode, tmpBarCode, checkCode, sum2nd, sum3rd, strlen = data.length;
    final st = ByteData(11);
    bool hasError = false;
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 11; i++) {
      st.setUint8(i, data.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
      }
    }

    if (hasError) {
      const errorMsg = 'Invalid content for coe UPC-A. Please check '
          'https://en.wikipedia.org/wiki/Universal_Product_Code for reference.';

      if (onError != null) {
        onError!(errorMsg);
      }
      //
      else {
        print(errorMsg);
      }

      return;
    }

    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(
        9 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (startCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 6; i++) {
      tmpCode = data.codeUnitAt(i) - 48;

      for (int j = 0; j < 7; j++) {
        final rect = Rect.fromLTWH(
          12 * lineWidth + 7 * i * lineWidth + j * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x40 & (codeA[tmpCode] << j)) == 0x40)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(
        54 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (midCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 5; i++) {
      tmpBarCode = data.codeUnitAt(i + 6) - 48;

      for (int j = 0; j < 7; j++) {
        final rect = Rect.fromLTWH(
          59 * lineWidth + j * lineWidth + 7 * i * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        ((0x40 & (codeC[tmpBarCode] << j)) == 0x40)
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    sum3rd = (st.getUint8(0) + st.getUint8(2) + st.getUint8(4)) +
        (st.getUint8(6) + st.getUint8(8) + st.getUint8(10));

    sum2nd = (st.getUint8(1) + st.getUint8(3) + st.getUint8(5)) +
        (st.getUint8(7) + st.getUint8(9));

    if ((sum2nd + sum3rd * 3) % 10 == 0) {
      checkCode = 0;
    }
    //
    else {
      checkCode = 10 - (sum2nd + sum3rd * 3) % 10;
    }

    for (int i = 0; i < 7; i++) {
      final rect = Rect.fromLTWH(
        94 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        height,
      );

      ((0x40 & (codeC[checkCode] << i)) == 0x40)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(
        101 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x01 & (endCodeSep >> i)) == 0x01)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      strlen > 12 //
          ? strlen = 12
          : strlen = data.length;

      for (int i = 0; i < strlen; i++) {
        if (i == 0) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(canvas, Offset(3 * lineWidth, height));
        }
        //
        else if (i < 6) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(16 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
        //
        else if (i < 11) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(26 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
        //
        else {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: checkCode.toString(),
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(35 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
      }
    }
  }

  ///
  ///
  ///
  void _drawBarCodeUPCE(Canvas canvas, Size size) {
    const codeA = <int>[
      ...[0x0d, 0x19, 0x13, 0x3d, 0x23],
      ...[0x31, 0x2f, 0x3b, 0x37, 0x0b]
    ];

    const codeB = <int>[
      ...[0x27, 0x33, 0x1b, 0x21, 0x1d],
      ...[0x39, 0x05, 0x11, 0x09, 0x17]
    ];

    const checkCodeFlag = <int>[
      ...[0x38, 0x34, 0x32, 0x31, 0x2c],
      ...[0x26, 0x23, 0x2a, 0x29, 0x25]
    ];

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    const startCodeSep = 0x05;
    const endCodeSep = 0x15;
    int tmpCode, checkCode, sum2nd, sum3rd, strlen;
    final st = ByteData(11);

    bool hasError = false;
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    if (data.length != 8) {
      hasError = true;
    }

    late String upce2upca;

    switch (data.codeUnitAt(6) - 48) {
      case 0:
        upce2upca = (data[0] + data[1] + data[2]) +
            ('00000${data[3]}${data[4]}${data[5]}');
        break;
      case 1:
      case 2:
        upce2upca = (data[0] + data[1] + data[2]) +
            ('${data[6]}00000${data[4]}${data[5]}');
        break;
      case 3:
        upce2upca = (data[0] + data[1] + data[2]) +
            ('${data[3]}00000${data[4]}${data[5]}');
        break;
      case 4:
        upce2upca = (data[0] + data[1] + data[2]) +
            ('${data[3]}${data[4]}00000${data[5]}');
        break;
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        upce2upca = data[0] +
            (data[1] + data[2] + data[3]) +
            ('${data[4]}${data[5]}0000${data[6]}');
        break;
      default:
        break;
    }

    for (int i = 0; i < 11; i++) {
      st.setUint8(i, upce2upca.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
        break;
      }
    }

    if (hasError) {
      const errorMsg = 'Invalid content for code UPCE. Please check '
          'https://en.wikipedia.org/wiki/Universal_Product_Code#UPC-E for reference.';

      if (onError != null) {
        onError!(errorMsg);
      }
      //
      else {
        print(errorMsg);
      }

      return;
    }

    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(
        8 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x04 & (startCodeSep << i)) == 0x04)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    sum3rd = st.getUint8(0) +
        st.getUint8(2) +
        st.getUint8(4) +
        st.getUint8(6) +
        st.getUint8(8) +
        st.getUint8(10);

    sum2nd = st.getUint8(1) +
        st.getUint8(3) +
        st.getUint8(5) +
        st.getUint8(7) +
        st.getUint8(9);

    if ((sum2nd + sum3rd * 3) % 10 == 0) {
      checkCode = 0;
    }
    //
    else {
      checkCode = 10 - (sum2nd + sum3rd * 3) % 10;
    }

    for (int i = 0; i < 6; i++) {
      tmpCode = data.codeUnitAt(i + 1) - 48;

      if ((0x20 & (checkCodeFlag[checkCode] << i)) == 0x20) {
        for (int j = 0; j < 7; j++) {
          final rect = Rect.fromLTWH(
            11 * lineWidth + 7 * i * lineWidth + j * lineWidth,
            0.0,
            lineWidth,
            height,
          );

          ((0x40 & (codeB[tmpCode] << j)) == 0x40)
              ? painter.color = Colors.black
              : painter.color = Colors.white;

          canvas.drawRect(rect, painter);
        }
      }
      //
      else {
        for (int k = 0; k < 7; k++) {
          final rect = Rect.fromLTWH(
            11 * lineWidth + 7 * i * lineWidth + k * lineWidth,
            0.0,
            lineWidth,
            height,
          );

          ((0x40 & (codeA[tmpCode] << k)) == 0x40)
              ? painter.color = Colors.black
              : painter.color = Colors.white;

          canvas.drawRect(rect, painter);
        }
      }
    }

    for (int i = 0; i < 6; i++) {
      final rect = Rect.fromLTWH(
        53 * lineWidth + i * lineWidth,
        0.0,
        lineWidth,
        hasText ? height * 1.08 : height,
      );

      ((0x20 & (endCodeSep << i)) == 0x20)
          ? painter.color = Colors.black
          : painter.color = Colors.white;

      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      (data.length > 8) //
          ? strlen = 8
          : strlen = data.length;

      for (int i = 0; i < strlen; i++) {
        if (i == 0) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(canvas, Offset(2 * lineWidth, height));
        }
        //
        else if (i < 7) {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i],
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(12 * lineWidth + 7 * (i - 1) * lineWidth, height),
          );
        }
        //
        else {
          final span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: checkCode.toString(),
          );

          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();
          textPainter.paint(canvas, Offset(60 * lineWidth, height));
        }
      }
    }
  }

  /// ITF painter
  ///
  /// Start pattern is 4 bits of (0, 0, 0, 0)
  /// Stop pattern is 3 bits of (1, 0, 0)
  ///
  /// 0 bits are narrow bars,
  /// 1 bits are wide bars
  ///
  /// Alternating bits are dark/light/dart/light etc..
  ///
  /// The input data is split into groups of 2 digits,
  /// these bit values are interleaved to form a 10 bit barcode segment
  ///
  /// More info can be found here in Section 5.3 here: https://www.gs1.org/sites/default/files/docs/barcodes/GS1_General_Specifications.pdf
  void _drawBarCodeITF(Canvas canvas, Size size) {
    final itfParams = params as ITFBarCodeParams;

    /// Wish this was added right now, https://github.com/dart-lang/language/issues/581
    /// 0 = 0b00110,
    /// 1 = 0b10001,
    /// 2 = 0b01001,
    /// 3 = 0b11000,
    /// 4 = 0b00101,
    /// 5 = 0b10100,
    /// 6 = 0b01100,
    /// 7 = 0b00011,
    /// 8 = 0b10010,
    /// 9 = 0b01010
    ///
    const encodation = [
      ...[0x06, 0x11, 0x09, 0x18, 0x05],
      ...[0x14, 0x0c, 0x03, 0x12, 0x0a],
    ];

    var cleanData = itfParams.data;

    if (cleanData.length % 2 != 0) {
      cleanData = cleanData.padLeft(2 * (cleanData.length / 2).ceil(), '0');
    }

    const fontSize = 15.0;
    const textPadding = 3.0;

    final narrowWidth = itfParams.lineWidth;
    final widedWidth = itfParams.lineWidth * itfParams.wideBarRatio;
    final quietZoneWidth = itfParams.quietZoneRatio * narrowWidth;
    final bearerBarWidth = itfParams.bearerBarRatio * narrowWidth;
    final height = itfParams.withText //
        ? size.height - fontSize - textPadding
        : size.height;

    double offsetX = 0;

    final painter = Paint()..style = PaintingStyle.fill;
    final bearerPainter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = bearerBarWidth;

    //Reuse the bars
    final narrowBar = Rect.fromPoints(Offset.zero, Offset(narrowWidth, height));
    final wideBar = Rect.fromPoints(Offset.zero, Offset(widedWidth, height));

    /// Add quiet zone
    ///
    offsetX += quietZoneWidth;

    /// Draw the start pattern
    ///
    canvas.drawRect(narrowBar.translate(offsetX, 0), painter);
    offsetX += narrowWidth + narrowWidth;
    canvas.drawRect(narrowBar.translate(offsetX, 0), painter);
    offsetX += narrowWidth + narrowWidth;

    for (var x = 0; x < cleanData.length; x += 2) {
      final v0 = int.tryParse(cleanData[x]);
      final v1 = int.tryParse(cleanData[x + 1]);

      //if not a number return
      if (v0 == null || v1 == null) {
        final errorMsg =
            '${cleanData[x]} or ${cleanData[x + 1]} is not a number.';
        if (onError != null) {
          onError!(errorMsg);
        }
        //
        else {
          print(errorMsg);
        }

        return;
      }

      final e0 = encodation[v0];
      final e1 = encodation[v1];

      // print 1 char pair at a time
      for (var y = 4; y >= 0; y--) {
        final ye0 = (e0 >> y) & 1;
        final ye1 = (e1 >> y) & 1;

        canvas.drawRect(
            (ye0 == 0 ? narrowBar : wideBar).translate(offsetX, 0), painter);
        offsetX +=
            ye0 == 0 ? narrowWidth : widedWidth; // push by dark bar width
        offsetX +=
            ye1 == 0 ? narrowWidth : widedWidth; // push by light bar width
      }
    }

    /// Draw the end pattern
    ///
    canvas.drawRect(wideBar.translate(offsetX, 0), painter);
    offsetX += widedWidth + narrowWidth;
    canvas.drawRect(narrowBar.translate(offsetX, 0), painter);
    offsetX += narrowWidth;

    /// Add quiet at end
    ///
    offsetX += quietZoneWidth;

    /// Draw a bearer bar
    ///
    if (itfParams.withBearerBars) {
      canvas.drawRect(Rect.fromLTWH(0, 0, offsetX, height), bearerPainter);
    }

    /// Draw the text
    ///
    if (itfParams.withText) {
      final labelContent = itfParams.altText ?? cleanData;
      final labelText = itfParams.altText == null && labelContent.length == 14
          ? '${cleanData.substring(0, 1)} ${cleanData.substring(1, 3)} ${cleanData.substring(3, 8)} ${cleanData.substring(8, 13)} ${cleanData.substring(13)}'
          : labelContent;

      final span = TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          letterSpacing: 5,
        ),
        text: labelText,
      );

      final textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (offsetX - textPainter.width) / 2, //center the text
          height + textPadding,
        ),
      );
    }
  }

  /// Codabar painter
  ///　referred　JsBarcode
  /// https://github.com/lindell/JsBarcode/blob/master/src/barcodes/codabar/index.js
  void _drawBarCodeCodabar(Canvas canvas, Size size) {
    const bitSet = {
      ...{'0': '101010011', '1': '101011001', '2': '101001011'},
      ...{'3': '110010101', '4': '101101001', '5': '110101001'},
      ...{'6': '100101011', '7': '100101101', '8': '100110101'},
      ...{'9': '110100101', '-': '101001101', '\$': '101100101'},
      ...{':': '1101011011', '/': '1101101011', '.': '1101101101'},
      ...{'+': '101100110011', 'A': '1011001001', 'B': '1001001011'},
      ...{'C': '1010010011', 'D': '1010011001'}
    };

    final data = params!.data;
    final lineWidth = params!.lineWidth;
    final hasText = params!.withText;

    String? bitValue = '';
    bool hasError = false;
    final painter = Paint()..style = PaintingStyle.fill;
    final height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < data.length; i++) {
      if (bitSet.containsKey(data[i])) {
        bitValue = bitSet[data[i]];
      }
      //
      else {
        bitValue = '';
        hasError = true;
      }

      if (hasError) {
        const errorMsg = 'Invalid content for Coddabar. Please check '
            'https://en.wikipedia.org/wiki/Codabar for reference.';

        if (onError != null) {
          onError!(errorMsg);
        }
        //
        else {
          print(errorMsg);
        }

        return;
      }

      for (int j = 0; j < bitValue!.length; j++) {
        final rect = Rect.fromLTWH(
          13 * lineWidth + 13 * i * lineWidth + j * lineWidth,
          0.0,
          lineWidth,
          height,
        );

        (bitValue[j] == '1')
            ? painter.color = Colors.black
            : painter.color = Colors.white;

        canvas.drawRect(rect, painter);
      }
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        final span = TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
          text: data[i],
        );

        final textPainter = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
              (size.width - data.length * 13 * lineWidth) / 2 +
                  13 * i * lineWidth,
              height),
        );
      }
    }
  }
}
