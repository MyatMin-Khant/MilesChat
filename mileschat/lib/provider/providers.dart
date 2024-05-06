import 'package:flutter/material.dart';

class SubmitData extends ChangeNotifier {
  bool nameanimatorcon = false;
  bool dateanimatorcon = false;
  bool genderanimatorcon = false;
  bool datecontrollercon = false;


  updateNameAnimator() {
    nameanimatorcon ? nameanimatorcon = false : nameanimatorcon = true;
    notifyListeners();
  }
  updateDateControllerCon() {
    datecontrollercon ? datecontrollercon = false : datecontrollercon = true;
    notifyListeners();
  }
  updateDateAnimator() {
    dateanimatorcon ? dateanimatorcon = false : dateanimatorcon = true;
    notifyListeners();
  }
  updateGenderAnimator() {
    genderanimatorcon ? genderanimatorcon  = false : genderanimatorcon = true; 
    notifyListeners();
  }
  getNameAnimatorCon() => nameanimatorcon;
  getDateAnimatorCon() => dateanimatorcon;
  getGenderAnimatorCon() => genderanimatorcon;
  getDateControllerCon() => datecontrollercon;

 }
class DataProperties extends ChangeNotifier {
  bool bottomsheetdragstatus = true;
  DateTime selectedDate = DateTime(1950);
  GenderChoice selectedgender = GenderChoice.female;


  updateBottomSheetDragStatus() {
    bottomsheetdragstatus  =  bottomsheetdragstatus  ? true : false;
    notifyListeners();
  }
 
  updateSelectedGenderChoice(GenderChoice selected) {
    selectedgender = selected;
    notifyListeners();
  }
  updateSelectedDate(DateTime pickDate) {
    selectedDate = pickDate;
    notifyListeners();
  }
  
  getSelectedGenderChoice() => selectedgender;
  getBottomSheetDragStatus() => bottomsheetdragstatus;
  getSelectedDate() => selectedDate;

}
enum GenderChoice {
  male,
  female
  
}
class ShimmerLoadingStatus extends ChangeNotifier {
  bool shprofileimgstatus  = false;
  updateShprofileImgstatus()  {
    shprofileimgstatus ? shprofileimgstatus =  false : shprofileimgstatus = true;
    notifyListeners();
  }
  getShprofileImgstatus() => shprofileimgstatus;

}
class SelectedPaymentService extends ChangeNotifier {
   static String paymentname = 'kbz';

   updatePaymentService(String  paytype) {
    paymentname = paytype;
    notifyListeners();
   }
   getPaymentService() => paymentname;
}
class RedirectPaymentGateWayUrl extends ChangeNotifier {
  static String redirecturl = "";

  updateredirecturl(String url) {
    redirecturl = url;
    notifyListeners(); 
  }
  getredirecturl() => redirecturl;
}
class CheckUserInfoStatus extends ChangeNotifier {
  static int _namerequest = 0;

  updateNameRequestStatus() {
    _namerequest == 0 ? _namerequest = 1 : _namerequest = 0;
    notifyListeners();
  }
  getNameRequestStatus() => _namerequest;
}
class  PermissionCheckNextStatus extends ChangeNotifier {

  bool _nextstatus = false;
  
 
  updateNextStatus() {
    _nextstatus ? _nextstatus = false : _nextstatus = true;
    notifyListeners();
  }
 
  getNextStatus() => _nextstatus; 

}



