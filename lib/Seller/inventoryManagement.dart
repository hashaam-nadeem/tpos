



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/inventorymodel.dart';
import 'package:transact/Supplier/addProduct.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/selectDate.dart';
import 'package:transact/utils/tableDataHeader.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class InventoryManagementSeller extends StatefulWidget {
  @override
  _InventoryManagementState createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagementSeller> {

InventoryModel inventoryModel =InventoryModel();
getInventoryList() async
  {
     var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getProductInStock}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        setState(() {
          inventoryModel=InventoryModel.fromJson(Json['Data']);
        });
      }
      else
      {
         Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    }
    else
    {
          Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInventoryList();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F5F7FA"),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            homepage: false,
            title: "Inventory Management",
            suffix: false,
          ),
        ),
        // bottomNavigationBar: BottomButton(
        //   name: "Add Inventory",
        //   ontap: () {
        //     //AppRoutes.push(context, AddProduct());
        //   },
        // ),
        body: Column(
          children: <Widget>[
            //SelectDate(),
            SizedBox(
              height: 10,
            ),
            TableDataHeader(
                c1: "Prod. Name",
                c2: "Stock",
                c3: "Actual Price",
                c4: "Sale price"),
            Expanded(child: _listData()),
          ],
        ),
      ),
    );
  }

  Widget _listData() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: inventoryModel.result!=null?inventoryModel.result.length:0,
      itemBuilder: (context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: _rowText("${inventoryModel.result[index].name}", "")),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        // TextSpan(
                        //   text: '120/ ',
                        //   style: TextStyle(color: Colors.redAccent),
                        // ),
                        TextSpan(text: '${inventoryModel.result[index].qtyStock}'),
                      ]),
                ),
              ),
              Expanded(child: _rowText("\$${inventoryModel.result[index].actualPrice}", "")),
              Expanded(child: _rowText("\$${inventoryModel.result[index].salePrice}", "")),
            ],
          ),
        );
      },
    );
  }

  Widget _rowText(String text, String textcolor) {
    return Text(
      "$text",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textcolor == "white" ? Colors.white : Colors.black),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:transact/AppBar.dart';
// import 'package:transact/Model/apismodel.dart';
// import 'package:transact/Model/getauthentication.dart';
// import 'package:transact/Seller/addProduct.dart';

// import 'package:transact/utils/bottomButton.dart';
// import 'package:transact/utils/routes.dart';
// import 'package:transact/utils/selectDate.dart';
// import 'package:transact/utils/tableDataHeader.dart';
// import 'package:transact/utils/utils.dart';
// import 'package:http/http.dart'as http;
// import 'dart:convert';
// class InventoryManagementSeller extends StatefulWidget {
//   @override
//   _InventoryManagementSellerState createState() =>
//       _InventoryManagementSellerState();
// }

// class _InventoryManagementSellerState extends State<InventoryManagementSeller> {
//   getInventoryList() async
//   {
//      var header = {
//       "Authorization": AuthenticationUser.getAuthentication(),
//     };
//     var response = await http.get(
//       "${API.getProductInStock}",
//       headers: header,
//     );
//     var Json = json.decode(response.body);
//     print(json.decode(response.body));
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getInventoryList();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: HexColor("#F5F7FA"),
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(70),
//           child: CustomeAppBar(
//             homepage: false,
//             title: "Inventory Management",
//             suffix: false,
//           ),
//         ),
//         bottomNavigationBar: BottomButton(
//           name: "Add Inventory",
//           ontap: () {
//            // AppRoutes.push(context, AddProductSeller());
//           },
//         ),
//         body: Column(
//           children: <Widget>[
//             SelectDate(),
//             TableDataHeader(
//                 c1: "Prod. Name",
//                 c2: "Stock",
//                 c3: "Actual Price",
//                 c4: "Sale price"),
//             Expanded(child: _listData()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _listData() {
//     return ListView.builder(
//       physics: BouncingScrollPhysics(),
//       itemCount: 20,
//       itemBuilder: (context, int index) {
//         return Container(
//           margin: EdgeInsets.symmetric(vertical: 2),
//           height: MediaQuery.of(context).size.height * 0.05,
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Row(
//             children: <Widget>[
//               Expanded(child: _rowText("iphoneX", "")),
//               Expanded(
//                 child: RichText(
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                       children: [
//                         TextSpan(
//                           text: '120/ ',
//                           style: TextStyle(color: Colors.redAccent),
//                         ),
//                         TextSpan(text: '150'),
//                       ]),
//                 ),
//               ),
//               Expanded(child: _rowText("\$350", "")),
//               Expanded(child: _rowText("\$250", "")),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _rowText(String text, String textcolor) {
//     return Text(
//       "$text",
//       textAlign: TextAlign.center,
//       style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           color: textcolor == "white" ? Colors.white : Colors.black),
//     );
//   }
// }
