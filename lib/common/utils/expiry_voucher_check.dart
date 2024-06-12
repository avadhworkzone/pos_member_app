import 'package:intl/intl.dart';

class ExpiryCheck{
static  bool isVoucherExpired({String? date}){

  DateFormat format = DateFormat("dd-MM-yyyy");
  DateTime dateTime = format.parse(date!);
    DateTime getDate=dateTime;
    // DateTime getDate=DateTime.parse(date!);

    DateTime now=DateTime.now();
    print('is after===${ now.isAfter(getDate)}');
    if(now.isAfter(getDate)==true){
      return true;
    }else{
      return false;

    }
  }
}