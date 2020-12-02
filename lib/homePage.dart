import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qrcode/formData.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrcode/scan.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  
  

  GraphQLClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: Text("Welcome to ", style: TextStyle(color: Colors.deepOrange),)),
              Center(child: Text("Product Originality Check - POC", style: TextStyle(color: Colors.green, fontSize: 18),)),
              SizedBox(height: 20.0,),
              Image(image: NetworkImage("https://media.istockphoto.com/vectors/qr-code-scan-phone-icon-in-comic-style-scanner-in-smartphone-vector-vector-id1166145556")),
              fflatButton("Scan QR CODE"),
              SizedBox(height: 20.0,),
               //flatButton("Generate QR CODE", QrDataForm()),
            ],
          ),
        ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue,width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Widget fflatButton(String text) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: () async {
         String codeScanner = await BarcodeScanner.scan();
         final String uuid = codeScanner.toString();
         final DateTime now = DateTime.now();
         final DateFormat formatter = DateFormat('yyyy-MM-dd');
         final String formatted = formatter.format(now);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ScanPage(data : uuid, dat : formatted)));

      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue,width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
