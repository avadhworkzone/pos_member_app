import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/print/test_printing.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_bloc.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_event.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_state.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/member_sale_list_request.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class OrderListModelController {
  final BuildContext context;
  final HomeScreenModel mHomeScreenModel;

  OrderListModelController(this.context, this.mHomeScreenModel);

  ///
  int onRefresh = 0;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool onLoading = true;
  bool isLoadedAndEmpty = false;
  bool isSearchedAndEmpty = false;
  int page = 1;
  int lastPage = 20;
  late MemberSaleListBloc _mMemberSaleListBloc;
  List<Sales> salesList = [];
  setMemberSaleListBloc() {
    _mMemberSaleListBloc = MemberSaleListBloc();
  }

  getMemberSaleListBloc() {
    return _mMemberSaleListBloc;
  }

  void onRefreshList() async {
    onRefresh = 1;
    page = 1;
    salesList.clear();
    initMemberSaleList(
        MemberSaleListEventStatus.refresh);
  }

  void onLoadingList() async {
    onRefresh = 2;
    page = page + 1;
    initMemberSaleList(
        MemberSaleListEventStatus.other);
  }
  
  Future<void> initMemberSaleList(MemberSaleListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mMemberSaleListBloc.add(MemberSaleListClickEvent(
            mMemberSaleListRequest: MemberSaleListRequest(
                    page: page.toString(),
                    perPage: "10",
                    sortBy: "id",
                    sortDirection: "desc")
                .toJson(),
            eventStatus: eventStatus));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  fMemberSaleListBlocListener(
      BuildContext context, MemberSaleListState state) {
    switch (state.status) {
      case MemberSaleListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case MemberSaleListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case MemberSaleListStatus.success:
        loadEnd();
        setSaleList(state.mSalesResponse??SalesResponse());
        break;
    }
  }

  void loadEnd() {
    if (onRefresh == 0) {
      AppAlert.closeDialog(context);
    } else if (onRefresh == 1) {
      refreshController.refreshCompleted();
      onLoading = true;
    } else if (onRefresh == 2) {
      refreshController.loadComplete();
    }
  }


  var responseSubject = PublishSubject<SalesResponse>();

  Stream<SalesResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setSaleList(SalesResponse request) async {
    try {
      responseSubject.sink.add(request);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

  printReceipt(Sales mSales) async {
    // printPdf();
  }

  double totalItem(Sales mSales)  {
    double totalItem =0.0;
    if(mSales.saleItems!=null && (mSales.saleItems??[]).isNotEmpty){
      for(SaleItems saleItemsDetails in (mSales.saleItems??[])){
        totalItem = totalItem + (saleItemsDetails.quantity??0);
      }
    }
    return totalItem;
  }
}
