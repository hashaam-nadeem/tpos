class GetPersonalInfo {
  final bool withError;
  final String shortMessage;
  final InfoResult result;

  GetPersonalInfo({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory GetPersonalInfo.fromJson(Map<String, dynamic> json) {
    return GetPersonalInfo(
      withError: json['WithError'],
      result: InfoResult.fromJson(json['Result']),
      shortMessage: json['ShortMessage'],
    );
  }
}

class InfoResult {
  int id;
  String country;
  String state;
  String city;
  String address;
  String contact;
  String fullName;
  

  InfoResult(
      {
        this.id,this.address,this.city,this.contact,this.country,this.fullName,this.state
        });

  factory InfoResult.fromJson(Map<String, dynamic> json) {
    return InfoResult(
      id: json['Id']??0,
      fullName: json['Fullname'] ?? "",
      city: json['City']??"",
      state: json['State'] ?? "",
      country: json['Country'] ?? "",
      address: json['Address'] ?? "",
      contact: json['Contact'] ?? "",
      
    );
  }
}
