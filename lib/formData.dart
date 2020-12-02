import 'package:flutter/material.dart';
import 'package:qrcode/generate.dart';
import 'package:qrcode/widget.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class QrDataForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final HttpLink httpLink =
      HttpLink(uri: "https://devmac.herokuapp.com/v1/graphql");
      final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
          link: httpLink as Link,
          cache: OptimisticCache(
            dataIdFromObject: typenameDataIdFromObject,
          ),
        ),
      );
      return GraphQLProvider(
        child: QrData(),
        client: client,
      );
    }
  }



class QrData extends StatefulWidget {
  @override
  _QrDataState createState() => _QrDataState();
}

class _QrDataState extends State<QrData> {


  TextEditingController _productNameController = TextEditingController();

  TextEditingController _productionNameController = TextEditingController();

  String v1 = Uuid().v1();

  final String query = r'''
  mutation insertFormData($pname: String!,$proname: String!, $uuid: String!, $ver: Int!){
  insert_qrdata(objects: {productname: $pname, productionname: $proname, uuid: $uuid, verified: $ver}){
  returning {
      created
      id
      productname
      productionname
      uuid
      verified
    }
  }
  }''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Qr Generate Data Form"),
      ),
      body: Mutation(
        options: MutationOptions(

          // ignore: deprecated_member_use
          document: query,
        ),
        builder:(RunMutation runMutation, QueryResult result) {
          return Column(
          children: <Widget>[
          SizedBox(height: 10,),
          AppTextFormField(
          controller: _productNameController,
          hintText: "Enter Product Name",
          // helpText: "Enter ur Name",
          suffixIcon: Icons.verified_user,
          enabled: true,
          ),
          SizedBox(height: 3,),
          AppTextFormField(
          controller: _productionNameController,
          hintText: "Enter Production Name",
          // helpText: "Enter ur Password",
          suffixIcon: Icons.security,

          enabled: true,
          ),

          RaisedButton(
          onPressed: () async  {
            await runMutation(<String, dynamic>{
            "pname":_productNameController.text,
            "proname": _productionNameController.text,
            "uuid": v1,
            "ver": 1
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GenerateScreen(dataText: v1)));
          print(v1);
          print(_productionNameController.text);
          print(_productNameController.text);
          },
          child: Text(
          "Generate QR",
          style: TextStyle(
          color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
          ),
          ],
          );
        },

      ),
    );
  }
}

