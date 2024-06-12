import 'package:flutter/material.dart';

import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';

abstract class WordConstants {
  static Future<WordConstants> of(BuildContext context) async {
    return AppLocalizationsDelegate.load(Locale(await getLocale(), ''));
  }

  String get appName {
    return "Member app";
  }

  ///common

  String get sSuccess {
    return 'Success';
  }

  String get sError {
    return 'Error';
  }

  ///welcome
  String get sWelcomeText {
    return "Welcome to\nAriani Family";
  }

  String get sWelcomeTextRegistered {
    return "If you are a registered\nmember, please";
  }

  String get sClickHereToRegister {
    return "Click here to register";
  }

  String get sAsAMember {
    return "as a Member";
  }

  ///login mobile number screen
  String get sBelowText {
    return 'As a registered member, you agree to a ';
  }

  String get sWhatIsYourPhoneNumber {
    return 'Enter your registered Phone Number';
  }

  String get sYourPhone {
    return 'Your Phone!';
  }

  String get sLogin {
    return 'Login';
  }

  String get sEnterPhoneNumber {
    return '';
  }

  String get sPleaseEnterTheValidPhoneNumber {
    return 'Please enter the valid phone number';
  }

  String get sMobileNumberScreenTop {
    return 'Are you member?';
  }

  String get sSendOTP {
    return 'Request OTP';
  }

  String get wGoNowError {
    return "Unable to access learning site";
  }

  ///login mobile number otp screen
  String get sOTPVerification {
    return 'OTP Verification';
  }

  String get sEnterYourVerificationCode {
    return 'Enter the verification code.';
  }

  String get sCancel {
    return 'Cancel';
  }

  String get sResend {
    return 'Resend';
  }

  String get sVerifyNow {
    return 'Verify Now';
  }

  String get sPleaseEnterTheValidPhoneNumberOtp {
    return 'Please enter the valid phone number otp';
  }

  String get sDidntYouReceiveAnyCode {
    return "Click here to resend code";
  }

  String get sResendNewCode {
    return "Resend New Code";
  }

  ///register profile screen
  String get sLetGetToKnowEachOther {
    return "Let's get to know each other!";
  }

  String get sInCaseWeHaveSomethingExcitingToShare {
    return "In case we have something exciting to share";
  }

  String get sSomeMerchantsMightHaveAGiftForYou {
    return "Some merchants might have a gift for you";
  }

  String get sWhatIsYour {
    return "What's your";
  }

  String get sSkip {
    return 'Skip';
  }

  String get sContinue {
    return 'Continue';
  }

  String get sFirstName {
    return 'First name';
  }

  String get sFullName {
    return 'Full name';
  }

  String get sEnterYourFirstName {
    return 'Enter your first name';
  }

  String get sEnterYourAddress {
    return 'Enter your address';
  }

  String get sLastName {
    return 'Last name';
  }

  String get sEnterYourLastName {
    return 'Enter your last name';
  }

  String get sDdMmYYYY {
    return 'YYYY-MM-DD';
  }

  String get sRaces {
    return 'Races';
  }

  String get sTitle {
    return 'Title';
  }

  String get sSelectTitles {
    return 'Select Titles';
  }

  String get sSelectRaces {
    return 'Select Races';
  }

  String get sGender {
    return 'Gender';
  }

  String get sSelectGender {
    return 'Select Gender';
  }

  String get sEmail {
    return 'Email';
  }

  String get sEnterYourEmail {
    return 'Enter your email';
  }

  String get sPleaseEnterTheFirstName {
    return 'Please enter the First name';
  }

  String get sPleaseEnterTheAddress {
    return 'Please enter the Address';
  }

  String get sPleaseEnterTheLastName {
    return 'Please enter the last name';
  }

  String get sPleaseEnterTheEmailId {
    return 'Please enter the email id';
  }

  String get sPleaseEnterTheCity {
    return 'Please enter the city';
  }

  String get sPleaseEnterThePostalCode {
    return 'Please enter the postal code';
  }

  String get sPleaseSelectRaces {
    return 'Please select races';
  }

  String get sPleaseSelectGender {
    return 'Please select gender';
  }

  String get sPleaseSelectDob {
    return 'Please select date Of birth';
  }

  ///home screen
  String get sTabMyCard {
    return 'My Card';
  }

  String get sTabEamPoints {
    return 'Eam Points';
  }

  String get sTabReward {
    return 'Reward';
  }

  String get sTabOrder {
    return 'Order';
  }

  String get sTabMyProfile {
    return 'My Profile';
  }

  ///home my profile
  String get sEditYourProfile {
    return 'Edit Your Profile';
  }

  String get sTransactions {
    return "Transactions";
  }

  // String  get sReferAFriend { return "Refer a friend";}
  // String  get sSettings { return "Settings";}
  String get sLogout {
    return "Log Out";
  }

  ///home reward
  // String  get sLoyaltyPoints { return 'Loyalty Points';}
  String get sVouchers {
    return 'Vouchers';
  }

  String get sTotalPoints {
    return 'Total points';
  }

  String get sRedeemPoints {
    return 'Redeem points';
  }

  String get sAvailablePoints {
    return 'Available points';
  }

  ///home My Card
  String get sAddToWallet {
    return 'ADD TO WALLET';
  }

  String get sLoyaltyPoints {
    return 'Loyalty Points';
  }

  String get sLatestTransaction {
    return 'Latest Transactions';
  }

  String get sYourRealRewardsCard {
    return "Your Real Rewards Card";
  }

  String get sNoTransactionsFound {
    return "No Transactions Found";
  }

  String get sNoVoucherFound {
    return "No Vouchers Found";
  }

  ///edit_profile
  String get sEditProfile {
    return 'Edit Profile';
  }

  String get sPhoneNumber {
    return 'Phone number';
  }

  String get sAddress1 {
    return 'Address1';
  }

  String get sAddress2 {
    return 'Address2';
  }

  String get sPostalCode {
    return 'Postal code';
  }

  String get sCity {
    return 'City';
  }

  String get sSave {
    return 'Save';
  }

  String get sDeleteProfile {
    return 'Delete Profile';
  }

  String get wGallery {
    return "Gallery";
  }

  String get wCamera {
    return "Camera";
  }

  ///pull_to_refresh
  String get wPullUpLoad {
    return "Pull up load";
  }

  String get wLoadFailedClickRetry {
    return "Load Failed!Click retry!";
  }

  String get wNoMoreData {
    return "No more Data";
  }

  ///SaleDetails
  String get sSaleDetails {
    return 'Sale Details';
  }

  String get print {
    return 'Print';
  }

  String get save {
    return 'Save';
  }

  String get receiptNo {
    return 'Receipt No';
  }

  String get cashier {
    return 'Cashier';
  }

  String get counter {
    return 'Counter';
  }

  String get member {
    return 'Member';
  }

  String get salesSummary {
    return 'Sales Summary';
  }

  String get payments {
    return 'Payments';
  }

  String get voucherGenerated {
    return 'Vouchers Generated';
  }

  String get name {
    return 'Name';
  }

  String get previousPoints {
    return 'Previous Points';
  }

  String get thisSalePoints {
    return 'This Sale Points';
  }

  String get accumulatedPoints {
    return 'Accumulated Points';
  }

  String get noDataFound {
    return 'No data found';
  }

  String get promotor {
    return 'Promoter';
  }

  String get totalItems {
    return 'Total items';
  }

  String get totalQuantities {
    return 'Total Quantities';
  }

  String get subTotal {
    return 'Sub Total';
  }

  String get discount {
    return 'Discount';
  }

  String get tax {
    return 'Tax';
  }

  String get roundingAdjustment {
    return 'Rounding Adjustment';
  }

  String get total {
    return 'Total';
  }

  String get totalPaid {
    return 'Total Paid';
  }

  String get changeDue {
    return 'Change Due';
  }

  String get remarks {
    return 'Remarks';
  }

  String get billReferenceNumber {
    return 'Bill Reference Number';
  }
}
