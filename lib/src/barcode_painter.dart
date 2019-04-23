/*
 * Flutter BarCode generator
 * Copyright (c) 2018 the BarCode Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'barcode_enum.dart';

typedef void BarCodeError(dynamic error);

class BarCodePainter extends CustomPainter {
  BarCodePainter(this.data, this.type, this.lineWidth, this.hasText, this.color, {this.onError});

  final Color color;
  final String data;
  final BarCodeType type;
  final double lineWidth;
  final BarCodeError onError;
  final bool hasText;

  @override
  void paint(Canvas canvas, Size size) {
    switch(type) {
      case BarCodeType.Code39: _drawBarCode39(canvas, size); break;
      case BarCodeType.Code93: _drawBarCode93(canvas, size); break;
      case BarCodeType.Code128: _drawBarCode128(canvas, size); break;
      case BarCodeType.CodeEAN13: _drawBarCodeEAN13(canvas, size); break;
      case BarCodeType.CodeEAN8: _drawBarCodeEAN8(canvas, size); break;
      case BarCodeType.CodeUPCA: _drawBarCodeUPCA(canvas, size); break;
      case BarCodeType.CodeUPCE: _drawBarCodeUPCE(canvas, size); break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawBarCode39(Canvas canvas, Size size) {
    final List<int> binSet = [
      0xa6d, 0xd2b, 0xb2b, 0xd95, 0xa6b, 0xd35, 0xb35, 0xa5b,
      0xd2d, 0xb2d, 0xd4b, 0xb4b, 0xda5, 0xacb, 0xd65, 0xb65,
      0xa9b, 0xd4d, 0xb4d, 0xacd, 0xd53, 0xb53, 0xda9, 0xad3,
      0xd69, 0xb69, 0xab3, 0xd59, 0xb59, 0xad9, 0xcab, 0x9ab,
      0xcd5, 0x96b, 0xcb5, 0x9b5, 0x95b, 0xcad, 0x9ad, 0x925,
      0x929, 0x949, 0xa49, 0x96d
    ];

    int codeValue = 0;
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < data.length; i++) {
      switch(data[i]) {
        case '0': codeValue = 0; break;
        case '1': codeValue = 1; break;
        case '2': codeValue = 2; break;
        case '3': codeValue = 3; break;
        case '4': codeValue = 4; break;
        case '5': codeValue = 5; break;
        case '6': codeValue = 6; break;
        case '7': codeValue = 7; break;
        case '8': codeValue = 8; break;
        case '9': codeValue = 9; break;
        case 'A': codeValue = 10; break;
        case 'B': codeValue = 11; break;
        case 'C': codeValue = 12; break;
        case 'D': codeValue = 13; break;
        case 'E': codeValue = 14; break;
        case 'F': codeValue = 15; break;
        case 'G': codeValue = 16; break;
        case 'H': codeValue = 17; break;
        case 'I': codeValue = 18; break;
        case 'J': codeValue = 19; break;
        case 'K': codeValue = 20; break;
        case 'L': codeValue = 21; break;
        case 'M': codeValue = 22; break;
        case 'N': codeValue = 23; break;
        case 'O': codeValue = 24; break;
        case 'P': codeValue = 25; break;
        case 'Q': codeValue = 26; break;
        case 'R': codeValue = 27; break;
        case 'S': codeValue = 28; break;
        case 'T': codeValue = 29; break;
        case 'U': codeValue = 30; break;
        case 'V': codeValue = 31; break;
        case 'W': codeValue = 32; break;
        case 'X': codeValue = 33; break;
        case 'Y': codeValue = 34; break;
        case 'Z': codeValue = 35; break;
        case '-': codeValue = 36; break;
        case '.': codeValue = 37; break;
        case ' ': codeValue = 38; break;
        case '\$': codeValue = 39; break;
        case '/': codeValue = 40; break;
        case '+': codeValue = 41; break;
        case '%': codeValue = 42; break;
        default:
          codeValue = 0;
          hasError = true;
          break;
      }

      if (hasError) {
        String errorMsg = "Invalid content for Code39. Please check https://en.wikipedia.org/wiki/Code_39 for reference.";
        if (this.onError != null) {
          this.onError(errorMsg);
        } else {
          print(errorMsg);
        }
        return ;
      }

      for (int j = 0; j < 12; j++) {
        Rect rect = new Rect.fromLTWH(13*lineWidth+13*i*lineWidth+j*lineWidth, 0.0, lineWidth, height);
        ((0x800 & (binSet[codeValue] << j)) == 0x800) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 12; i++) {
      Rect rect = new Rect.fromLTWH(i*lineWidth, 0.0, lineWidth, height);
      ((0x800 & (binSet[43] << i)) == 0x800) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 12; i++) {
      Rect rect = new Rect.fromLTWH((13+i)*lineWidth+13*(data.length)*lineWidth, 0.0, lineWidth, height);
      ((0x800 & (binSet[43] << i)) == 0x800) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
        TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas, new Offset((size.width - data.length * 13 * lineWidth)/2 + 13*i*lineWidth, height));
      }
    }
  }

  void _drawBarCode93(Canvas canvas, Size size) {
    List<int> binSet = [
      0x8a, 0xa4, 0xa2, 0xa1, 0x94, 0x92, 0x91, 0xa8, 
      0x89, 0x85, 0xd4, 0xd2, 0xd1, 0xca, 0xc9, 0xc5, 
      0xb4, 0xb2, 0xb1, 0x9a, 0x8d, 0xac, 0xa6, 0xa3, 
      0x96, 0x8b, 0xda, 0xd9, 0xd6, 0xd3, 0xcb, 0xcd, 
      0xb6, 0xb3, 0x9b, 0x9d, 0x97, 0xea, 0xe9, 0xe5, 
      0xb7, 0xbb, 0xd7, 0x93, 0xed, 0xeb, 0x99, 0xaf
    ];

    int codeValue = 0, checkCodeC, checkCodeK;
    int sumC = 0, sumK = 0;
    bool hasError = false;
    ByteData strValue = new ByteData(data.length);
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 8; i++) {
      Rect rect = new Rect.fromLTWH(i*lineWidth, 0.0, lineWidth, height);
      ((0x80 & (binSet[47] << i)) == 0x80) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }
        
    for (int i = 0; i < data.length; i++) {
      switch(data[i]) {
        case '0': codeValue = 0; break;
        case '1': codeValue = 1; break;
        case '2': codeValue = 2; break;
        case '3': codeValue = 3; break;
        case '4': codeValue = 4; break;
        case '5': codeValue = 5; break;
        case '6': codeValue = 6; break;
        case '7': codeValue = 7; break;
        case '8': codeValue = 8; break;
        case '9': codeValue = 9; break;
        case 'A': codeValue = 10; break;
        case 'B': codeValue = 11; break;
        case 'C': codeValue = 12; break;
        case 'D': codeValue = 13; break;
        case 'E': codeValue = 14; break;
        case 'F': codeValue = 15; break;
        case 'G': codeValue = 16; break;
        case 'H': codeValue = 17; break;
        case 'I': codeValue = 18; break;
        case 'J': codeValue = 19; break;
        case 'K': codeValue = 20; break;
        case 'L': codeValue = 21; break;
        case 'M': codeValue = 22; break;
        case 'N': codeValue = 23; break;
        case 'O': codeValue = 24; break;
        case 'P': codeValue = 25; break;
        case 'Q': codeValue = 26; break;
        case 'R': codeValue = 27; break;
        case 'S': codeValue = 28; break;
        case 'T': codeValue = 29; break;
        case 'U': codeValue = 30; break;
        case 'V': codeValue = 31; break;
        case 'W': codeValue = 32; break;
        case 'X': codeValue = 33; break;
        case 'Y': codeValue = 34; break;
        case 'Z': codeValue = 35; break;
        case '-': codeValue = 36; break;
        case '.': codeValue = 37; break;
        case ' ': codeValue = 38; break;
        case '\$': codeValue = 39; break;
        case '/': codeValue = 40; break;
        case '+': codeValue = 41; break;
        case '%': codeValue = 42; break;
        default:
          codeValue = 0;
          hasError = true;
          break;
      }

      if (hasError) {
        String errorMsg = "Invalid content for Code93. Please check https://en.wikipedia.org/wiki/Code_93 for reference.";
        if (this.onError != null) {
          this.onError(errorMsg);
        } else {
          print(errorMsg);
        }
        return ;
      }

      strValue.setUint8(i, codeValue);
      sumC += strValue.getUint8(i)*(data.length-i);
      sumK += strValue.getUint8(i)*(data.length-i+1);

      for (int j = 0; j < 8; j++) {
        Rect rect = new Rect.fromLTWH(9*lineWidth+9*i*lineWidth+j*lineWidth, 0.0, lineWidth, height);
        ((0x80 & (binSet[codeValue] << j)) == 0x80) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }
    
    checkCodeC = sumC % 47;
    for (int i = 0; i < 8; i++) {
      Rect rect = new Rect.fromLTWH(9*lineWidth+(data.length*9+i)*lineWidth, 0.0, lineWidth, height);
      ((0x80 & (binSet[checkCodeC]<<i)) == 0x80) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    checkCodeK = (sumK + checkCodeC) % 47;
    for (int i = 0; i < 8; i++) {
      Rect rect = new Rect.fromLTWH(9*lineWidth+((data.length+1)*9+i)*lineWidth, 0.0, lineWidth, height);
      ((0x80 & (binSet[checkCodeK] << i)) == 0x80) ? painter.color = Colors.black : painter.color = Colors.white;  
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 8; i++) {
      Rect rect = new Rect.fromLTWH(9*lineWidth+((data.length+2)*9+i)*lineWidth, 0.0, lineWidth, height);
      ((0x80 & (binSet[47] << i)) == 0x80) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 8; i++) {
      Rect rect = new Rect.fromLTWH(9*lineWidth+((data.length+3)*9+i)*lineWidth, 0.0, lineWidth, height);
      ((0x80 & (binSet[1] << i)) == 0x80) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
        TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas, new Offset((size.width-data.length*8*lineWidth)/2 + 8*i*lineWidth, height));
      }
    }
  }

  void _drawBarCode128(Canvas canvas, Size size) {
    List<int> code128 = [
      0x6cc, 0x66c, 0x666, 0x498, 0x48c, 0x44c, 0x4c8, 0x4c4,
      0x464, 0x648, 0x644, 0x624, 0x59c, 0x4dc, 0x4ce, 0x5cc,
      0x4ec, 0x4e6, 0x672, 0x65c, 0x64e, 0x6e4, 0x674, 0x76e,
      0x74c, 0x72c, 0x726, 0x764, 0x734, 0x732, 0x6d8, 0x6c6,
      0x636, 0x518, 0x458, 0x446, 0x588, 0x468, 0x462, 0x688,
      0x628, 0x622, 0x5b8, 0x58e, 0x46e, 0x5d8, 0x5c6, 0x476,
      0x776, 0x68e, 0x62e, 0x6e8, 0x6e2, 0x6ee, 0x758, 0x746,
      0x716, 0x768, 0x762, 0x71a, 0x77a, 0x642, 0x78a, 0x530,
      0x50c, 0x4b0, 0x486, 0x42c, 0x426, 0x590, 0x584, 0x4d0,
      0x4c2, 0x434, 0x432, 0x612, 0x650, 0x7ba, 0x614, 0x47a,
      0x53c, 0x4bc, 0x49e, 0x5e4, 0x4f4, 0x4f2, 0x7a4, 0x794,
      0x792, 0x6de, 0x6f6, 0x7b6, 0x578, 0x51e, 0x45e, 0x5e8,
      0x5e2, 0x7a8, 0x7a2, 0x5de, 0x5ee, 0x75e, 0x7a2, 0x684,
      0x690, 0x69c
    ];

    int codeValue, checkCode, strlen = data.length;
    ByteData strValue = new ByteData(strlen);
    int sum = 0, startValue = 0x690, endFlag = 0x18eb;
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 11; i++) {
      Rect rect = new Rect.fromLTWH(i*lineWidth, 0.0, lineWidth, height);
      ((0x400 & (startValue << i)) == 0x400) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < strlen; i++) {
      switch(data[i]) {
        case ' ': codeValue = 0; break; case '!': codeValue = 1; break; case '"': codeValue = 2; break;
        case '#': codeValue = 3; break; case '\$': codeValue = 4; break; case '%': codeValue = 5; break;
        case '&': codeValue = 6; break; case '…': codeValue = 7; break; case '(': codeValue = 8; break;  
        case ')': codeValue = 9; break; case '*': codeValue = 10; break; case '+': codeValue = 11; break;
        case ',': codeValue = 12; break; case '-': codeValue = 13; break; case '.': codeValue = 14; break; 
        case '/': codeValue = 15; break; case '0': codeValue = 16; break; case '1': codeValue = 17; break;  
        case '2': codeValue = 18; break; case '3': codeValue = 19; break; case '4': codeValue = 20; break; 
        case '5': codeValue = 21; break; case '6': codeValue = 22; break; case '7': codeValue = 23; break;
        case '8': codeValue = 24; break; case '9': codeValue = 25; break; case ':': codeValue = 26; break; 
        case ';': codeValue = 27; break; case '<': codeValue = 28; break; case '=': codeValue = 29; break;  
        case '>': codeValue = 30; break; case '?': codeValue = 31; break; case '@': codeValue = 32; break; 
        case 'A': codeValue = 33; break; case 'B': codeValue = 34; break; case 'C': codeValue = 35; break;
        case 'D': codeValue = 36; break; case 'E': codeValue = 37; break; case 'F': codeValue = 38; break; 
        case 'G': codeValue = 39; break; case 'H': codeValue = 40; break; case 'I': codeValue = 41; break;  
        case 'J': codeValue = 42; break; case 'K': codeValue = 43; break; case 'L': codeValue = 44; break; 
        case 'M': codeValue = 45; break; case 'N': codeValue = 46; break; case 'O': codeValue = 47; break;
        case 'P': codeValue = 48; break; case 'Q': codeValue = 49; break; case 'R': codeValue = 50; break; 
        case 'S': codeValue = 51; break; case 'T': codeValue = 52; break; case 'U': codeValue = 53; break;  
        case 'V': codeValue = 54; break; case 'W': codeValue = 55; break; case 'X': codeValue = 56; break; 
        case 'Y': codeValue = 57; break; case 'Z': codeValue = 58; break; case '[': codeValue = 59; break;
        case '、': codeValue = 60; break; case ']': codeValue = 61; break; case '^': codeValue = 62; break; 
        case '_': codeValue = 63; break; case '`': codeValue = 64; break; case 'a': codeValue = 65; break;   
        case 'b': codeValue = 66; break; case 'c': codeValue = 67; break; case 'd': codeValue = 68; break; 
        case 'e': codeValue = 69; break; case 'f': codeValue = 70; break; case 'g': codeValue = 71; break;
        case 'h': codeValue = 72; break; case 'i': codeValue = 73; break;  case 'j': codeValue = 74; break; 
        case 'k': codeValue = 75; break; case 'l': codeValue = 76; break; case 'm': codeValue = 77; break;  
        case 'n': codeValue = 78; break; case 'o': codeValue = 79; break; case 'p': codeValue = 80; break; 
        case 'q': codeValue = 81; break; case 'r': codeValue = 82; break; case 's': codeValue = 83; break;
        case 't': codeValue = 84; break; case 'u': codeValue = 85; break; case 'v': codeValue = 86; break; 
        case 'w': codeValue = 87; break; case 'x': codeValue = 88; break; case 'y': codeValue = 89; break; 
        case 'z': codeValue = 90; break; case '{': codeValue = 91; break; case '|': codeValue = 92; break; 
        case '}': codeValue = 93; break; case '~': codeValue = 94; break;
        default: hasError = true; break;
      }

      if (hasError) {
        String errorMsg = "Invalid content for Code128. Please check https://en.wikipedia.org/wiki/Code_128 for reference.";
        if (this.onError != null) {
          this.onError(errorMsg);
        } else {
          print(errorMsg);
        }
        return ;
      }

      strValue.setUint8(i, codeValue);
      sum += strValue.getUint8(i)*(i+1);
      for (int j = 0; j < 11; j++) {
        Rect rect = new Rect.fromLTWH(11*lineWidth+11*i*lineWidth+j*lineWidth, 0.0, lineWidth, height);
        ((0x400 & (code128[codeValue] << j)) == 0x400) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    checkCode = (sum + 104) % 103;
    for (int i = 0; i < 11; i++) {
      Rect rect = new Rect.fromLTWH(11*lineWidth+(strlen*11+i)*lineWidth, 0.0, lineWidth, height);
      ((0x400 & (code128[checkCode] << i)) == 0x400) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 13; i++) {
      Rect rect = new Rect.fromLTWH(22*lineWidth+(strlen*11+i)*lineWidth, 0.0, lineWidth, height);
      ((0x1000 & (endFlag << i)) == 0x1000) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
        TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas, new Offset((size.width - data.length*8*lineWidth)/2+8*i*lineWidth, height));
      }
    }
  }

  void _drawBarCodeEAN13(Canvas canvas, Size size) {
    List<int> codeA = [0x0d, 0x19, 0x13, 0x3d, 0x23, 0x31, 0x2f, 0x3b, 0x37, 0x0b];  
    List<int> codeB = [0x27, 0x33, 0x1b, 0x21, 0x1d, 0x39, 0x05, 0x11, 0x09, 0x17];  
    List<int> codeC = [0x72, 0x66, 0x6c, 0x42, 0x5c, 0x4e, 0x50, 0x44, 0x48, 0x74];  
    List<int> flagCode = [0x00, 0x0b, 0x0d, 0x0e, 0x13, 0x19, 0x1c, 0x15, 0x17, 0x1a]; 
    int startCodeSep = 0x05, midCodeSep = 0x0a, endCodeSep = 0x05;
    int tmpCode, tmpBarCode, checkCode, sum2nd, sum3rd, flagbit, strlen = data.length;
    ByteData st = new ByteData(12);
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    if (strlen > 12) {
      strlen = 13;
    } else {
      hasError = true;
    }

    for (int i = 0; i < 12; i++) {
      st.setUint8(i, data.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
      }
    }

    if (hasError) {
      String errorMsg = "Invalid content for code EAN13. Please check https://en.wikipedia.org/wiki/International_Article_Number for reference.";
      if (this.onError != null) {
        this.onError(errorMsg);
      } else {
        print(errorMsg);
      }
      return ;
    }

    for (int j = 0; j < 3; j++) {
      Rect rect = new Rect.fromLTWH(11*lineWidth+j*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (startCodeSep >> j)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 7; i++) {
      tmpCode = data.codeUnitAt(i) - 48;
      if (i == 0) {
        flagbit = tmpCode;
      } else {
        if ((0x20 & (flagCode[flagbit] << (i-1))) == 0) {
          for (int j = 0; j < 7; j++) {
            Rect rect = new Rect.fromLTWH(14*lineWidth+7*(i-1)*lineWidth+j*lineWidth, 0.0, lineWidth, height);
            ((0x40 & (codeA[tmpCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
            canvas.drawRect(rect, painter);
          }
        } else {
          for (int n = 0; n < 7; n++) {
            Rect rect = new Rect.fromLTWH(14*lineWidth+7*(i-1)*lineWidth+n*lineWidth, 0.0, lineWidth, height);
            ((0x40 & (codeB[tmpCode] << n)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
            canvas.drawRect(rect, painter);
          }
        }
      }
    }

    for (int i = 0; i < 5; i++) {
      Rect rect = new Rect.fromLTWH(56*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (midCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 5; i++) {
      tmpBarCode = data.codeUnitAt(i+7) - 48;
      for (int j = 0; j < 7; j++) {
        Rect rect = new Rect.fromLTWH(61*lineWidth+j*lineWidth+7*i*lineWidth, 0.0, lineWidth, height);
        ((0x40 & (codeC[tmpBarCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    sum3rd = st.getUint8(0) + st.getUint8(2) + st.getUint8(4) + st.getUint8(6) + st.getUint8(8) + st.getUint8(10);
    sum2nd = st.getUint8(1) + st.getUint8(3) + st.getUint8(5) + st.getUint8(7) + st.getUint8(9) + st.getUint8(11);
    if ((sum2nd * 3 + sum3rd) % 10 == 0) {
      checkCode = 0;
    } else {
      checkCode = 10 - (sum2nd * 3 + sum3rd) % 10;
    }

    for (int i = 0; i < 7; i++) {
      Rect rect = new Rect.fromLTWH(96*lineWidth+i*lineWidth, 0.0, lineWidth, height);
      ((0x40 & (codeC[checkCode] << i)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 3; i++) {
      Rect rect = new Rect.fromLTWH(103*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (endCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      (data.length > 13) ? strlen = 13 : strlen = data.length;
      for (int i = 0; i < strlen; i++) {
        if (i == 0) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(2*lineWidth, height));
        } else if (i < 7) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(13*lineWidth+7*(i-1)*lineWidth, height));
        } else if (i == 12) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: checkCode.toString());
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(17*lineWidth+7*(i-1)*lineWidth, height));
        } else {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(17*lineWidth+7*(i-1)*lineWidth, height));
        }
      }
    }
  }

  void _drawBarCodeEAN8(Canvas canvas, Size size) {
    List<int> codeA = [0x0d, 0x19, 0x13, 0x3d, 0x23, 0x31, 0x2f, 0x3b, 0x37, 0x0b];
    List<int> codeC = [0x72, 0x66, 0x6c, 0x42, 0x5c, 0x4e, 0x50, 0x44, 0x48, 0x74];
    int startCodeSep = 0x05, midCodeSep = 0x0a, endCodeSep = 0x05;
    int tmpCode, tmpBarCode, checkCode, sum2nd, sum3rd, strlen = data.length;
    ByteData st = new ByteData(7);
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 7; i++) {
      st.setUint8(i, data.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
      }
    }

    if (hasError) {
      String errorMsg = "Invalid content for code EAN8. Please check https://en.wikipedia.org/wiki/EAN-8 for reference.";
      if (this.onError != null) {
        this.onError(errorMsg);
      } else {
        print(errorMsg);
      }
      return ;
    }

    for (int i = 0; i < 3; i++) {
      Rect rect = new Rect.fromLTWH(7*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (startCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 4; i++) {
      tmpCode = data.codeUnitAt(i)-48;
      for (int j = 0; j < 7; j++) {
        Rect rect = new Rect.fromLTWH(10*lineWidth+j*lineWidth+7*i*lineWidth, 0.0, lineWidth, height);
        ((0x40 & (codeA[tmpCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 5; i++) {
      Rect rect = new Rect.fromLTWH(38*lineWidth+i*lineWidth, 0.0, lineWidth, height);
      ((0x01 & (midCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 4; i < 7; i++) {
      tmpBarCode = data.codeUnitAt(i) - 48;
      for (int j = 0; j < 7; j++) {
        Rect rect = new Rect.fromLTWH(43*lineWidth+j*lineWidth+7*(i-4)*lineWidth, 0.0, lineWidth, height);
        ((0x40 & (codeC[tmpBarCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    sum2nd = st.getUint8(6) + st.getUint8(4) + st.getUint8(2) + st.getUint8(0);
    sum3rd = st.getUint8(5) + st.getUint8(3) + st.getUint8(1);
    checkCode = 10 - (sum2nd*3+sum3rd) % 10;
    for (int i = 0; i < 7; i++) {
      Rect rect = new Rect.fromLTWH(64*lineWidth+i*lineWidth, 0.0, lineWidth, height);
      ((0x40 & (codeC[checkCode] << i)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 3; i++) {
      Rect rect = new Rect.fromLTWH(71*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (endCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      strlen > 8 ? strlen = 8 : strlen = data.length;
      for (int i = 0; i < strlen; i++) {
        if (i < 4) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(11*lineWidth+7*i*lineWidth, height));
        } else if (i == 7) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: checkCode.toString());
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(15*lineWidth+7*i*lineWidth, height));
        } else {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(15*lineWidth+7*i*lineWidth, height));
        }
      }
    }
  }

  void _drawBarCodeUPCA(Canvas canvas, Size size) {
    List<int> codeA = [0x0d, 0x19, 0x13, 0x3d, 0x23, 0x31, 0x2f, 0x3b, 0x37, 0x0b];
    List<int> codeC = [0x72, 0x66, 0x6c, 0x42, 0x5c, 0x4e, 0x50, 0x44, 0x48, 0x74];
    int startCodeSep = 0x05, midCodeSep = 0x0a, endCodeSep = 0x05;
    int tmpCode, tmpBarCode, checkCode, sum2nd, sum3rd, strlen = data.length;
    ByteData st = new ByteData(11);
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    for (int i = 0; i < 11; i++) {
      st.setUint8(i, data.codeUnitAt(i) - 48);
      if (st.getUint8(i) > 9) {
        hasError = true;
      }
    }

    if (hasError) {
      String errorMsg = "Invalid content for coe UPC-A. Please check https://en.wikipedia.org/wiki/Universal_Product_Code for reference.";
      if (this.onError != null) {
        this.onError(errorMsg);
      } else {
        print(errorMsg);
      }
      return ;
    }

    for (int i = 0; i < 3; i++) {
      Rect rect = new Rect.fromLTWH(9*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (startCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 6; i++) {
      tmpCode = data.codeUnitAt(i) - 48;
      for (int j = 0; j < 7; j++) {
        Rect rect = new Rect.fromLTWH(12*lineWidth+7*i*lineWidth+j*lineWidth, 0.0,lineWidth, height);
        ((0x40 & (codeA[tmpCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 5; i++) {
      Rect rect = new Rect.fromLTWH(54*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (midCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 5; i++) {
      tmpBarCode = data.codeUnitAt(i+6) - 48;
      for (int j = 0; j < 7; j++) {
        Rect rect = new Rect.fromLTWH(59*lineWidth+j*lineWidth+7*i*lineWidth, 0.0, lineWidth, height);
        ((0x40 & (codeC[tmpBarCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    sum3rd = st.getUint8(0) + st.getUint8(2) + st.getUint8(4) + st.getUint8(6) + st.getUint8(8) + st.getUint8(10);
    sum2nd = st.getUint8(1) + st.getUint8(3) + st.getUint8(5) + st.getUint8(7) + st.getUint8(9);
    if ((sum2nd + sum3rd * 3) % 10 == 0) {
      checkCode = 0;
    } else {
      checkCode = 10 - (sum2nd + sum3rd * 3) % 10;
    }

    for (int i = 0; i < 7; i++) {
      Rect rect = new Rect.fromLTWH(94*lineWidth+i*lineWidth, 0.0, lineWidth, height);
      ((0x40 & (codeC[checkCode] << i)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 3; i++) {
      Rect rect = new Rect.fromLTWH(101*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x01 & (endCodeSep >> i)) == 0x01) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      strlen > 12 ? strlen = 12 : strlen = data.length;
      for (int i = 0; i < strlen; i++) {
        if (i == 0) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(3*lineWidth, height));
        } else if (i < 6) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(16*lineWidth+7*(i-1)*lineWidth, height));
        } else if (i < 11) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(26*lineWidth+7*(i-1)*lineWidth, height));
        } else {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: checkCode.toString());
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(35*lineWidth+7*(i-1)*lineWidth, height));
        }
      }
    }
  }

  void _drawBarCodeUPCE(Canvas canvas, Size size) {
    List<int> codeA = [0x0d, 0x19, 0x13, 0x3d, 0x23, 0x31, 0x2f, 0x3b, 0x37, 0x0b];
    List<int> codeB = [0x27, 0x33, 0x1b, 0x21, 0x1d, 0x39, 0x05, 0x11, 0x09, 0x17];
    List<int> checkCodeFlag = [0x38, 0x34, 0x32, 0x31, 0x2c, 0x26, 0x23, 0x2a, 0x29, 0x25];
    int startCodeSep = 0x05, endCodeSep = 0x15;
    int tmpCode, checkCode, sum2nd, sum3rd, strlen;
    ByteData st = new ByteData(11);

    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;

    if (data.length != 8) {
      hasError = true;
    } 

    String upce2upca;
    switch(data.codeUnitAt(6) - 48) {
      case 0:
        upce2upca = data[0] + data[1] + data[2] + '00000' + data[3] + data[4] + data[5];
        break;
      case 1:
      case 2:
        upce2upca = data[0] + data[1] + data[2] + data[6] + '00000' + data[4] + data[5];
        break;
      case 3:
        upce2upca = data[0] + data[1] + data[2] + data[3] + '00000' + data[4] + data[5];
        break;
      case 4:
        upce2upca = data[0] + data[1] + data[2] + data[3] + data[4] + '00000' + data[5];
        break;
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        upce2upca = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + '0000' + data[6];
        break;
      default:
        break;
    }

    for (int i = 0; i < 11; i++) {
      st.setUint8(i, upce2upca.codeUnitAt(i)-48);
      if (st.getUint8(i) > 9) {
        hasError = true;
        break;
      }
    }

    if (hasError) {
      String errorMsg = "Invalid content for code UPCE. Please check https://en.wikipedia.org/wiki/Universal_Product_Code#UPC-E for reference.";
      if (this.onError != null) {
        this.onError(errorMsg);
      } else {
        print(errorMsg);
      }
      return ;
    }

    for (int i = 0; i < 3; i++) {
      Rect rect = new Rect.fromLTWH(8*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x04 & (startCodeSep << i)) == 0x04) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    sum3rd = st.getUint8(0) + st.getUint8(2) + st.getUint8(4) + st.getUint8(6) + st.getUint8(8) + st.getUint8(10);
    sum2nd = st.getUint8(1) + st.getUint8(3) + st.getUint8(5) + st.getUint8(7) + st.getUint8(9);
    if ((sum2nd + sum3rd * 3) % 10 == 0) {
      checkCode = 0;
    } else {
      checkCode = 10 - (sum2nd + sum3rd * 3) % 10;
    }

    for (int i = 0; i < 6; i++) {
      tmpCode = data.codeUnitAt(i+1) - 48;
      if ((0x20 & (checkCodeFlag[checkCode] << i)) == 0x20) {
        for (int j = 0; j < 7; j++) {
          Rect rect = new Rect.fromLTWH(11*lineWidth+7*i*lineWidth+j*lineWidth, 0.0, lineWidth, height);
          ((0x40 & (codeB[tmpCode] << j)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
          canvas.drawRect(rect, painter);
        }
      } else {
        for (int k = 0; k < 7; k++) {
          Rect rect = new Rect.fromLTWH(11*lineWidth+7*i*lineWidth+k*lineWidth, 0.0, lineWidth, height);
          ((0x40 & (codeA[tmpCode] << k)) == 0x40) ? painter.color = Colors.black : painter.color = Colors.white;
          canvas.drawRect(rect, painter);
        }
      }
    }

    for (int i = 0; i < 6; i++) {
      Rect rect = new Rect.fromLTWH(53*lineWidth+i*lineWidth, 0.0, lineWidth, hasText ? height*1.08 : height);
      ((0x20 & (endCodeSep << i)) == 0x20) ? painter.color = Colors.black : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      (data.length > 8) ? strlen = 8 : strlen = data.length;
      for (int i = 0; i < strlen; i++) {
        if (i == 0) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(2*lineWidth, height));
        } else if (i < 7) {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: data[i]);
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(12*lineWidth+7*(i-1)*lineWidth, height));
        } else {
          TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15.0), text: checkCode.toString());
          TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, new Offset(60*lineWidth, height));
        }
      }
    }
  }
}
