import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        barcodes: [
          BarCodeItem(
            description: "Code39 with text",
            image: BarCodeImage(
              Code39BarCodeParams(
                "CODE39",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "Code39",
            image: BarCodeImage(
              Code39BarCodeParams(
                "CODE39",
              ),
            ),
          ),
          BarCodeItem(
            description: "Code39 with text",
            image: BarCodeImage(
              Code93BarCodeParams(
                "CODE93",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "Code93",
            image: BarCodeImage(
              Code93BarCodeParams(
                "CODE93",
              ),
            ),
          ),
          BarCodeItem(
            description: "Code128 with text",
            image: BarCodeImage(
              Code128BarCodeParams(
                "CODE128",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "Code128",
            image: BarCodeImage(
              Code128BarCodeParams(
                "CODE128",
              ),
            ),
          ),
          BarCodeItem(
            description: "EAN8 with text",
            image: BarCodeImage(
              EAN8BarCodeParams(
                "65833254",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "EAN8",
            image: BarCodeImage(
              EAN8BarCodeParams(
                "65833254",
              ),
            ),
          ),
          BarCodeItem(
            description: "EAN13 with text",
            image: BarCodeImage(
              EAN13BarCodeParams(
                "9501101530003",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "EAN13",
            image: BarCodeImage(
              EAN13BarCodeParams(
                "9501101530003",
              ),
            ),
          ),
          BarCodeItem(
            description: "UPCA with text",
            image: BarCodeImage(
              UPCABarCodeParams(
                "123456789012",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "UPCA",
            image: BarCodeImage(
              UPCABarCodeParams(
                "123456789012",
              ),
            ),
          ),
          BarCodeItem(
            description: "UPCE with text",
            image: BarCodeImage(
              UPCEBarCodeParams(
                "00123457",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "UPCE",
            image: BarCodeImage(
              UPCEBarCodeParams(
                "00123457",
              ),
            ),
          ),
          BarCodeItem(
            description: "ITF with text",
            image: BarCodeImage(
              ITFBarCodeParams(
                "133175398642265258",
                withText: true,
              ),
            ),
          ),
          BarCodeItem(
            description: "ITF",
            image: BarCodeImage(
              ITFBarCodeParams(
                "133175398642265258",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.barcodes});
  final List<BarCodeItem> barcodes;
  final String title = "BarCode Flutter";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: widget.barcodes.map((element) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      element.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: element.image,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BarCodeItem {
  String description;
  BarCodeImage image;
  BarCodeItem({
    this.image,
    this.description,
  });
}
