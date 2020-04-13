import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transact/Buyer/itemDetails.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../AppBar.dart';

class StoreDetails extends StatefulWidget {
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  var favorite = false;
 final RefreshController _refreshController = RefreshController();
  MarketPlaceModel marketPlaceModel = MarketPlaceModel();
    getSellerProduct() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.StoreProduct}?userId=${User.userData.userStoreId}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        setState(() {
         // dashBoardModel=DashBoardModel();
          marketPlaceModel = MarketPlaceModel();
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
          marketPlaceModel=MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel=marketPlaceModel;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerProduct();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F5F7FA"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              title: "Store Name",
              homepage: false,
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: marketPlaceModel.result==null?0:marketPlaceModel.result.length,
              itemBuilder: (BuildContext context, int index) => new Container(
                  color: Colors.white,
                  child: new Center(
                    child: _itemCardSupplier(index),
                  )),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3 : 2.8),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          )),
    );
  }
     Widget _itemCardSupplier(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index=index;
        });
        print(User.userData.index=index);
        AppRoutes.push(context, ItemDetailsBuyer());
        // setState(() {
        //   User.userData.index=index;
        // });
        // AppRoutes.push(context, ItemDetails());
      },
      child: Container(
        //margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                
                  marketPlaceModel.result[index].imagePath==null? Image.asset("images/shirt.png"):
                  
                  Image.network("${API.API_URL}${marketPlaceModel.result[index].imagePath}",width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*.2,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${marketPlaceModel.result[index].name}",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.more_vert,
                            color: HexColor('#3B444B'),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\$${marketPlaceModel.result[index].actualPrice}",
                          style: TextStyle(
                              decoration:marketPlaceModel.result[index].withDiscount==true? TextDecoration.lineThrough:TextDecoration.none,
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        marketPlaceModel.result[index].withDiscount==true?
                        Text(
                          "\$${ marketPlaceModel.result[index].salePrice}",
                          style: TextStyle(
                              color: HexColor("#515C6F"),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ):Text(
                          "",
                          style: TextStyle(
                              color: HexColor("#515C6F"),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Per Piece",
                          style: TextStyle(
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Min Order : (${marketPlaceModel.result[index].minOrder})",
                      style: TextStyle(
                          color: HexColor("#707070"),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaviarDreams'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "(10)",
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                      Text(
                        "(81/100) IN STOCK",
                        style: TextStyle(
                            color: HexColor("#707070"),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    height: 20,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/discountTag.png"),
                      ),
                    ),
                    child: Center(
                      child: 
                      marketPlaceModel.result[index].isDiscountPercentage==true?
                      Text(
                        "-${marketPlaceModel.result[index].totalDiscount}\$",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      )
                      :
                      Text(
                        "-${marketPlaceModel.result[index].totalDiscount}%",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _itemCardSupplierr() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  image: AssetImage("images/shirt.png"),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "V Neck Shirt - Black",
                        style: TextStyle(
                            color: HexColor("#3B444B"),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            favorite == true
                                ? favorite = false
                                : favorite = true;
                          });
                        },
                        child: Icon(
                          favorite == false
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color: favorite == false
                              ? HexColor('#3B444B')
                              : Colors.red,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\$58.99",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: HexColor("#707070"),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "\$24.99",
                        style: TextStyle(
                            color: HexColor("#515C6F"),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Per Piece",
                        style: TextStyle(
                            color: HexColor("#707070"),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Min Order : (10)",
                    style: TextStyle(
                        color: HexColor("#707070"),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CaviarDreams'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: HexColor("#EFCE4A"),
                          size: 9,
                        ),
                        Icon(
                          Icons.star,
                          color: HexColor("#EFCE4A"),
                          size: 9,
                        ),
                        Icon(
                          Icons.star,
                          color: HexColor("#EFCE4A"),
                          size: 9,
                        ),
                        Icon(
                          Icons.star,
                          color: HexColor("#EFCE4A"),
                          size: 9,
                        ),
                        Icon(
                          Icons.star,
                          color: HexColor("#EFCE4A"),
                          size: 9,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "(10)",
                          style: TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                    Text(
                      "(81/100) IN STOCK",
                      style: TextStyle(
                          color: HexColor("#707070"),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaviarDreams'),
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                  height: 20,
                  width: 35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/discountTag.png"),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "-10%",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ))),
        ],
      ),
    );
  }
}
