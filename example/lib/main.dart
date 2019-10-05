import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        codeList: [
          BarCodeItem(
            type: BarCodeType.Code39,
            codeStr: "CODE39",
            description: "Code39 with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.Code39,
            codeStr: "CODE39",
            description: "Code39",
            hasText: false,
          ),
          BarCodeItem(
            type: BarCodeType.Code93,
            codeStr: "BARCODE93",
            description: "Code93 with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.Code93,
            codeStr: "BARCODE93",
            description: "Code93",
            hasText: false,
          ),
          BarCodeItem(
            type: BarCodeType.Code128,
            codeStr: "BARCODE128",
            description: "Code128 with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.Code128,
            codeStr: "BARCODE128",
            description: "Code128",
            hasText: false,
          ),
          BarCodeItem(
            type: BarCodeType.CodeEAN8,
            codeStr: "65833254",
            description: "EAN8 with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.CodeEAN8,
            codeStr: "65833254",
            description: "EAN8",
            hasText: false,
          ),
          BarCodeItem(
            type: BarCodeType.CodeEAN13,
            codeStr: "9501101530003",
            description: "EAN13 with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.CodeEAN13,
            codeStr: "9501101530003",
            description: "EAN13",
            hasText: false,
          ),
          BarCodeItem(
            type: BarCodeType.CodeUPCA,
            codeStr: "123456789012",
            description: "UPCA with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.CodeUPCA,
            codeStr: "123456789012",
            description: "UPCA",
            hasText: false,
          ),
          BarCodeItem(
            type: BarCodeType.CodeUPCE,
            codeStr: "00123457",
            description: "UPCE with text",
            hasText: true,
          ),
          BarCodeItem(
            type: BarCodeType.CodeUPCE,
            codeStr: "00123457",
            description: "UPCE",
            hasText: false,
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.codeList}) : super(key: key);
  final List<BarCodeItem> codeList;
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
        children: widget.codeList.map((element) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.blueGrey[50],
              child: Padding(
                padding: EdgeInsets.all(8.0),
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
                        child: BarCodeImage(
                          // backgroundColor: Colors.red,
                          // foregroundColor: Colors.deepPurple,
                          data: element.codeStr,
                          codeType: element.type,
                          lineWidth: 2.0,
                          barHeight: 100.0,
                          hasText: element.hasText,
                          onError: (error) {
                            print("Generate barcode failed. error msg: $error");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BarCodeItem {
  BarCodeType type;
  String codeStr;
  String description;
  bool hasText;
  BarCodeItem({this.type, this.codeStr, this.description, this.hasText});
}
