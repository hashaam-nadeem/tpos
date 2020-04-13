
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../AppBar.dart';
class FeedBack extends StatefulWidget {
  @override
  _FeedBack createState() => _FeedBack();
}

class _FeedBack extends State<FeedBack> {

  TextEditingController comment =TextEditingController();
   double _productRating = 0.0;
   int selectedIndex=0;
   ProgressDialog pr;
   int length=0;
     var style2 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: HexColor("#6B6B6B"));

feedBackProduct() async {
  int id=User.userData.orderModel.result[User.userData.index].lineDetail[selectedIndex].id;
  print("selected id: " + id.toString());
  int r=_productRating.toInt();
  print(r);
    pr.show();
    var header = {
      "Authorization":"${AuthenticationUser.getAuthentication()}",
    };

    print(header);
    var body = {
      "productId":"$id",
      "rate": "$r",
      "comment": "${comment.text.trim()}",
    };
    print(body);
    var response = await http.post(
      "${API.feedBack}",
      headers: header,
      body: body
    );
    
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        // pr.dismiss();
        //length++;
              pr.dismiss();
      Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
            Navigator.of(context).pop();
      } else {
        pr.dismiss();
         Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      pr.dismiss();
     
      //pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
          
    }
    
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
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              homepage: false,
              title: "Feed Back",
              // child: order == false
              //     ? Buttons
              //     : Container(),
            ),
          ),
          body: SingleChildScrollView(
              child: 
              Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            height: MediaQuery.of(context).size.height * .8,
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
                // GestureDetector(
                //   // onTap: () {
                //   //   setState(() {
                //   //     Navigator.of(context).pop();
                //   //   });
                //   // },
                //   child: Container(
                //     height: 20,
                //     width: MediaQuery.of(context).size.width,
                //     alignment: Alignment.centerRight,
                //     margin: EdgeInsets.only(top: 10, right: 10),
                //     child: Image.asset("images/cross.png"),
                //   ),
                // ),
                // _orderDetailLine("Order #", "CK12FGH"),
                // _orderDetailLine("Placed on    ", "10-01-2020"),
                // _orderDetailLine("Received on", "20-01-2020"),
                _product(),
                _divider(),
                _rate(),
                _divider(),
                   Expanded(
                child: ListView.builder(
                    itemCount:
                        User.userData.orderModel.result[User.userData.index].lineDetail != null
                            ? User.userData.orderModel.result[User.userData.index].lineDetail.length
                            : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return productsDetail(index);
                    }),
              ),
              SizedBox(height: 10,),
           _title("Write a Review"),
                _textFormField(
                  "Write here...",
                  comment
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 14, bottom: 0.0),
                  child: BottomButton(
                    name: "Send Feed Back",
                    ontap: () {
                      print(comment.text);
                      
                      feedBackProduct();
                     // Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

    Widget productsDetail(int index) {
    return GestureDetector(
      onTap: ()
      {

        setState(() {
          selectedIndex=index;
        });
                print(selectedIndex);
      },
child: Container(
  decoration: BoxDecoration(
     color: selectedIndex==index?Colors.yellow[100]:Colors.white,
  ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Wrap(
                  children: <Widget>[
                    // Image(
                    //   height: MediaQuery.of(context).size.height * .14,
                    //   width: MediaQuery.of(context).size.width * .3,
                    //   image: AssetImage("images/iphone.png"),
                    // ),
                    User.userData.orderModel.result[User.userData.index].lineDetail[index]
                                .imageUrl !=
                            null
                        ? Image.network(
                            "${API.API_URL}${User.userData.orderModel.result[User.userData.index].lineDetail[index].imageUrl}",
                            height: MediaQuery.of(context).size.height * .12,
                            width: MediaQuery.of(context).size.width * .2,
                          )
                        : Image.asset(
                            "images/iphone.png",
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.width * .3,
                          ),
                        
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${User.userData.orderModel.result[User.userData.index].lineDetail[index].productName}",
                          style: style.copyWith(color: HexColor("#6B6B6B")),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            " ${User.userData.orderModel.result[User.userData.index].lineDetail[index].qty} * ${User.userData.orderModel.result[User.userData.index].lineDetail[index].price}",
                          textAlign: TextAlign.start,
                          style: style2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                "\$${User.userData.orderModel.result[User.userData.index].lineDetail[index].total}",
                style: style,
              ),
            ],
          ),
        ],
      ),
    )
    ); }

Widget _product() {
    return Container(
      child: Row(
        children: <Widget>[
          // Container(
          //   alignment: Alignment.centerLeft,
          //   height: 70,
          //   width: 70,
          //   child: Image.asset("images/iphone.png"),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${User.userData.orderModel.result[User.userData.index].orderNumber}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
               "\$${User.userData.orderModel.result[User.userData.index].totalBill}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    height: 1.4, fontSize: 14, color: HexColor("#515C6F")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _rate() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "How would you rate this product & Seller?",
            style: blackbold.copyWith(height: 1.5, fontSize: 18),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text("Product"),
                ),
              ),
              Expanded(child: _fiveStar(1))
            ],
          ),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       child: Container(
          //         alignment: Alignment.center,
          //         child: Text("Seller"),
          //       ),
          //     ),
          //     Expanded(child: _fiveStar(2))
          //   ],
          // )
        ],
      ),
    );
  }

  Widget _fiveStar(int id) {
    return 
    Container(
        margin: EdgeInsets.only(
          top: id == 1 ? 10 : 0.0,
          bottom: 10,
        ),
        child: SmoothStarRating(
          //rating: id == 1 ? _productRating : _sellerRating,
          rating:_productRating,
          size: 18,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          color: Colors.yellow[600],
          borderColor: Colors.yellow[600],
          starCount: 5,
          allowHalfRating: false,
          spacing: 2.0,
          onRatingChanged: (value) {
            setState(() {
              _productRating = value;
            });
            print(_productRating);
          },
        ));
  }

  Widget _textFormField(String text,_controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
            isDense: true,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: "$text",
            hintStyle: TextStyle(
              fontSize: 12,
              fontFamily: "Roboto",
              color: HexColor("#9E9E9E"),
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget _title(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text("$text",
          style: TextStyle(
            color: HexColor("#9E9E9E"),
            fontFamily: 'Roboto',
            fontSize: 15,
          )),
    );
  }

}