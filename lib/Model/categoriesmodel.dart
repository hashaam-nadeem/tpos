
class CategoriesModel {
  final bool withError;
  final String shortMessage;
  final List<CategoriesResult> result;

  CategoriesModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => CategoriesResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class CategoriesResult {
   int id;
   String name;
   String imagePath;
   String description;
   String updateAll;
   String date;
  

  CategoriesResult({
    this.id,
    this.name,
    this.description,
    this.updateAll,
    this.imagePath,
    this.date
  });

  factory CategoriesResult.fromJson(Map<String, dynamic> json) {
    return CategoriesResult(
      id: json['Id']??0,
      name: json['Name'] ?? "",
      description: json['Description'] ?? "",
      updateAll: json['UpdatedAt'] ?? "",
      imagePath: json['IconUrl'] ?? "",
       date: json['CreatedOn'] ?? "",
    );
  }
}

