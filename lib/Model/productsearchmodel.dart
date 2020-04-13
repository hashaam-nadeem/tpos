class ProductSearchModel {
  final bool withError;
  final String shortMessage;
  final List<ProductSearchResult> result;

  ProductSearchModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => ProductSearchResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class ProductSearchResult {
  var id;
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
  bool isLikeByMe;
  String userId;
  var type;
  var categoryId;
  String categoryName;
  var minOrder;
  String imagePath;
  List<ImagesList> imgList;
  List<FeedBackList> feedback;
  ProductSearchResult({
    this.id,
    this.userId,
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
    this.feedback,
    this.code,
    this.gst,
    this.imagePath,
    this.isDiscountPercentage,
    this.isProductVisible,
    this.minOrder,
    this.totalDiscount,
    this.type,
  });

  factory ProductSearchResult.fromJson(Map<String, dynamic> json) {
    return ProductSearchResult(
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