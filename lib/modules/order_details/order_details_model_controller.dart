import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/utils/num_utils.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_bloc.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_event.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_state.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailsModelController {
  final BuildContext context;
  final String sSaleId;

  OrderDetailsModelController(this.context, this.sSaleId);

  int onRefresh = 0;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool onLoading = true;
  bool isLoadedAndEmpty = false;
  bool isSearchedAndEmpty = false;

  late MemberSalesDetailsBloc _mMemberSalesDetailsBloc;
  List<Sales> salesList = [];

  setMemberSalesDetailsBloc() {
    _mMemberSalesDetailsBloc = MemberSalesDetailsBloc();
  }

  getMemberSalesDetailsBloc() {
    return _mMemberSalesDetailsBloc;
  }

  onRefreshList() {
    onRefresh = 1;
    salesList.clear();
    initMemberSalesDetails(MemberSalesDetailsEventStatus.refresh);
  }

  Future<void> initMemberSalesDetails(
      MemberSalesDetailsEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mMemberSalesDetailsBloc.add(MemberSalesDetailsClickEvent(
            mMemberSalesDetailsRequest: sSaleId, eventStatus: eventStatus));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  fMemberSalesDetailsBlocListener(
      BuildContext context, MemberSalesDetailsState state) {
    switch (state.status) {
      case MemberSalesDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case MemberSalesDetailsStatus.failed:
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
      case MemberSalesDetailsStatus.success:
        loadEnd();
        setSaleList(state.mSalesResponse ?? SalesResponse());
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

  double totalItem(Sales mSales) {
    double totalItem = 0.0;
    if (mSales.saleItems != null && (mSales.saleItems ?? []).isNotEmpty) {
      for (SaleItems saleItemsDetails in (mSales.saleItems ?? [])) {
        totalItem = totalItem + (saleItemsDetails.quantity ?? 0);
      }
    }
    return totalItem;
  }

  String getTotalQuantities(Sales sale) {
    double totalQuantities = 0;
    if (sale.saleItems != null) {
      sale.saleItems?.forEach((element) {
        totalQuantities = totalQuantities + (element.quantity ?? 0);
      });
    }
    return getStringWithNoDecimal(totalQuantities);
  }
}
