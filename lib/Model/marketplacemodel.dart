class MarketPlaceModel {
  final bool withError;
  final String shortMessage;
  final List<MarketPlaceResult> result;

  MarketPlaceModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory MarketPlaceModel.fromJson(Map<String, dynamic> json) {
    return MarketPlaceModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => MarketPlaceResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class MarketPlaceResult {
  var id;
  String name;
  var code;
  String description;
  String specification;
  var actualPrice;
  var salePrice;
  var qty;
  var totalDiscount;
  var gst;
  bool withDiscount;
  bool isDiscountPercentage;
  bool isProductVisible;
  bool isLikeByMe;
  String userId;
  var type;
  var rating;
  var categoryId;
  String categoryName;
  var minOrder;
  String imagePath;
  List<ImagesList> imgList;
  List<FeedBackList> feedback;


  MarketPlaceResult({
    this.id,
    this.userId,
    this.qty,
    this.rating,
    this.name,
    this.description,
    this.isLikeByMe,
    this.imgList,
    this.specification,
    this.salePrice,
    this.withDiscount,
    this.actualPrice,
    this.categoryId,
    this.categoryName,
    this.code,
    this.gst,
    this.imagePath,
    this.isDiscountPercentage,
    this.isProductVisible,
    this.feedback,
    this.minOrder,
    this.totalDiscount,
    this.type,
  });

  factory MarketPlaceResult.fromJson(Map<String, dynamic> json) {
    return MarketPlaceResult(
      imgList: (json['ResponseImageUrls'] as List).map((e) => ImagesList.fromJson(e)).toList(),
     feedback: (json['Feedback'] as List).map((e) => FeedBackList.fromJson(e)).toList(),
      id: json['Id'] ?? 0,
      name: json['Name'] ?? "",
      description: json['Description'] ?? "",
       code: json['Code'] ?? 0,
      specification: json['Specification'] ?? "",
      imagePath: json['FeatureImageUrl'] ?? "",
       actualPrice: json['ActuallPrice'] ?? 0,
      salePrice: json['SalePrice'] ?? "",
      gst: json['GST'] ?? "",
       minOrder: json['MinOrder'] ?? 0,
      totalDiscount: json['TotalDiscount'] ?? "",
      withDiscount: json['WithDiscount'] ?? "",
       isDiscountPercentage: json['IsDiscountPercentage'] ?? "",
       isProductVisible: json['IsProductVisible'] ?? 0,
      type: json['Type'] ?? "",
      categoryId: json['CategoryId'] ?? "",
       categoryName: json['CategoryName'] ?? "",
       isLikeByMe: json['IsLikedByMe'] ?? "",
       userId: json['UserId'] ?? "",
        rating: json['Rating'] ?? 0.0,
         qty: json['Qty'] ?? 0.0,
    );
  }
}


class ImagesList
{

String url;
ImagesList({
 this.url
});

  factory ImagesList.fromJson(Map<String, dynamic> json) {
    return ImagesList(
      url: json['url'],
    );
  }
}

class FeedBackList
{

String id;
String name;
String feedBack;
var rate;
String date;

FeedBackList({
 this.date,this.feedBack,this.id,this.name,this.rate
});

  factory FeedBackList.fromJson(Map<String, dynamic> json) {
    return FeedBackList(
      id: json['Id'],
      name: json['Name'],
      rate: json['Rate'],
      feedBack: json['FeedBack'],
      date: json['Date'],
    );
  }
}