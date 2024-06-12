import 'package:member_app/common/app_constants.dart';

class WebConstants {
  /// Standard Comparison Values
  static int statusCode200 = 200;
  static int statusCode400 = 400;
  static int statusCode422 = 422;

  static String statusMessageOK = "OK";
  static String statusMessageBadRequest = "Bad Request";
  static String statusMessageEntityError = "Unprocessable Entity Error";
  static String statusMessageTokenIsExpired = "Token is Expired";

  /// Web response cases
  static String statusCode200Message =
      "{  \"error\" : true,\n  \"statusCode\" : 200,\n  \"statusMessage\" : \"Success Request\",\n  \"data\" : {\"message\":\" Success \"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode401Message =
      "{  \"error\" : true,\n  \"statusCode\" : 401,\n  \"statusMessage\" : \"Unauthenticated\",\n  \"data\" : {\"message\":\"Unauthenticated\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode403Message =
      "{  \"error\" : true,\n  \"statusCode\" : 403,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unauthorized error\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode404Message =
      "{  \"error\" : true,\n  \"statusCode\" : 404,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode412Message =
      "{  \"error\" : true,\n  \"statusCode\" : 412,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode422Message =
      "{  \"error\" : true,\n  \"statusCode\" : 412,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode502Message =
      "{\r\n  \"error\": true,\r\n  \"statusCode\": 502,\r\n  \"statusMessage\": \"Bad Request\",\r\n  \"data\": {\r\n    \"message\": \"Server Error, Please try after sometime\"\r\n  },\r\n  \"responseTime\": 1639548038\r\n}";
  static String statusCode503Message =
      "{  \"error\" : true,\n  \"statusCode\" : 503,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to process your request right now, Please try again later\"},\n  \"responseTime\" : 1639548038\n  }";

  /// Control

  /// Base URL
  static String baseUrlPosQa = "https://posqa.freshbits.in/api/member/";
  static String baseUrlLive = "https://retail.ariani.my/api/member/";
  static String baseUrlDev = "https://arianidevpos.freshbits.in/api/member/";
  static String baseUrlStaging = "https://stagingretail.ariani.my/";
  static String baseURL = AppConstants.isStagingURL?baseUrlStaging:AppConstants.isLiveURLToQa
      ? baseUrlPosQa
      : AppConstants.isLiveURLToUse
          ? baseUrlLive
          : baseUrlDev;

  ///grant_type:password
  static String baseGrantType = "password";

  ///scope:member_scope
  static String baseScope = "member_scope";

  ///client_id
  static String baseClientIdQa = "99b894d8-37eb-48f0-b94e-39cd91c3adf7";
  static String baseClientIdDev = "99ba5fef-4376-4199-97fa-1ede67a4499c";
  static String baseClientIdLive = "99ba6145-083a-4c0c-bba0-9ff22f22bf14";
  static String baseClientIdStaging = "99b66ae8-5199-44b4-862f-47d090ddfbc8";
  static String baseClientId =  AppConstants.isStagingURL?baseClientIdStaging:AppConstants.isLiveURLToQa
      ? baseClientIdQa
      : AppConstants.isLiveURLToUse ? baseClientIdLive : baseClientIdDev;

  ///client_secret
  static String baseClientSecretQa =
      "AWQfSkw5XHieKeOF6PCECSzZNg2HLyAShxUsJYBh";
  static String baseClientSecretDev =
      "EP2rooQuhsFeDOOCcfOcHyJu94zQw5xPJXlom3t1";
  static String baseClientSecretLive =
      "s0emgR0pU5DaNRfmzNVfwt5VafghsQy4IKgmQ8oN";
  static String baseClientSecretStaging =
      "BMK7SZ476W5sdk6baF6GnZSPHnBHJp1PBF6PIUUN";
  static String baseClientSecret =  AppConstants.isStagingURL?baseClientSecretStaging:AppConstants.isLiveURLToQa
      ? baseClientSecretQa
      : AppConstants.isLiveURLToUse ? baseClientSecretLive : baseClientSecretDev;

  /// send otp
  static String actionLoginMobileNumberScreen = "${baseURL}send-otp";

  ///validate-otp
  ///old
  // static String actionLoginMobileNumberOtpScreen = "${baseURL}validate-otp";
  static String actionLoginMobileNumberOtpScreen =
      "${baseURL}validate-otp-with-client";

  ///get-members
  static String actionGetMembers = "${baseURL}get-members";

  ///get-genders
  static String actionGetGenders = "${baseURL}get-genders";

  ///get-races
  static String actionGetRaces = "${baseURL}get-races";

  ///get-titles
  static String actionGetTitles = "${baseURL}get-titles";

  ///get-members-details
  static String actionGetMembersDetails = "${baseURL}member-details";

  ///get-all-members-vouchers
  static String actionMemberVoucherPaginatedList = "${baseURL}member/vouchers";

  ///Transactions-List
  static String actionTransactionsList = "${baseURL}transactions-list";

  ///profile-update
  static String actionProfileUpdate = "${baseURL}profile-update";

  ///upload-profile-photo
  static String actionUploadProfilePic = "${baseURL}upload-profile-photo";

  ///delete-member
  static String actionDeleteMember = "${baseURL}delete-member";

  ///SalesList
  static String actionSalesList = "${baseURL}get-paginated-sales?";

  ///SalesDetails
  static String actionSalesDetails = "${baseURL}get-sale-details/";//get-sale-details/1
}
