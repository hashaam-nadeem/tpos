import 'package:transact/Model/addressesmodel.dart';
import 'package:transact/Model/ordermodel.dart';
import 'package:transact/Model/personalInfomodel.dart';
import 'package:transact/Model/productsearchmodel.dart';
import 'package:transact/Model/supplierdashboardmodel.dart';
import 'package:transact/Model/userdatamodel.dart';

import 'marketplacemodel.dart';

class User {
  // singleton
  static final User _singleton = User._internal();
  factory User() => _singleton;
  User._internal();
  static User get userData => _singleton;
  bool filter;
  String deviceId;
  String token;
  UserResult userResult;
  bool supplierOnlineStatus;
  DashBoardModel dashBoardResult;
  MarketPlaceModel marketPlaceModel;
  ProductSearchModel productSearchModel;
  int cardType;
  int index;
  List<String> id=List<String>();
  List<String> image=List<String>();
  List<String> name=List<String>();
  List<String> price=List<String>();
  AddressModel addressModel;
  double total=0.0;
  int count=0;
  String userStoreId;
  var totalCart;
  int otherUserId;
  var deliveryCost;
  String email,contact;
  int deliveryOption=2;
  OrderModel orderModel;
  String barCode="";
  String addressLine="";
  String verifiedEmail;
  double lat,long=0.0;
  var pin;
  String drawerItem;
  bool getSellerProduct=false;
  int rememberPin=0;
  GetPersonalInfo getPersonalInfo;
}