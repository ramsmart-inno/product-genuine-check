import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';


class ScanPage extends StatelessWidget {
  ScanPage({Key key, this.data, this.dat}) : super(key: key);
  var data;
  String dat;
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
      child: ViewToast(verify: data,date: dat,),
      client: client,
    );
  }
}

class ViewToast extends StatelessWidget {

  ViewToast({Key key, this.verify, this.date}) : super(key: key);
  String verify;
  String date;

  final String query = r"""
                    query MyQuery($uuid: String!) {
  qrdata(where: {uuid: {_eq: $uuid}}, limit: 1) {
    verified
    productname
    scannedat
    created
  }
}
                  """;

  final String mutation = r''' mutation MyMutation($uid: String!, $dT: String!) {
  __typename
  update_qrdata(where: {uuid: {_eq: $uid}}, _set: {verified: 2, scannedat: $dT}) {
    returning {
      id
      productname
    }
  }
}''';


  static GraphQLClient _client;

  runOnlineMutation(context) {
    _client = GraphQLProvider.of(context).value;
    Future.doWhile(
          () async {
        _client.mutate(
          MutationOptions(
            documentNode: gql(mutation, ),
            variables: <String, dynamic>{"uid": verify, "dT":date},
          ),
        );
        await Future.delayed(Duration(seconds: 30));
        return true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Validation Page"),
      ),
      body: Query(
        options: QueryOptions(
            // ignore: deprecated_member_use
            document: query,variables: <String, dynamic>{"uuid": verify}),
        builder: (
            QueryResult result, {
              VoidCallback refetch,
              FetchMore fetchMore
            }) {
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.data == null) {
            return Text("No Data Found !");
          }
          final r = result.data['qrdata'];
          //
          return ListView.builder(
            padding: const EdgeInsets.only(top:150.0),
            itemBuilder: (BuildContext context, int index) {
              dynamic responseData = r[index];
              if (responseData['verified'] == 2) {
                return Center(
                  child: Container(
                    height: 300,
                          width: 300,
                          color: Colors.amber,
                          child:Text((() {
                            if(responseData['verified'] == 2){
                              return "\n"
                                  "\n"
                                  "Thank You for Choosing Us. \n"
                                  "But, it might be a Duplicate Product.  \n"
                                  "\n"
                                  "Product = ${responseData['productname']} \n"
                                  "\n"
                                  " Manufactured On = ${responseData['created'].toString()}\n"
                                  " \n"
                                  "is already done a Genuine Check on ${responseData['scannedat']}. \n"
                                  "Contact our customer care to Portal \n"
                                  "@ 91-9680-4567-986 \n"
                                  "to help our \n"
                                  "brand from Duplicate product circulation under our brand name";
                            }
                            return "";

                          })()),
                      ),
                );
                
              }
              else if (responseData['verified'] == 1){
                return Center(
                    child: Container(
                      height: 300,
                            width: 300,
                            color: Colors.amber,
                            child:Center(
                              child: Column(
                                children: <Widget>[
                                  Text("Thank You - You Bought a Original \n"
                                      "Product = ${responseData['productname']} | Manufactured On = ${responseData['created'].toString()}\n"
                                      "& you got a CashBack of \n"
                                      "Rs. 13.00 INR \n"
                                      "which will credited to your bank account soon"),
                                  Container(
                                    child: runOnlineMutation(context),
                                  ),
                                ],
                              ),
                            ),
                        ),
                  );
              }
              return Text("Check one More Time");
              // return Center(
              //   child: Container(
              //     height: 300,
              //           width: 300,
              //           color: Colors.amber,
              //           child:Center(
              //             child: Text((() {
              //               if(responseData['verified'] == 2){
              //                 return "You bought a Duplicate Product";
              //               } else if (responseData['verified'] == 1){
              //                 return "Thank You - You Bought a Original Product & you got a CashBack of Rs. 13.00 INR which will credited to your bank account soon";
              //
              //               }
              //               return "";
              //
              //             })()),
              //           ),
              //       ),
              // );
            },
            itemCount: r.length,
          );
        },
      ),
    );
  }


}




