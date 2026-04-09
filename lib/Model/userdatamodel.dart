class UserDataModel {
  final bool withError;
  final String shortMessage;
  final UserResult result;

  UserDataModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      withError: json['WithError'],
      result: UserResult.fromJson(json['Result']),
      shortMessage: json['ShortMessage'],
    );
  }
}

class UserResult {
  String id;
  String fullname;
  String email;
  String imageUrl;
  String referal;
  int role;
  String token;
  bool profileCompleted;
  bool isOnline;
  String phoneNo;
  String deviceId;
  String pass;
  String confirmPass;
  String myReferal;
  bool securityEnabled;
  bool notificationEnabled;

  UserResult(
      {this.confirmPass,
      this.pass,
      this.securityEnabled,
      this.notificationEnabled,
      this.deviceId,
      this.referal,
      this.phoneNo,
      this.myReferal,
      this.email,
      this.fullname,
      this.id,
      this.imageUrl,
      this.isOnline,
      this.profileCompleted,
      this.role,
      this.token});

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      token: json['ValidToken'],
      id: json['Id'],
      fullname: json['Username'] ?? "",
      phoneNo: json['PhoneNumber'] ?? "",
      referal: json['Referral'] ?? "",
      deviceId: json['DeviceId'] ?? "",
      pass: json['Password'] ?? "",
      confirmPass: json['ConfirmPassword'],
      role: json['Role'],
      imageUrl: json['ImageUrl'],
      isOnline: json['IsOnline'],
      email: json['Email'],
       profileCompleted: json['IsElementaryProfileCompleted'],
       myReferal: json['MyReferral'],
      securityEnabled : json['IsSecurityEnable'],
       notificationEnabled: json['IsPushNotificationEnable'],
    );
  }
}
