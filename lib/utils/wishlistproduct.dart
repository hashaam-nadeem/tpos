import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/itemDetails.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'package:transact/Model/productsearchmodel.dart';
import 'package:transact/Model/searchmodel.dart';
import 'package:transact/Model/submitsearchmodel.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WishList();
  }
}

class _WishList extends State<WishList> {
  String search = "";
  MarketPlaceModel marketPlaceModel = MarketPlaceModel();
  final RefreshController _refreshController = RefreshController();
  ProductSearchModel productSearchModel= ProductSearchModel();
  List<SubmitModel> submitModel = List<SubmitModel>();
  searchProduct() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getWishList}",
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
          marketPlaceModel = new MarketPlaceModel();
        });
      } else {
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          
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
  void initState() {
    // TODO: implement initState
    super.initState();
    searchProduct();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomeAppBar(
          title: "Wish List",
        ),
      ),
      body:  Container(
            margin: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * .7,
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 3));
                // getSellerProduct();
                // getCategory();
                searchProduct();
                _refreshController.refreshCompleted();
              },
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: marketPlaceModel.result == null
                    ? 0
                    : marketPlaceModel.result.length,
                itemBuilder: (BuildContext context, int index) => new Container(
                    color: Colors.white,
                    child: new Center(child: _itemCardSupplier(index))),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 3 : 2.8),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ),
          )
        );
  }

  Widget _itemCardSupplier(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index = index;
        });
        AppRoutes.push(context, ItemDetailsBuyer());
        setState(() {
          User.userData.marketPlaceModel=marketPlaceModel;
        });

        // print(User.userData.index F= index);
        
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
                  marketPlaceModel.result[index].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${marketPlaceModel.result[index].imagePath}",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
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
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Icon(
                        //     Icons.more_vert,
                        //     color: HexColor('#3B444B'),
                        //     size: 22,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\$${marketPlaceModel.result[index].actualPrice}",
                          style: TextStyle(
                              decoration:
                                  marketPlaceModel.result[index].withDiscount ==
                                          true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        marketPlaceModel.result[index].withDiscount == true
                            ? Text(
                                "\$${marketPlaceModel.result[index].salePrice}",
                                style: TextStyle(
                                    color: HexColor("#515C6F"),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CaviarDreams'),
                              )
                            : Text(
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
                   Row(
                    children: <Widget>[
                      marketPlaceModel.result[index].gst==null?
                      Text("")
                      :
                       Text(
                          "including ${marketPlaceModel.result[index].gst}% gst",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                    ],
                  ),
                
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          //pr.show();
                          var header = {
                            "Authorization":
                                AuthenticationUser.getAuthentication(),
                          };
                          var body = {
                            "productId": "${marketPlaceModel.result[index].id}"
                          };
                          var response = await http.post("${API.AddWishList}",
                              headers: header, body: body);
                          var Json = json.decode(response.body);
                          print(Json);
                          if (response.statusCode == 200) {
                            if (Json['Data']['WithError'] == false) {
                             
                              Fluttertoast.showToast(
                                  msg: "${Json['Data']['ShortMessage']}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey);
                                  searchProduct();
                             // getSellerProduct();
                            } else {
                             // pr.dismiss();
                              Fluttertoast.showToast(
                                  msg: "${Json['Data']['ShortMessage']}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey);
                            }
                          } else {
                           // pr.dismiss();
                            Fluttertoast.showToast(
                                msg: "response status: ${response.statusCode}",
                                textColor: Colors.white,
                                backgroundColor: Colors.blueGrey);
                          }
                        },
                        child: Icon(
                          marketPlaceModel.result[index].isLikeByMe == false
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color:
                              marketPlaceModel.result[index].isLikeByMe == false
                                  ? HexColor('#3B444B')
                                  : Colors.red,
                          size: 22,
                        ),
                      ),
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
                      _fiveStar(marketPlaceModel.result[index].rating),
                      marketPlaceModel.result[index].qty<=0?
                      Text(
                        "out of Stock",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ):Text(
                        "IN STOCK",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    


                    ],
                  ),
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
                      child: marketPlaceModel
                                  .result[index].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${marketPlaceModel.result[index].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${marketPlaceModel.result[index].totalDiscount}\$",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            ),
                    ))),
          ],
        ),
      ),
    );
  }
    Widget _fiveStar(var rat) {
    return 
    Container(
        // margin: EdgeInsets.only(
        //   top: id == 1 ? 10 : 0.0,
        //   bottom: 10,
        // ),
        child: SmoothStarRating(
          //rating: rat.todouble(),
          //rating:rat,
          size: 14,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          color: Colors.yellow[600],
          borderColor: Colors.yellow[600],
          starCount: rat,
          //allowHalfRating: false,
          spacing: 0.2,
          onRatingChanged: (value) {
            setState(() {
              //_productRating = value;
            });
            //print(_productRating);
          },
        ));
  }

}
