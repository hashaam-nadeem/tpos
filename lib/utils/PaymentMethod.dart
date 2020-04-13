import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/paymentcardsmodel.dart';
import 'package:transact/Supplier/supplierDashBoard.dart';

import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/creditCardForm.dart';
import 'package:transact/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transact/utils/utils.dart';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _group;
  bool _add = false;
ProgressDialog pr;
  String newValue;
  PaymentCardsModel paymentCard=PaymentCardsModel();

  @override
  void initState() {
    _group = "1";
    super.initState();
    getPayment();
  }

getPayment()async
{
   var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.SupplierPaymentCards}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
if(response.statusCode==200)
{
 if(Json['Data']['WithError']==true)
 {
    Fluttertoast.showToast(
              msg: "no payment card found",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
 }else
 {
     setState(() {
         paymentCard=PaymentCardsModel.fromJson(Json['Data']);
        });
 }
}
else
{
 Fluttertoast.showToast(
              msg: "response statue: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
}
}

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomeAppBar(
              title: _add == false ? "Payment Method" : "Add Card",
            ),
          ),
          bottomNavigationBar: _add == false
              ? BottomButton(
                  name: "Proceed",
                  ontap: () {},
                )
              : null,
          body: SingleChildScrollView(
            primary: true,
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                children: <Widget>[
                  _cardSwipe(),
                  _cardSelection(),
                  // _add == false ? _addNewButton() : Container(),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget _cardSwipe() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: MediaQuery.of(context).size.height * .2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: paymentCard.result!=null?paymentCard.result.length:0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(left:12,right:12),
            width: MediaQuery.of(context).size.width / 1.4,
            child:paymentCards(index)
            // child: Image.asset("images/Visacard.png"),
            // fit: BoxFit.fill,
          );
        },
      ),
    );
  }


Widget paymentCards(int index)
{
  return Container(
     width: MediaQuery.of(context).size.width / 1.4,
    //  height:MediaQuery.of(context).size.height*.24,
     decoration: BoxDecoration(
       color: Colors.pink,
       border: Border.all(color:Colors.blueGrey,width:1),
       borderRadius: BorderRadius.all(Radius.circular(12))
     ),
     child: Column(
       children: <Widget>[
         Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top:10,right:15),
               child:
               paymentCard.result[index].cardType==0?
               Image.asset("images/debit.png",scale: 18,)
               :paymentCard.result[index].cardType==1?
                 Image.asset("images/prepaid.png",scale: 18,):
                 Image.asset("images/credit.png",scale: 18,)

             ),
           ],
         ),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top:30),
               child: Text("${paymentCard.result[index].cardNum} ${paymentCard.result[index].cvv}",style: TextStyle(color: Colors.white,fontSize: 17,)),
             ),
           ],
         ),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(left:15,top:30),
               child: Text("${paymentCard.result[index].holderName}",style: TextStyle(color: Colors.white,fontSize: 17),),
             ),
             Padding(
               padding: EdgeInsets.only(left:15,top:30),
               child: Text("${paymentCard.result[index].expiryMonth}/${paymentCard.result[index].expiryYear}",style: TextStyle(color: Colors.white,fontSize: 17),),
             ),
             
           ],
         ),
       ],
     ),
    
  );
}
  Widget _cardSelection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width / 1.2,
      child: Column(
        children: <Widget>[
          //_radioCard("E-Wallet", "E-Wallet", "images/wallet.png"),
          _radioCard("Master", "Debit", "images/debit.png"),
          _radioCard("Visa", "Credit", "images/credit.png"),
          _radioCard("PayPal", "Prepaid", "images/prepaid.png"),
        ],
      ),
    );
  }

  Widget _radioCard(String value, String text, String img) {
    return GestureDetector(
        onTap: () {
          if (value == "Master") {
            setState(() {
              User.userData.cardType = 0;
            });
             AppRoutes.push(context, AddCardSeller());
          } else if (value == "Visa") {

             setState(() {
              User.userData.cardType = 1;
            });
             AppRoutes.push(context, AddCardSeller());
          } else {

             setState(() {
              User.userData.cardType = 2;
            });
             AppRoutes.push(context, AddCardSeller());
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "$text",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: HexColor('#2F8FFF'), fontSize: 14),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Image(
                    height: 30,
                    width: 10,
                    image: AssetImage("$img"),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _addNewButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 10, left: 25, right: 25, top: 20),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: HexColor("#3B444B")),
        child: BottomButton(
          name: "+ Add New Card",
          ontap: () {
            setState(() {
              AppRoutes.push(context, AddCardSeller());
            });
          },
        ));
  }
}

class AddCardSeller extends StatefulWidget {
  @override
  _AddCardSellerState createState() => _AddCardSellerState();
}

class _AddCardSellerState extends State<AddCardSeller> {
  TextEditingController cardnumController = TextEditingController();
  TextEditingController holderController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool _added = false;
ProgressDialog pr;
addPayment()
async

{
  pr.show();
  var month=expiryDate.split("/");
  print(month[0]);
  var year=month[1];
  print(year);
   var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
var body = {
      "HolderName": "$cardHolderName",
      "CVV": "$cvvCode",
      "CardNumber": "$cardNumber",
      "CardType": "${User.userData.cardType}",
      "ExpiryMonth": "${month[0]}",
      "ExpiryYear": "$year",
      "CreatedOn":"12/2/2022"
    };
    print(body);
    var response = await http.post(
      "${API.SupplierAddPayment}",
      body: body,
      headers: header,
    );
    print(json.decode(response.body));
    var Json=json.decode(response.body);
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
              // var route=MaterialPageRoute(
              //   builder: (BuildContext context)=>new SupplierDashBoard()
              // );
              // Navigator.of(context).pushReplacement(route);
               Navigator.of(context).pop();
      }
      else
      {
        pr.dismiss();
         Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);

      }
    }
    else
    {
      pr.dismiss();
       Fluttertoast.showToast(
              msg: "response Status: ${response.statusCode}",
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
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: _added == false
              ? BottomButton(
                  name: "Proceed",
                  ontap: () {
                    print(cardHolderName);
                    print(cvvCode);
                    print(expiryDate);
                    print(cardNumber);
                    if(cardHolderName.isEmpty ||
                    cvvCode.isEmpty ||
                    expiryDate.isEmpty ||
                    cardNumber.isEmpty 
                    )
                    {
                       Fluttertoast.showToast(
              msg: "Please enter the required field",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
                    }
                    else{
                       addPayment();
                    }
                   
                    // setState(() {
                    //   _added = true;
                    // });
                  },
                )
              : null,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomeAppBar(
              title: "Add Card",
            ),
          ),
          body: SingleChildScrollView(
            primary: true,
            physics: BouncingScrollPhysics(),
            child: Container(
              child: _added == false
                  ? Column(
                      children: <Widget>[
                        _card(),
                        CreditCardForm(
                          onCreditCardModelChange: onCreditCardModelChange,
                          expiryDate: expiryDate,
                          cardNumber: cardNumber,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  : _cardAdded(),
            ),
          )),
    );
  }

  Widget _card() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: CreditCardWidget(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        showBackView: isCvvFocused,
        height: 175,
        textStyle: TextStyle(color: Colors.yellowAccent),
        width: MediaQuery.of(context).size.width,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Widget _cardAdded() {
    return Center(
      heightFactor: 1.5,
      child: Container(
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width / 1.2,
        //  / padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 20),
              child: Image(
                height: 200,
                width: 280,
                image: AssetImage("images/Visacard.png"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  AppRoutes.replace(context, PaymentMethod());
                });
              },
              child: Image(
                height: 50,
                width: 100,
                image: AssetImage("images/success.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Text(
                "Card Added Succesfully!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
