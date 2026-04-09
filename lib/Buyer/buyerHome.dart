import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transact/AppBar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/Buyer/allCatagories.dart';
import 'package:transact/Buyer/buyerCart.dart';
import 'package:transact/Buyer/buyerNotification.dart';
import 'package:transact/Buyer/drawer.dart';
import 'package:transact/Buyer/itemDetails.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/categoriesmodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'package:transact/Model/supplierdashboardmodel.dart';
import 'package:transact/Supplier/notifications.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuyerHome extends StatefulWidget {
  @override
  _BuyerHomeState createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  List<String> categories = [];
  ProgressDialog pr;
  DashBoardModel dashBoardModel = DashBoardModel();
  final RefreshController _refreshController = RefreshController();
  MarketPlaceModel marketPlaceModel = MarketPlaceModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool virtual=false,physical=false;
  var favorite = false;
  bool filter = false;

  CategoriesModel categoriesModel = CategoriesModel();


  storeFilter() async {
   // pr.show();

   print("calling store filter");
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };

    var response = await http.get(
          User.userData.selectedFilter==0?
           "${API.marketPlaceStoreType}?GetSellerMarket=true&AllPhysicalStore=true"
          :
      "${API.marketPlaceStoreType}?GetSellerMarket=true&AllPhysicalStore=false",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
      //  pr.dismiss();
        setState(() {
          // dashBoardModel=DashBoardModel();
          marketPlaceModel = MarketPlaceModel();
        });
         Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        //pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
          User.userData.selectedFilter=5;
            User.userData.selectedLat=0.0;
          User.userData.selectedLong=0.0;
          User.userData.radius=0.0;
          User.userData.city="";
        });
      }
    } else {
      //pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
 locationFilter() async {
   // pr.show();
      print("calling Location filter");
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };

    var response = await http.get(
         
      "${API.LatlongFilter}?lat=${User.userData.selectedLat}&lon=${User.userData.selectedLong}&radius=${User.userData.radius}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
      //  pr.dismiss();
        setState(() {
          // dashBoardModel=DashBoardModel();
          marketPlaceModel = MarketPlaceModel();
        });
      Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        //pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
          User.userData.selectedLat=0.0;
          User.userData.selectedLong=0.0;
          User.userData.radius=0.0;
          User.userData.city="";
          User.userData.location=false;
        });
      }
    } else {
      //pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }



getCategoryProduct(int id) async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getCategoryData}?GetSellerMarket=true&CategoryId=$id",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
        setState(() {
          // dashBoardModel=DashBoardModel();
          marketPlaceModel = MarketPlaceModel();
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
  getCategory() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getCategories}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        setState(() {
          // dashBoardModel=DashBoardModel();
          categoriesModel = CategoriesModel();
        });
        Fluttertoast.showToast(
            msg: "no category found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
          categoriesModel = CategoriesModel.fromJson(Json['Data']);
          // User.userData.marketPlaceModel=marketPlaceModel;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
  getAllProduct() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.marketPlaceProducts}?GetSellerMarket=true",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
        setState(() {
          // dashBoardModel=DashBoardModel();
          marketPlaceModel = MarketPlaceModel();
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getSellerProduct() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.marketPlaceProducts}?GetSellerMarket=true",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        setState(() {
          // dashBoardModel=DashBoardModel();
          marketPlaceModel = MarketPlaceModel();
           User.userData.selectedFilter=5;
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
          User.userData.selectedFilter=5;
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
    User.userData.selectedFilter==5?
    User.userData.location==true?
    locationFilter():
     getSellerProduct():
    storeFilter();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: BuyerDrawer(
        filter: filter,
      ),
      backgroundColor: HexColor("#F5F7FA"),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(105),
        child: CustomeAppBar(
          title: "Marketplace",
          homepage: true,
          suffix: true,
          suffixIcon: "images/bell.png",
          type: "Buyer",
          bottomIcon1: "images/applyfilter.png",
          bottomIcon2: "images/shopping-cart.png",
          bottomIcon1OnTap: () {
            setState(() {
              User.userData.filter = true;
              print("$filter");
            });
            _scaffoldKey.currentState.openDrawer();
          },
          bottomIcon2OnTap: () {
            AppRoutes.push(context, BuyerCart());
          },
          suffixOnTap: () {
            AppRoutes.push(context, Notifications());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: _categories()),
      ),
    ));
  }

  Widget _categories() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Categories", style: blackbold.copyWith(fontSize: 20)),
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  height: MediaQuery.of(context).size.height * .08,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return _category("${categoriesModel.result[index].name}",
                           index);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesModel.result != null
                        ? categoriesModel.result.length
                        : 0,
                  ),
                  // ListView(
                  //   scrollDirection: Axis.horizontal,
                  //   children: <Widget>[
                  //     _category("images/apparel.png", "Apparel"),
                  //     _category("images/beauty.png", "beauty"),
                  //     _category("images/shoes.png", "Shoes"),
                  //     _category("images/electronics.png", "Electronics"),
                  //     _category("images/furniture.png", "Furniture"),
                  //     _category("images/stationary.png", "Stationary"),
                  //     _category("images/apparel.png", "Food"),
                  //     _category("images/beauty.png", "Massage"),
                  //     _category("images/shoes.png", "Technician"),
                  //     _category("images/beauty.png", "Cleaning"),
                  //   ],
                  // ),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  getAllProduct();
                  //AppRoutes.push(context, AllCategories());
                },
                child: Container(
                  margin: EdgeInsets.only(right: 3),
                  child: Center(
                    child: Text("See All"),
                  ),
                ),
              )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(2),
            height: MediaQuery.of(context).size.height * .7,
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 3));
                getSellerProduct();
                getCategory();
                _refreshController.refreshCompleted();
              },
              child:
               StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: marketPlaceModel.result == null
                    ? 0
                    : marketPlaceModel.result.length,
                itemBuilder: (BuildContext context, int index) => new Container(
                    color: Colors.white,
                    child: new Center(child: _itemCardSupplier(index))),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 3 : 2.8),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 5.0,
              ),
            
            ),
          )
        ],
      ),
    );
  }

  Widget _category(String text, int i) {
    return InkWell(
      onTap: () {
        getCategoryProduct(categoriesModel.result[i].id);
        //text == "See All" ? AppRoutes.push(context, AllCategories()) : null;
      },
      child: Container(
        margin: EdgeInsets.only(right: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Image.network("${API.API_URL}$image",),
            Container(
              // margin: EdgeInsets.only(left: 20,right: 10),
              height: MediaQuery.of(context).size.height*.06,
              width: 50,

              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Container(
                    // color: Colors.grey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: NetworkImage('${API.API_URL}${categoriesModel.result[i].imagePath}'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )),
            ),

            // Container(
            //   height: 45,
            //   width: 50,
            //   child:
            //   IMage
            //   Image(
            //     image: AssetImage("$image"),
            //   ),
            // ),
            Text(
              "$text",
              style: catagoryFont.copyWith(fontSize: 10),
            )
          ],
        ),
      ),
      
    );
  }

  Widget _itemCardBuyer(String image, String distance) {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, ItemDetailsBuyer());
      },
      child: Container(
        margin: EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0, bottom: 2.0),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image(
                    image: AssetImage("$image"),
                  ),
                  Container(
                    child: Text(
                      "V Neck Shirt - Black",
                      style: TextStyle(
                          color: HexColor("#3B444B"),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaviarDreams'),
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "$distance km away",
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
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
                              size: 22,
                            ),
                          ),
                        ),
                      )
                   
                    ],
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
                            "(25)",
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                      Text(
                        "IN STOCK",
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
      ),
    );
  }

  Widget _itemCardSupplier(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index = index;
          User.userData.marketPlaceModel=marketPlaceModel;
        });
        print(User.userData.index = index);
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

                  Container(
                    
                     width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                    child: marketPlaceModel.result[index].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${marketPlaceModel.result[index].imagePath}",
                         fit: BoxFit.cover,
                        ),
                  ),
                  
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                          "${marketPlaceModel.result[index].name}",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
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
                      marketPlaceModel.result[index].gst.toString().isEmpty?
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
                          pr.show();
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
                              pr.dismiss();
                              Fluttertoast.showToast(
                                  msg: "${Json['Data']['ShortMessage']}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey);
                              getSellerProduct();
                            } else {
                              pr.dismiss();
                              Fluttertoast.showToast(
                                  msg: "${Json['Data']['ShortMessage']}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey);
                            }
                          } else {
                            pr.dismiss();
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
                  marketPlaceModel.result[index].type==0?
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
                  ):Text(""),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                     // Text("${dashBoardModel.result[index].rating}"),
                       _fiveStar(marketPlaceModel.result[index].rating),
                  //      Expanded(
                  //       child: Container(
                  //         width: 30,
                  //         height: 20,
                  //         child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: dashBoardModel.result[index].rating,
                  //         itemBuilder: (BuildContext context,int index)
                  //       {
                  //         return showRating();
                  //       },
                        
                  //       ),
                  //       ),
                  //     ),
                  marketPlaceModel.result[index].type==0?
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
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ):Text(
                        "Bundle",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    ],
                  )
               
                ],
              ),
            ),
            marketPlaceModel.result[index].withDiscount==true?
            
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
                    )))
          :Text(""),
          ],
        ),
      ),
    );
  }
  
   Widget showRating() {
    return Container(
      child: Icon(
        Icons.star,
        color: HexColor("#EFCE4A"),
        size: 9,
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
        child: 
        RatingBar(
   initialRating: 0,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: rat,
   itemSize: 20,
   glow: true,
   unratedColor: Colors.amber,
   //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
     print(rating);
   },
)
        // SmoothStarRating(
        //   //rating: rat.todouble(),
        //   //rating:rat,
        //   size: 14,
        //   filledIconData: Icons.star,
        //   halfFilledIconData: Icons.star_half,
        //   defaultIconData: Icons.star_border,
        //   color: Colors.yellow[600],
        //   borderColor: Colors.yellow[600],
        //   starCount: rat,
        //   //allowHalfRating: false,
        //   spacing: 0.2,
        //   onRatingChanged: (value) {
        //     setState(() {
        //       //_productRating = value;
        //     });
        //     //print(_productRating);
        //   },
        // )
        );
  }


void _showDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: 
          Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            height: MediaQuery.of(context).size.height * .65,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    topLeft: Radius.circular(35))),
            child: Column(
              children: <Widget>[
                Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 12,
                backgroundColor: HexColor("#FF77E5"),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        physical = true;
                        virtual = false;
                      });
                    },
                    child: Container(
                      // margin: EdgeInsets.only(top:10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.5)),
                      child: Center(
                        child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: physical == true
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    //height: 10,
                  ),
                  Text("Physical Store", style: TextStyle(color: Colors.black)),
                ],
              ),
              
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20),
                child: CircleAvatar(
                radius: 12,
                backgroundColor: HexColor("#C5DC1B"),
              ),
              ),
             Padding(
               padding: EdgeInsets.only(top:20),
               child:  Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        physical = false;
                        virtual = true;
                      });
                    },
                    child: Container(
                     // margin: EdgeInsets.only(top: 20),
                      // margin: EdgeInsets.only(top:10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.5)),
                      child: Center(
                        child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  virtual == true ? Colors.black : Colors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    //height: 10,
                  ),
                  Text("Virtual Store", style: TextStyle(color: Colors.black)),
                ],
              ),
             
             ), 
            ],
          ),
                              ],
            ),
          )),
    );
  }
}
