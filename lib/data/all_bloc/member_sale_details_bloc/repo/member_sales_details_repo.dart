import 'dart:convert';

import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class MemberSalesDetailsRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  MemberSalesDetailsRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchMemberSalesDetails(
      dynamic mMemberSalesDetailsRequest) async {
    print("fetchMemberSalesDetails");
    final response = await webservice.getWithAuthAndStringRequest(
        WebConstants.actionSalesDetails,
        mMemberSalesDetailsRequest);

    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        SalesResponse dashboardResponse =
        SalesResponse.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      }else{
        WebResponseFailed dashboardResponse = WebResponseFailed ();
        returnResponse = dashboardResponse;
      }
    } catch (e) {
      WebResponseFailed dashboardResponse = WebResponseFailed ();
      returnResponse = dashboardResponse;
    }

    return returnResponse;
  }
}
