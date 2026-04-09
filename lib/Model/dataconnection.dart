import 'package:data_connection_checker/data_connection_checker.dart';
class InternetVerification
{

static Future<bool> getdataconnection() async
  {
    bool result;
     result = await DataConnectionChecker().hasConnection.then((onValue)
     {
       result=onValue;
       if(result == true) {
  print('YAY! Free cute dog pics!');
  //result=true;
  return result;
} else {
  print('No internet :( Reason:');
  print(DataConnectionChecker().lastTryResults);
 // result=false;
  return result;
}
     });

  }
}