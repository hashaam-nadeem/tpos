
class AddressModel {
  final bool withError;
  final String shortMessage;
  final List<AddressResult> result;

  AddressModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => AddressResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class AddressResult {
   int id;
 
   String country;
   String state;
   var city;
   var address;
  
  

  AddressResult({
    this.address,this.state,this.country,this.id,this.city
  });

  factory AddressResult.fromJson(Map<String, dynamic> json) {
    return AddressResult(
      id: json['Id']??0,
      country: json['Country'] ?? "",
      city: json['City'] ?? "",
      state: json['State'] ?? "",
      address: json['Address'] ?? "",
      
    );
  }
}

