import 'package:barcode_scan/barcode_scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/bundlemodel.dart';
import 'package:transact/Model/categoriesmodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Supplier/addProduct.dart';
import 'package:transact/Supplier/searchitem.dart';
import 'package:transact/Supplier/supplierDashBoard.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/dashedLine.dart';
import 'package:transact/utils/floatingButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:transact/utils/utils.dart';

class BundleItemsSeller extends StatefulWidget {
  @override
  _BundleItemsState createState() => _BundleItemsState();
}

class _BundleItemsState extends State<BundleItemsSeller> {
  bool favorite = false;
  String barcode="";
BundleModel bundleModel=BundleModel();
final RefreshController _refreshController = RefreshController();
  getSupplierProduct() async
{
   var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.BundleProducts}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==true)
      {
         Fluttertoast.showToast(
              msg: "no bundle found",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
      }
      else
      {
        setState(() {
          bundleModel=BundleModel.fromJson(Json['Data']);
         // User.userData.dashBoardResult=dashBoardModel;
        });
      }
    }
    else
    {
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
    getSupplierProduct();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: CustomFloatingButton(
        ontap: () {
            setState(() {
            User.userData.id.clear();
          User.userData.name.clear();
          User.userData.total=0.0;
          User.userData.price.clear();
         });
           AppRoutes.push(context, AddBundleSeller());
        },
      ),
      backgroundColor: HexColor("#F5F7FA"),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomeAppBar(
          title: "Bundle Items",
        ),
      ),
      body: 

      _bundleItemBody(),
    ));
  }


  Widget _bundleItemCardSupplier(int index) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 4),
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            //padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              //  bundleModel.result[index].imagePath==null? Image.asset("images/shirt.png"):
                  
              //     Image.network("${API.API_URL}${bundleModel.result[index].imagePath}",width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height*.2,
              //     ),
               Container(
                    
                     width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                    child: bundleModel.result[index].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${bundleModel.result[index].imagePath}",
                         fit: BoxFit.cover,
                        ),
                  ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${bundleModel.result[index].name}",
                        style: TextStyle(
                            color: HexColor("#3B444B"),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    //  Container(
                       
                    //    width: 25,
                    //    height: 30,
                    //    child: PopupMenuButton<int>(
                    //      itemBuilder: (context) => [

                    //        PopupMenuItem(
                             
                    //       value: 1,
                    //       child: GestureDetector(child: 
                    //       Text("Edit"),
                    //       onTap: ()
                    //       {
                    //         print("Edit");
                    //       }
                    //       ,),
                          
                    //        ),
                    //         PopupMenuItem(
                    //       value: 2,
                    //       enabled: true,
                    //       child: GestureDetector(child: 
                    //       Text("Delete"),
                    //         onTap: ()
                    //       {
                    //         print("Delete");
                    //       }
                    //       ,),
                    //        ),
                    //      ]
                    //    ),
                    //  ),
                   
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\$${bundleModel.result[index].actualPrice}",
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
                      bundleModel.result[index].withDiscount==true?
                        Text(
                          "\$${ bundleModel.result[index].salePrice}",
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
                      SizedBox(
                        width: 10,
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       setState(() {
                      //         favorite == false
                      //             ? favorite = true
                      //             : favorite = false;
                      //       });
                      //     },
                      //     child: favorite == true
                      //         ? Icon(
                      //             Icons.favorite_border,
                      //             size: 20,
                      //             color: Colors.grey,
                      //           )
                      //         : Icon(
                      //             Icons.favorite,
                      //             size: 20,
                      //             color: Colors.red,
                      //           ))
                   
                    ],
                  ),
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Min Order : (${ bundleModel.result[index].minOrder}",
                //     style: TextStyle(
                //         color: HexColor("#707070"),
                //         fontSize: 10,
                //         fontWeight: FontWeight.bold,
                //         fontFamily: 'CaviarDreams'),
                //   ),
                // ),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                     // Text("${dashBoardModel.result[index].rating}"),
                       _fiveStar(bundleModel.result[index].rating),
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
                  bundleModel.result[index].type==0?
                     bundleModel.result[index].qty<=0?
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
        bundleModel.result[index].withDiscount==true?
            
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
                      child: bundleModel
                                  .result[index].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${bundleModel.result[index].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${bundleModel.result[index].totalDiscount}\$",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            ),
                    )))
          :Text(""),
        ],
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

 Widget showRating() {
    return Container(
      child: Icon(
        Icons.star,
        color: HexColor("#EFCE4A"),
        size: 9,
      ),
    );
  }
  Widget _bundleItemBody() {
    return 
    
    Container(
        height: MediaQuery.of(context).size.height / 1.15,
        child:
        
        SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: ()async
                  {
                    await Future.delayed(Duration(seconds: 3));
                    getSupplierProduct();
                  _refreshController.refreshCompleted();
                  },
                  child:
         StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: bundleModel.result!=null?bundleModel.result.length:0,
          itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.white,
              child: new Center(
                child:
                  _bundleItemCardSupplier(index),
                
              )
              ),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3 : 2.8),
          mainAxisSpacing: 7.0,
          crossAxisSpacing: 7.0,
        )));
  }
}

class AddBundleSeller extends StatefulWidget {
  @override
  _AddBundleSellerState createState() => _AddBundleSellerState();
}

class _AddBundleSellerState extends State<AddBundleSeller> {
  int del = 0;
  int j = 0;
  String idList = "";
  String specs =
      "hello there, these specs are enter the the owner of that application so don't be worry about this, your app is working fine thank you!";
  List<File> _imageList = List<File>();
  String imageListttt = "";
  File _image;

  bool selectPercentage = false;
  var discount = TextEditingController();
  var salePrice = TextEditingController();
  var amountPercentage = TextEditingController();
  var productName = TextEditingController();
  String barCode ="";
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
  String _selectedCatagory = "";
  List<String> categories = List<String>();
  // List<String> _catagory = [
  //   'Electronics',
  //   'Garments',
  //   'Cosmetics',
  //   'Accessories'
  // ];

  List<String> _catagory = List<String>();
  CategoriesModel _categoriesModel = CategoriesModel();
  File selectedImage;
  ProgressDialog pr;
  bool withDiscount = false;

  DateTime sDate;
  uploadImage(List<File> file) async {
    print(file);
    List<String> im = List<String>();
    setState(() {
            idList="";
            imageListttt="";
});
    if (productName.text.isEmpty ||
        productName.text.length < 6 ||
        discount.text.isEmpty ||
        _selectedCatagory == "" ||
        file == null) {
      pr.dismiss();
      Fluttertoast.showToast(
          msg:
              "Please enter the required fields and image,select category, name must be 6 character",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
    } else {
      pr.show();
      String img;
      for (int m = 0; m < _imageList.length; m++) {
        String fileName = file[m].path.split('/').last;
        FormData data = FormData.fromMap({
          "imageFile": await MultipartFile.fromFile(
            file[m].path,
            filename: fileName,
          ),
        });
        print(fileName.toString());
        print(data);
        Dio dio = new Dio();
        dio.options.headers["Authorization"] =
            "${AuthenticationUser.getAuthentication()}";
        dio.options.headers["flag"] = "1";
        dio.post("${API.UploadImage}", data: data).then((imagecall) {
          print("this the image url -----======== $imagecall");
          setState(() {
            img = imagecall.data['Data']['Result'].toString();
            im.add(img);
            print(img[m]);
            if (imageListttt == "") {
              setState(() {
                imageListttt = "$img";
              });
            } else {
              setState(() {
                imageListttt = "$imageListttt,$img";
              });
            }
            //  imagelength++;
          });
          if (im.length == _imageList.length) {
            addBundle(img);
          }
          //  Fluttertoast.showToast(
          //       msg: "Image Updated",
          //       textColor: Colors.white,
          //       backgroundColor: Colors.blueGrey);
          print("Image url: " + img);

          //   callAPiImage(context, imageurl);
        }).catchError((onError) {
          pr.dismiss();
          Fluttertoast.showToast(
              msg: "$onError",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        });
      }
    }
  }

  addBundle(String img) async {
    if (selectPercentage == true) {
      setState(() {
        withDiscount = true;
      });
    } else {
      setState(() {
        withDiscount = false;
      });
    }

    int cId;
    for (int k = 0; k < _categoriesModel.result.length; k++) {
      if (_selectedCatagory == _categoriesModel.result[k].name) {
        setState(() {
          cId = _categoriesModel.result[k].id;
        });
      }
    
    }

    for(int k=0;k<User.userData.id.length;k++)
    {
        if (idList == "") {
        setState(() {
          idList = "${User.userData.id[k]}";
        });
      } else {
        setState(() {
          idList = "$idList,${User.userData.id[k]}";
        });
      }
    }
    print("ID List:   $idList");
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var body = {
      "Name": "${productName.text.trim()}",
      "Description": "$specs",
       "Code": "$barCode",
      // "Specification": "$specs",
      "FeatureImageUrl": "$img",
      "ActuallPrice": "${salePrice.text.trim()}",
      "SalePrice": "${discount.text.trim()}",
      "GST": "0.0",
      "MinOrder": "0",
      "TotalDiscount": "${discount.text.trim()}",
      "WithDiscount": "$withDiscount",
      "IsDiscountPercentage": "$selectPercentage",
      "CategoryId": "$cId",
      "Type": "1",
      "ImageUrls": "$imageListttt",
      // "Detail": "detilsss",
      "ProductIds": "$idList",
       "CreatedOn":"$sDate"
    };
    print("Body:  $body");
    var response =
        await http.post("${API.addProduct}", headers: header, body: body);
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        setState(() {
          idList = "";
          imageListttt="";
        });
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
            idList="";
            imageListttt="";
});
        pr.dismiss();
        //_showDialog();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
        // var route = MaterialPageRoute(
        //   builder: (BuildContext context) => SupplierDashBoard(),
        // );
        // Navigator.of(context).pushReplacement(route);
        Navigator.of(context).pop();
        //  AppRoutes.push(context, SupplierDashBoard());
      }
    } else {
      pr.dismiss();
      setState(() {
            idList="";
            imageListttt="";
});
      Fluttertoast.showToast(
          msg: "status code: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getCategoriess() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.post(
      "${API.getCategories}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        setState(() {
          _categoriesModel = CategoriesModel.fromJson(Json['Data']);
        });
        for (int i = 0; i < _categoriesModel.result.length; i++) {
          _selectedCatagory = _categoriesModel.result[0].name;
          categories.add(_categoriesModel.result[i].name);
        }
      } else {
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
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
    getCategoriess();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Uploading...',
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
      bottomNavigationBar: BottomButton(
        name: "Add Package",
        ontap: () {
          uploadImage(_imageList);
        },
      ),
      backgroundColor: HexColor("#F5F7FA"),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomeAppBar(
          title: "Add Packages",
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
       // height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: selectedImage != null
                              ? FileImage(_imageList[j])
                              : AssetImage('images/applogo.png'),
                          fit: BoxFit.contain),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width * .1,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black87,
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    print("Delete");
                                    if (_imageList.length != 0) {
                                      var g = _imageList.last;
                                      print(g);

                                      setState(() {
                                        if (_imageList[j] == selectedImage) {
                                          selectedImage = null;
                                          _imageList.removeAt(j);
                                          j--;
                                        } else {
                                          _imageList.removeAt(j);
                                        }

                                        //  selectedImage=_imageList[i];
                                      });
                                    }
                                  },
                                ),
                              ),
                            )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .08,
                              color: Colors.black54,
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      width: MediaQuery.of(context).size.width *
                                          .94,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      child: ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return profileselect(index);
                                        },
                                        itemCount: _imageList != null
                                            ? _imageList.length + 1
                                            : 1,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ))
              ],
            ),
            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     GestureDetector(
                    onTap: () {
                      Picker(
                          hideHeader: true,
                          adapter: DateTimePickerAdapter(),
                          title: Text("Select Date"),
                          selectedTextStyle: TextStyle(color: Colors.blue),
                          onConfirm: (Picker picker, List value) {
                            print((picker.adapter as DateTimePickerAdapter)
                                .value);
                            setState(() {
                              sDate = (picker.adapter as DateTimePickerAdapter)
                                  .value;
                              // "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-${(picker.adapter as DateTimePickerAdapter).value.day}";
                             // eDate = null;
                            });
                            //getMerchantOrderHistory(context, sDate, eDate);
                          }).showDialog(context);
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        height: 30,
                        width: MediaQuery.of(context).size.width*.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                sDate != null
                                    ? Flexible(
                                        child: Text("$sDate",
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold)),
                                      )
                                    : Text("Select Date",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold)),
                                Icon(
                                  FontAwesomeIcons.calendar,
                                  color: Colors.grey[600],
                                  size: 15,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 
                  ],
                                  ),
            _productDetail(),
            //  _plusProduct(),
            _productDetails(),
            _discountFields(),
          ],
        ),
      )),
    ));
  }

  Widget _productDetail() {
    return Container(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .2,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _title("Select Category"),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10),
                height: 40,
                child: DropdownButton(
                  isExpanded: true,
                  icon: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  ),
                  hint: Text(
                      'Please choose a Category'), // Not necessary for Option 1
                  value: _selectedCatagory,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCatagory = newValue;
                    });
                  },
                  items: categories.map((catagory) {
                    return DropdownMenuItem(
                      child: new Text(catagory),
                      value: catagory,
                    );
                  }).toList(),
                ),
              ),
              _textField()
            ]));
  }

  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((onValue) {
      print(onValue);
      if (onValue == null) {
      } else {
        setState(() {
          _image = onValue;
          print(_image.toString());
          _imageList.add(_image);
          j = 0;
          selectedImage = _imageList[j];
          // l++;
        });
      }
    });
  }

  Widget profileselect(int index) {
    //print(l);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        width: MediaQuery.of(context).size.width * .15,
        height: MediaQuery.of(context).size.height * .1,
        decoration: BoxDecoration(
            color: Colors.black26,
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: index == _imageList.length
            ? Center(
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 30),
                  onPressed: () {
                    getImage();
                    if (_image == null) {
                      print("image not selected");
                    } else {
                      setState(() {
                        del++;
                        // index++;
                      });
                    }
                    print("Add new photo");
                  },
                ),
              )
            : Center(child: Image.file(_imageList[index])),
      ),
      onTap: () {
        setState(() {
          j = index;
          selectedImage = _imageList[index];
          print(j);
          // _imageList.removeAt(i);
        });
        // print(index);
      },
    );
  }

  Widget _title(String text) {
    return Container(
      padding: text == 'Scan Barcode' ? EdgeInsets.all(5) : null,
      child: Text("$text",
          style: TextStyle(
              color: HexColor("#9E9E9E"),
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _textField() {
    return GestureDetector(
        onTap: () {
          AppRoutes.push(context, SearchItem());
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: HexColor("#FFFFFF"),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: HexColor("#707070")),
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Center(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.search),
                Text("    Search Product"),
              ],
            ),
          ),
        ));
  }

  Widget _plusProduct() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.only(left: 40),
              child: Text("Add Product",
                  style: TextStyle(
                      fontFamily: "CaviarDreams",
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 20, top: 8, bottom: 8),
              height: 40,
              width: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all()),
              child: IconButton(
                onPressed: () {
                  AppRoutes.push(context, AddProduct());
                },
                icon: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _productDetails() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .28,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Order Detail",
                style: style.copyWith(color: HexColor("#6B6B6B")),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      User.userData.id == null ? 0 : User.userData.id.length,
                  itemBuilder: (BuildContext context, int index) {
                    return productDetail(index);
                  },
                ),
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Container(
              //       child: Wrap(
              //         children: <Widget>[
              //           Image(
              //             height: MediaQuery.of(context).size.height * .09,
              //             width: MediaQuery.of(context).size.width * .2,
              //             image: AssetImage("images/iphone.png"),
              //           ),
              //           Center(
              //             child: Text(
              //               "iphone 8",
              //               style: style.copyWith(color: HexColor("#6B6B6B")),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Text(
              //       "\$968",
              //       style: style,
              //     ),
              //   ],
              // ),

              MySeparator(),
              Container(
                alignment: Alignment.bottomRight,
                //margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: Text("Total   \$${User.userData.total}",
                    style: style.copyWith(color: HexColor("#3B444B"))),
              ),
            ]));
  }

  Widget productDetail(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Wrap(
            children: <Widget>[
              Image.network(
                "${API.API_URL}${User.userData.image[index]}",
                height: MediaQuery.of(context).size.height * .09,
                width: MediaQuery.of(context).size.width * .2,
              ),
              Center(
                child: Text(
                  "${User.userData.name[index]}",
                  style: style.copyWith(color: HexColor("#6B6B6B")),
                ),
              ),
            ],
          ),
        ),
        Text(
          "\$${User.userData.price[index]}",
          style: style,
        ),
      ],
    );
  }

  Widget _discountFields() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .2,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _title("Actual Price"),
              SizedBox(
                width: 56,
              ),
              _title("Product Name"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: _textFormField("\$ price", salePrice),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: _textFormField("Product Name", productName),
              ),
              GestureDetector(
                onTap: ()
                {
                  scan();
                },
                child: Container(
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.grey,width:0.5)
                ),
                child: 
                barCode==""?
                Text("barcode"):
                Text("$barCode"),
              ),
              ),        
            ],
          ),
          _title("Discount"),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectPercentage = !selectPercentage;
                            discount.clear();
                            salePrice.clear();
                            amountPercentage.clear();
                          });
                        },
                        child: Container(
                          // margin: EdgeInsets.only(right:10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.rectangle),
                          width: 20,
                          height: 20,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectPercentage == true
                                      ? Colors.grey
                                      : Colors.white,
                                  shape: BoxShape.circle),
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ),
                      ),
                      Text("%   "),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _textFormField("enter amount", amountPercentage),
                ),
                Expanded(
                  child: _textFormField("Sale price", discount),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
 Future scan() async {
    try {
      String barcode;
      await BarcodeScanner.scan().then((onValue) {
        setState(() {
          if(onValue==null)
          {

          }
          else{
            barCode = onValue;
          }
          
          // User.userData.barCode=barcode;
          // AppRoutes.push(context, AddProductSeller());
        });
      }).catchError((onError) {
        print(onError);
      });
      setState(() => barcode = barcode);
    } on Exception catch (e) {
      if (e == BarcodeScanner.CameraAccessDenied) {
        setState(() {
         // this.barcode = 'camera permission not granted!';
        });
      } else {
        //setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      //setState(() => this.barcode = '(User returned)');
    } catch (e) {
      //setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Widget _textFormField(String label, _controller) {
    return Container(
      child: TextFormField(
        controller: _controller,
        onTap: ()
        {
          if(label=="\$ price")
          {
            amountPercentage.clear();
            discount.clear();
          }
        },
        keyboardType:
            label == "\$ price" ? TextInputType.number : TextInputType.text,
        enabled: label == "After Discount" ? false : true,
        maxLength: label == "\$ price" ? 6 : 50,
        onChanged: (value) {
          if (label == "\$ price") {
           setState(() {
             discount=salePrice;
           });}
           else if(label=="enter amount")
           {
             if (selectPercentage == true) {
                double a = double.parse(salePrice.text);
                double b = double.parse(value);
                setState(() {
                  double t = (a * b) / 100;
                  double k=a-t;
                  discount.text = k.toString();
                });
              } else {
                double a = double.parse(salePrice.text);
                double b = double.parse(value);
                setState(() {
                    double t = a - b;
                    discount.text = t.toString();
                  });
              }
           }
            //   if (amountPercentage.text.isEmpty) {
            //   setState(() {
            //     discount = salePrice;
            //   });
            // } else {
            //   
            // }
          
        },
        decoration: InputDecoration(
            isDense: true,
            counterText: "",
            hintText: "$label",
            hintStyle: TextStyle(
              fontSize: 14,
            )),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Cogratulations",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("You have successfully added a package.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontFamily: "CaviarDreams")),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .06,
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: HexColor("#3B444B"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: Text(
                      "Add More Packages",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  
}
