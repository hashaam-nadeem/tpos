class DashBoardModel {
  final bool withError;
  final String shortMessage;
  final List<DashBoardResult> result;

  DashBoardModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => DashBoardResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class DashBoardResult {
  var id;
  var rating;
  String name;
  var code;
  String description;
  String specification;
  var actualPrice;
  var salePrice;
  var totalDiscount;
  var gst;
  bool withDiscount;
  bool isDiscountPercentage;
  bool isProductVisible;
  String userId;
  var type;
  var categoryId;
  String categoryName;
  var minOrder;
  bool isLikeByMe;
  String imagePath;
  var qty;
  List<ImagesList> imgList;
    List<FeedBackList> feedback;

  DashBoardResult({
    this.id,
    this.name,
    this.qty,
        this.userId,
        this.feedback,
    this.description,
    this.imgList,
    this.specification,
    this.salePrice,
    this.isLikeByMe,
    this.withDiscount,
    this.actualPrice,
    this.categoryId,
    this.rating,
    this.categoryName,
    this.code,
    this.gst,
    this.imagePath,
    this.isDiscountPercentage,
    this.isProductVisible,
    this.minOrder,
    this.totalDiscount,
    this.type,
  });

  factory DashBoardResult.fromJson(Map<String, dynamic> json) {
    return DashBoardResult(
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
int rate;
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