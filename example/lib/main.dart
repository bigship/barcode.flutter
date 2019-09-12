import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(codeList: [
        new BarCodeItem(type: BarCodeType.Code39, codeStr: "CODE39", description: "Code39 with text", hasText: true),
        new BarCodeItem(type: BarCodeType.Code39, codeStr: "CODE39", description: "Code39", hasText: false),
        new BarCodeItem(type: BarCodeType.Code93, codeStr: "BARCODE93", description: "Code93 with text", hasText: true),
        new BarCodeItem(type: BarCodeType.Code93, codeStr: "BARCODE93", description: "Code93", hasText: false),
        new BarCodeItem(type: BarCodeType.Code128, codeStr: "BARCODE128", description: "Code128 with text", hasText: true),
        new BarCodeItem(type: BarCodeType.Code128, codeStr: "BARCODE128", description: "Code128", hasText: false),
        new BarCodeItem(type: BarCodeType.CodeEAN8, codeStr: "65833254", description: "EAN8 with text", hasText: true),
        new BarCodeItem(type: BarCodeType.CodeEAN8, codeStr: "65833254", description: "EAN8", hasText: false),
        new BarCodeItem(type: BarCodeType.CodeEAN13, codeStr: "9501101530003", description: "EAN13 with text", hasText: true),
        new BarCodeItem(type: BarCodeType.CodeEAN13, codeStr: "9501101530003", description: "EAN13", hasText: false),
        new BarCodeItem(type: BarCodeType.CodeUPCA, codeStr: "123456789012", description: "UPCA with text", hasText: true),
        new BarCodeItem(type: BarCodeType.CodeUPCA, codeStr: "123456789012", description: "UPCA", hasText: false),
        new BarCodeItem(type: BarCodeType.CodeUPCE, codeStr: "00123457", description: "UPCE with text", hasText: true),
        new BarCodeItem(type: BarCodeType.CodeUPCE, codeStr: "00123457", description: "UPCE", hasText: false),
      ],)
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.codeList}) : super(key: key);
  final List<BarCodeItem> codeList;
  final String title = "BarCode Flutter";

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: widget.codeList.map((element) {
          return new Padding(padding: const EdgeInsets.all(10.0),
            child: new Card(
              child: new Column(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(element.description,
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black45),
                    ),
                  ),
                  new Center(child:
                    new Container(padding: const EdgeInsets.all(10.0),
                      child: new BarCodeImage(
                        data:element.codeStr,
                        codeType: element.type,
                        width: 200.0,
                        height: 100.0,
                        hasText: element.hasText,
                        onError: (error) {
                          print("Generate barcode failed. error msg: $error");
                        },
                      ),
                    )
                  )
                ]
              )
          ),) ;
        }
      ).toList()
    ));
  }
}

class BarCodeItem {
  BarCodeType type;
  String codeStr;
  String description;
  bool hasText;
  BarCodeItem({this.type, this.codeStr, this.description, this.hasText});
}
