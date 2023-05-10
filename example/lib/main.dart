///
/// Flutter BarCode Widget
/// Copyright (c) 2018 the BarCode Flutter authors.
/// See LICENSE for distribution and usage details.
///
// ignore_for_file: use_key_in_widget_constructors

library barcode_flutter_example;

import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';

///
///
void main() => runApp(const MyApp());

///
///
///
class MyApp extends StatelessWidget {
  ///
  const MyApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Barcode Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        //
        home: MyHomePage(
          barcodes: [
            //
            BarCodeItem(
              description: 'Code39 with text',
              image: BarCodeImage(
                params: Code39BarCodeParams('CODE39', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'Code39',
              image: BarCodeImage(
                params: Code39BarCodeParams('CODE39'),
              ),
            ),
            //
            BarCodeItem(
              description: 'Code39 with text',
              image: BarCodeImage(
                params: Code93BarCodeParams('CODE93', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'Code93',
              image: BarCodeImage(
                params: Code93BarCodeParams('CODE93'),
              ),
            ),
            //
            BarCodeItem(
              description: 'Code128 with text',
              image: BarCodeImage(
                params: Code128BarCodeParams('CODE128', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'Code128',
              image: BarCodeImage(
                params: Code128BarCodeParams('CODE128'),
              ),
            ),
            //
            BarCodeItem(
              description: 'EAN8 with text',
              image: BarCodeImage(
                params: EAN8BarCodeParams('65833254', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'EAN8',
              image: BarCodeImage(
                params: EAN8BarCodeParams('65833254'),
              ),
            ),
            //
            BarCodeItem(
              description: 'EAN13 with text',
              image: BarCodeImage(
                params: EAN13BarCodeParams('9501101530003', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'EAN13',
              image: BarCodeImage(
                params: EAN13BarCodeParams('9501101530003'),
              ),
            ),
            //
            BarCodeItem(
              description: 'UPCA with text',
              image: BarCodeImage(
                params: UPCABarCodeParams('123456789012', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'UPCA',
              image: BarCodeImage(
                params: UPCABarCodeParams('123456789012'),
              ),
            ),
            //
            BarCodeItem(
              description: 'UPCE with text',
              image: BarCodeImage(
                params: UPCEBarCodeParams('00123457', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'UPCE',
              image: BarCodeImage(
                params: UPCEBarCodeParams('00123457'),
              ),
            ),
            //
            BarCodeItem(
              description: 'ITF with text',
              image: BarCodeImage(
                params: ITFBarCodeParams('133175398642265258', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'ITF',
              image: BarCodeImage(
                params: ITFBarCodeParams('133175398642265258'),
              ),
            ),
            //
            BarCodeItem(
              description: 'Codabar with text',
              image: BarCodeImage(
                params: CodabarBarCodeParams('A123456789B', withText: true),
              ),
            ),
            //
            BarCodeItem(
              description: 'Codabar',
              image: BarCodeImage(
                params: CodabarBarCodeParams('A123456789B'),
              ),
            ),
          ],
        ),
      );
}

///
///
///
class MyHomePage extends StatefulWidget {
  ///
  const MyHomePage({required this.barcodes, this.title = 'BarCode Flutter'});

  ///
  final List<BarCodeItem> barcodes;

  ///
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

///
///
///
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(title: Text(widget.title)),
      //
      body: ListView(
        children: widget.barcodes
            .map(
              (element) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  //
                  child: Column(
                    children: <Widget>[
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          element.description,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      //
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: element.image,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

///
///
///
class BarCodeItem {
  ///
  BarCodeItem({required this.image, required this.description});

  ///
  String description;

  ///
  BarCodeImage image;
}
