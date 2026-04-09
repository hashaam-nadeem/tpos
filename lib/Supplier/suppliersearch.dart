import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/productsearchmodel.dart';
import 'package:transact/Model/searchmodel.dart';
import 'package:transact/Model/submitsearchmodel.dart';
import 'package:transact/utils/productitemdetail.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupplierSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SupplierSearch();
  }
}

class _SupplierSearch extends State<SupplierSearch> {
  String search = "";
  ProductSearchModel productSearchModel= ProductSearchModel();
  List<SubmitModel> submitModel = List<SubmitModel>();

    searchProductSupplier() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.SupplierProductSearch}?key=$search",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        //  Fluttertoast.showToast(
        //       msg: "no product found",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        setState(() {
          productSearchModel = new ProductSearchModel();
        });
      } else {
        setState(() {
          productSearchModel = ProductSearchModel.fromJson(Json['Data']);
           User.userData.productSearchModel=productSearchModel;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "response status:  ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  searchProduct() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      User.userData.getSellerProduct==true?
      "${API.ProductSearchApi}?GetSellerMarket=true&key=$search"
      :
      "${API.ProductSearchApi}?GetSellerMarket=false&key=$search",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        //  Fluttertoast.showToast(
        //       msg: "no product found",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        setState(() {
          productSearchModel = new ProductSearchModel();
          User.userData.productSearchModel=productSearchModel;
        });
      } else {
        setState(() {
          productSearchModel = ProductSearchModel.fromJson(Json['Data']);
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "response status:  ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomeAppBar(
          title: "Search Item",
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .07,
              decoration: BoxDecoration(
                color: HexColor("#FFFFFF"),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: HexColor("#707070")),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                  searchProductSupplier();
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: productSearchModel.result != null
                      ? productSearchModel.result.length
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return SearchItems(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchItems(int index) {
    return GestureDetector(
        onTap: () {
          // if(User.userData.id.contains(searchModel.result[index].id.toString()))
          // {
          //   Fluttertoast.showToast(
          // msg: "already found in list",
          // textColor: Colors.white,
          // toastLength: Toast.LENGTH_LONG,
          // backgroundColor: Colors.blueGrey);
          // }
          // else
          // {
          //   setState(() {
          //   User.userData.id.add(searchModel.result[index].id.toString());
          //   User.userData.name.add(searchModel.result[index].name);
          //   User.userData.image.add(searchModel.result[index].imagePath);
          //   User.userData.price.add(searchModel.result[index].actualPrice.toString());
          //   User.userData.total=User.userData.total+searchModel.result[index].actualPrice;
          // });
          // Navigator.of(context).pop();
          //  Fluttertoast.showToast(
          // msg: "Item added",
          // textColor: Colors.white,
          // toastLength: Toast.LENGTH_LONG,
          // backgroundColor: Colors.blueGrey);
          // }
          
          // submitModel.result.addAll(searchModel.result);
          // print(submitModel.result[0].id);
          setState(() {
            User.userData.index=index;
            User.userData.productSearchModel=productSearchModel;
          });
          AppRoutes.push(context, productItemDetails());
        },
        child: Container(
          margin: EdgeInsets.only(top: 15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .1,
          decoration: BoxDecoration(
            color: HexColor("#FFFFFF"),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: HexColor("#707070")),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("${productSearchModel.result[index].name}",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                Text("Price: ${productSearchModel.result[index].salePrice}",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                productSearchModel.result[index].imagePath == null
                    ? Image.asset(
                        "images/prepaid.png",
                        width: 50,
                        height: 50,
                      )
                    : Image.network(
                        "${API.API_URL}${productSearchModel.result[index].imagePath}",
                        width: 50,
                        height: 50,
                      ),
              ],
            ),
          ),
        ));
  }
}
