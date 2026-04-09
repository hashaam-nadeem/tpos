import 'UserModel.dart';

class AuthenticationUser
{
  //get authentication
  static String getAuthentication() {
    return "token ${User.userData.token}:${User.userData.userResult.id}";
  }
}