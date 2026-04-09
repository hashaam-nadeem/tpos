
import 'package:transact/Supplier/wallet.dart';

class API {
  /*------------------------------------------------------------
                          API URL
  -------------------------------------------------------------*/
  static const String API_URL = "http://tpos.eqareeb.com/";


               /*------------------------------------------------------------
                 API:Sign Up
                 TYPE: post
  -------------------------------------------------------------*/
      static const SignUp =
      "$API_URL/Api/User/SignUp";


      /*------------------------------------------------------------
                 API:Sign In
                 TYPE: post
  -------------------------------------------------------------*/
      static const SignIn =
      "$API_URL/Api/User/SignIn";


            /*------------------------------------------------------------
                 API:Refresh Token
                 TYPE: get
  -------------------------------------------------------------*/
      static const refreshToken =
      "$API_URL/Api/User/RefreshToken";


      
            /*------------------------------------------------------------
                 API:Refresh Token
                 TYPE: get
  -------------------------------------------------------------*/
      static const onLineSupplierStatus =
      "$API_URL/Api/User/MarkUserOnline";

        /*------------------------------------------------------------
                 API:Update Elementory
                 TYPE: post
  -------------------------------------------------------------*/
      static const UpdateElementory =
      "$API_URL/Api/User/UpdateElementaryProfile";

      /*------------------------------------------------------------
                 API:Update Elementory
                 TYPE: post
  -------------------------------------------------------------*/
      static const UpdateProfile =
      "$API_URL/Api/User/UpdateUserProfile";

       /*------------------------------------------------------------
                 API:Update Elementory
                 TYPE: post
  -------------------------------------------------------------*/
      static const UpdateP =
      "$API_URL/Api/User/UpdateProfile";

       /*------------------------------------------------------------
                 API:Update image
                 TYPE: post
  -------------------------------------------------------------*/
      static const UploadImage =
      "$API_URL/Api/Shared/UploadImage";
  /*------------------------------------------------------------
                 API:Add Product
                 TYPE: post
  -------------------------------------------------------------*/
      static const addProduct =
      "$API_URL/Api/Products/AddProduct";

        /*------------------------------------------------------------
                 API:get Categories
                 TYPE: get
  -------------------------------------------------------------*/
      static const getCategories =
      "$API_URL/Api/Products/GetProductCategories";
      
       /*------------------------------------------------------------
                 API:Supplier dashboard
                 TYPE: get
  -------------------------------------------------------------*/
      static const SupplierDashboardProduct =
      "$API_URL/Api/Products/GetProducts?type=0";
/*------------------------------------------------------------
                 API:Supplier dashboard
                 TYPE: get
  -------------------------------------------------------------*/
      static const BundleProducts =
      "$API_URL/Api/Products/GetProducts?type=1";
      
        /*------------------------------------------------------------
                 API:Supplier Wallet
                 TYPE: get
  -------------------------------------------------------------*/
      static const SupplierWallet =
      "$API_URL/Api/Shared/ViewPaymentsCards";

       /*------------------------------------------------------------
                 API:Supplier addpayment
                 TYPE: post
  -------------------------------------------------------------*/
      static const SupplierAddPayment =
      "$API_URL/Api/Shared/AddPayment";

       /*------------------------------------------------------------
                 API:Supplier addpayment
                 TYPE: get
  -------------------------------------------------------------*/
      static const SupplierPaymentCards =
      "$API_URL/Api/Shared/ViewPaymentsCards";



       /*------------------------------------------------------------
                 API:Search Product
                 TYPE: get
  -------------------------------------------------------------*/
      static const SearchProduct =
      "$API_URL/Api/Products/SearchProducts";
      

      /*------------------------------------------------------------
                 API:headlist
                 TYPE: get
  -------------------------------------------------------------*/
      static const HeadList =
      "$API_URL/Api/Account/GetHead";

      /*------------------------------------------------------------
                 API:add general
                 TYPE: post
  -------------------------------------------------------------*/
      static const AddGeneral =
      "$API_URL/Api/Account/AddJournal";

      /*------------------------------------------------------------
                 API:get general
                 TYPE: get
  -------------------------------------------------------------*/
      static const getGeneral =
      "$API_URL/Api/Account/GetJournal";


      /*------------------------------------------------------------
                 API:get general
                 TYPE: post
  -------------------------------------------------------------*/
      static const addHeader =
      "$API_URL/Api/Account/AddHead";

        /*------------------------------------------------------------
                 API:get header
                 TYPE: get
  -------------------------------------------------------------*/
      static const getHeader =
      "$API_URL/Api/Account/GetHead";


       /*------------------------------------------------------------
                 API:Market place
                 TYPE: get
  -------------------------------------------------------------*/
      static const marketPlaceProducts =
      "$API_URL/Api/Shared/GetMarketPlace";
       /*------------------------------------------------------------
                 API:addCartLine
                 TYPE: post
  -------------------------------------------------------------*/
      static const addCartLine =
      "$API_URL/Api/Shared/AddCartLine";

             /*------------------------------------------------------------
                 API:getCart
                 TYPE: get
  -------------------------------------------------------------*/
      static const getCart =
      "$API_URL/Api/Shared/GetCart";

 /*------------------------------------------------------------
                 API:confirmCart
                 TYPE: post
  -------------------------------------------------------------*/
      static const confirmCart =
      "$API_URL/Api/Shared/CreateSaleOrder";

       /*------------------------------------------------------------
                 API:delete Cart
                 TYPE: post
  -------------------------------------------------------------*/
      static const deleteCart =
      "$API_URL/Api/Shared/DeleteCartLine";


         /*------------------------------------------------------------
                 API:getProductInStock
                 TYPE: get
  -------------------------------------------------------------*/
      static const getProductInStock =
      "$API_URL/Api/Orders/QtyInStock";

      /*------------------------------------------------------------
                 API:getReceivedOrder
                 TYPE: get
  -------------------------------------------------------------*/
      static const getReceivedOrder =
      "$API_URL/Api/Orders/GetReceivedOrders";



      /*------------------------------------------------------------
                 API:AcceptOrder
                 TYPE: post
  -------------------------------------------------------------*/
      static const AcceptOrder =
      "$API_URL/Api/Orders/AcceptOrder";

      /*------------------------------------------------------------
                 API:RejectOrder
                 TYPE: post
  -------------------------------------------------------------*/
      static const RejectOrder =
      "$API_URL/Api/Orders/RejectOrder";


       /*------------------------------------------------------------
                 API:StoreProduct
                 TYPE: get
  -------------------------------------------------------------*/
      static const StoreProduct =
      "$API_URL/Api/Shared/GetUserStore";

      /*------------------------------------------------------------
                 API:StoreProduct
                 TYPE: get
  -------------------------------------------------------------*/
      static const LikeProduct=
      "$API_URL/Api/Products/Like";

      /*------------------------------------------------------------
                 API:deliverOrder
                 TYPE: post
  -------------------------------------------------------------*/
      static const deliverOrder=
      "$API_URL/Api/Orders/OrderDelivered";



      /*------------------------------------------------------------
                 API:getMyOrder
                 TYPE: get
  -------------------------------------------------------------*/
      static const getMyOrder=
      "$API_URL/Api/Orders/GetMyOrders";


      /*------------------------------------------------------------
                 API:getFcm
                 TYPE: get
  -------------------------------------------------------------*/
      static const getFcm=
      "$API_URL/Api/User/GetFCMToken";

      /*------------------------------------------------------------
                 API:rateProduct
                 TYPE: post
  -------------------------------------------------------------*/
      static const feedBack=
      "$API_URL/Api/Products/FeedBack";


      /*------------------------------------------------------------
                 API:getAddres
                 TYPE: get
  -------------------------------------------------------------*/
      static const getAddresses=
      "$API_URL/Api/User/GetDeliveryAddress";

      /*------------------------------------------------------------
                 API:addAddress
                 TYPE: post
  -------------------------------------------------------------*/
      static const addAddress=
      "$API_URL/Api/User/AddDeliveryAddress";

       /*------------------------------------------------------------
                 API:getDeliveryCost
                 TYPE: get
  -------------------------------------------------------------*/
      static const getDeliveryCost=
      "$API_URL/Api/Shared/UserDeliveryDetail";

 /*------------------------------------------------------------
                 API:getCategoryData
                 TYPE: get
  -------------------------------------------------------------*/
      static const getCategoryData=
      "$API_URL/Api/Shared/GetMarketPlaceByCategory";

       /*------------------------------------------------------------
                 API:ProductSearchApi
                 TYPE: get
  -------------------------------------------------------------*/
      static const ProductSearchApi=
      "$API_URL/Api/Shared/SearchMarketPlace";

      /*------------------------------------------------------------
                 API:ProductSearchApi
                 TYPE: get
  -------------------------------------------------------------*/
      static const UpdateUserSetting=
      "$API_URL/Api/User/UpdateSetting";

      /*------------------------------------------------------------
                 API:AddWishList
                 TYPE: get
  -------------------------------------------------------------*/
      static const AddWishList=
      "$API_URL/Api/Products/Wishlist";
      /*------------------------------------------------------------
                 API:getWishList
                 TYPE: get
  -------------------------------------------------------------*/
      static const getWishList=
      "$API_URL/Api/Shared/GetWishList";

      /*------------------------------------------------------------
                 API:ContactsusApi
                 TYPE: post
  -------------------------------------------------------------*/
      static const ContactsusApi=
      "$API_URL/Api/Shared/SendMessage";

       /*------------------------------------------------------------
                 API:ContactsusApi
                 TYPE: post
  -------------------------------------------------------------*/
      static const saleHistory=
      "$API_URL/Api/Products/SaleHistory";

      /*------------------------------------------------------------
                 API:PurchaseHistory
                 TYPE: post
  -------------------------------------------------------------*/
      static const PurchaseHistory=
      "$API_URL/Api/Products/PurchaseHistory";

      /*------------------------------------------------------------
                 API:getAllNotification
                 TYPE: get
  -------------------------------------------------------------*/
      static const getAllNotification=
      "$API_URL/Api/Shared/GetNotification";

            /*------------------------------------------------------------
                 API:walletapi
                 TYPE: get
  -------------------------------------------------------------*/
      static const walletapi=
      "$API_URL/Api/Shared/MyWallet";


       /*------------------------------------------------------------
                 API:ReportApi
                 TYPE: get
  -------------------------------------------------------------*/
      static const ReportApi=
      "$API_URL/Api/Products/Report";

      /*------------------------------------------------------------
                 API:SupplierProductSearch
                 TYPE: get
  -------------------------------------------------------------*/
      static const SupplierProductSearch=
      "$API_URL/Api/Products/SearchProducts";


        /*------------------------------------------------------------
                 API:EmailVerification
                 TYPE: post
  -------------------------------------------------------------*/
      static const EmailVerification=
      "$API_URL/Api/User/SendVerifyEmail";

       /*------------------------------------------------------------
                 API:VerifyEmail
                 TYPE: post
  -------------------------------------------------------------*/
      static const VerifyEmail=
      "$API_URL/Api/User/VerifyEmail";
       /*------------------------------------------------------------
                 API:VerifyEmail
                 TYPE: post
  -------------------------------------------------------------*/
      static const ForgotPassword=
      "$API_URL/Api/User/ForgetPassword";


        /*------------------------------------------------------------
                 API:markUserOnline
                 TYPE: post
  -------------------------------------------------------------*/
      static const markUserOnline=
      "$API_URL/Api/User/MarkUserOnline";

      /*------------------------------------------------------------
                 API:productsVisibilty
                 TYPE: post
  -------------------------------------------------------------*/
      static const productsVisibilty=
      "$API_URL/Api/Products/MarkProductVisible";

      /*------------------------------------------------------------
                 API:CancelOrder
                 TYPE: post
  -------------------------------------------------------------*/
      static const CancelOrder=
      "$API_URL/Api/Orders/OrderCanceled";

      /*------------------------------------------------------------
                 API:toPay
                 TYPE: get
  -------------------------------------------------------------*/
      static const toPay=
      "$API_URL/Api/Orders/ToPayOrders";

       /*------------------------------------------------------------
                 API:CancelList
                 TYPE: get
  -------------------------------------------------------------*/
      static const CancelList=
      "$API_URL/Api/Orders/GetCanceledOrders";

       /*------------------------------------------------------------
                 API:AddPin
                 TYPE: post
  -------------------------------------------------------------*/
      static const AddSecurityPin=
      "$API_URL/Api/SecurityPin/Add";

      /*------------------------------------------------------------
                 API:ViewUserPins
                 TYPE: get
  -------------------------------------------------------------*/
      static const ViewUserPins=
      "$API_URL/Api/SecurityPin/ViewUserPins";

      /*------------------------------------------------------------
                 API:ViewPinsModules
                 TYPE: get
  -------------------------------------------------------------*/
      static const ViewPinsModules=
      "$API_URL/Api/SecurityPin/ViewModules";

      /*------------------------------------------------------------
                 API:AssignModules
                 TYPE: post
  -------------------------------------------------------------*/
      static const AssignModules=
      "$API_URL/Api/SecurityPin/AssignModule";

        /*------------------------------------------------------------
                 API:EnableSecurity
                 TYPE: post
  -------------------------------------------------------------*/
      static const EnableSecurity=
      "$API_URL/Api/User/EnableScurity";

      /*------------------------------------------------------------
                 API:PinCheckerModuleName
                 TYPE: post
  -------------------------------------------------------------*/
      static const PinCheckerModuleName=
      "$API_URL/Api/SecurityPin/PinCheckerByModuleName";

         /*------------------------------------------------------------
                 API:changePassowrd
                 TYPE: post
  -------------------------------------------------------------*/
      static const changePassowrd=
      "$API_URL/Api/User/ChangePassword";

       /*------------------------------------------------------------
                 API:cashierAddToCart
                 TYPE: post
  -------------------------------------------------------------*/
      static const cashierAddToCart=
      "$API_URL/Api/Shared/AddCartLineCash";

      /*------------------------------------------------------------
                 API:getCashierCart
                 TYPE: get
  -------------------------------------------------------------*/
      static const getCashierCart=
      "$API_URL/Api/Shared/GetCashierCart";

      /*------------------------------------------------------------
                 API:deleteCashierCartLine
                 TYPE: post
  -------------------------------------------------------------*/
      static const deleteCashierCartLine=
      "$API_URL/Api/Shared/DeleteCashierCartLine";

      /*------------------------------------------------------------
                 API:cashierConfirmCart
                 TYPE: post
  -------------------------------------------------------------*/
      static const cashierConfirmCart=
      "$API_URL/Api/Shared/CreateSaleOrderForCashier";

       /*------------------------------------------------------------
                 API:getPerosalInformation
                 TYPE: get
  -------------------------------------------------------------*/
      static const getPerosalInformation=
      "$API_URL/Api/User/GetPersonalInformation";


       /*------------------------------------------------------------
                 API:TotalExpanse
                 TYPE: get
  -------------------------------------------------------------*/
      static const TotalExpanse=
      "$API_URL/Api/Account/ExpenseReport";

      /*------------------------------------------------------------
                 API:TotalSaleHistory
                 TYPE: get
  -------------------------------------------------------------*/
      static const TotalSaleHistory=
      "$API_URL/Api/Products/SaleHistory";

      /*------------------------------------------------------------
                 API:TotalPurchaseHistory
                 TYPE: get
  -------------------------------------------------------------*/
      static const TotalPurchaseHistory=
      "$API_URL/Api/Products/PurchaseHistory";

            /*------------------------------------------------------------
                 API:CartEmpty
                 TYPE: get
  -------------------------------------------------------------*/
      static const CartEmpty=
      "$API_URL/Api/Shared/MakeCartEmpty";

       /*------------------------------------------------------------
                 API:marketPlaceStoreType
                 TYPE: get
  -------------------------------------------------------------*/
      static const marketPlaceStoreType=
      "$API_URL/Api/Shared/GetMarketPlaceByStoreType";
      

      /*------------------------------------------------------------
                 API:getUserSettings
                 TYPE: get
  -------------------------------------------------------------*/
      static const getUserSettings=
      "$API_URL/Api/User/GetUserSetting";

      /*------------------------------------------------------------
                 API:markAllSeenNotification
                 TYPE: get
  -------------------------------------------------------------*/
      static const markAllSeenNotification=
      "$API_URL/Api/Shared/MarkNotificationSeen";
          /*------------------------------------------------------------
                 API:markAllSeenNotification
                 TYPE: get
  -------------------------------------------------------------*/
      static const LatlongFilter=
      "$API_URL/Api/Shared/GetMarketPlaceByLocation";
}



