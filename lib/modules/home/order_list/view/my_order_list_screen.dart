import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/widget/no_transactions_found.dart';
import 'package:member_app/common/widget/pull_to_refresh_header_widget.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_bloc.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_event.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_state.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';
import 'package:member_app/modules/home/order_list/order_list_model_controller.dart';
import 'package:member_app/modules/home/order_list/view/my_order_list_item_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyOrderListScreenWidget extends StatefulWidget {
  final HomeScreenModel mHomeScreenModel;

  const MyOrderListScreenWidget({super.key, required this.mHomeScreenModel});

  @override
  State<MyOrderListScreenWidget> createState() =>
      _MyOrderListScreenWidgetState();
}

class _MyOrderListScreenWidgetState extends State<MyOrderListScreenWidget> {
  late OrderListModelController mOrderListModelController;

  @override
  void initState() {
    super.initState();
    mOrderListModelController =
        OrderListModelController(context, widget.mHomeScreenModel);
    mOrderListModelController.setMemberSaleListBloc();
    mOrderListModelController
        .initMemberSaleList(MemberSaleListEventStatus.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildMyOrderListScreenWidgetView());
  }

  _buildMyOrderListScreenWidgetView() {
    return FocusDetector(
        onVisibilityGained: () {},
        child: SafeArea(
          child: MultiBlocListener(listeners: [
            BlocListener<MemberSaleListBloc, MemberSaleListState>(
              bloc: mOrderListModelController.getMemberSaleListBloc(),
              listener: (context, state) {
                mOrderListModelController.fMemberSaleListBlocListener(
                    context, state);
              },
            ),
          ], child: apiWidget()),
        ));
  }

  Widget apiWidget() {
    return StreamBuilder<SalesResponse>(
      stream: mOrderListModelController.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.sales != null) {
            mOrderListModelController.lastPage = responseData.lastPage ?? 1;
            mOrderListModelController.salesList
                .addAll(responseData.sales ?? []);
            return showSalesList();
          }
        }
        return showSalesList();
      },
    );
  }

  showSalesList() {
    return Container(
      margin: EdgeInsets.only(top: SizeConstants.s1*5),
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(top: SizeConstants.s_10, bottom: SizeConstants.s_18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConstants.s1 * 20),
          topRight: Radius.circular(SizeConstants.s1 * 20),
        ),
      ),
      child: Scrollbar(
          thumbVisibility: true,
          thickness: SizeConstants.s2,
          radius: Radius.circular(20),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: SmartRefresher(
            controller: mOrderListModelController.refreshController,
            onLoading: mOrderListModelController.onLoadingList,
            onRefresh: mOrderListModelController.onRefreshList,
            enablePullUp: mOrderListModelController.lastPage !=
                mOrderListModelController.page,
            enablePullDown: true,
            footer: CustomFooter(builder: (context, loadStatus) {
              return customFooter(loadStatus);
            }),
            header: waterDropHeader(),
            child: mOrderListModelController.salesList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: mOrderListModelController.salesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MyOrderListItemView(
                        index: index,
                          mSales: mOrderListModelController.salesList[index],
                          mOrderListModelController:mOrderListModelController
                      );
                    })
                : Center(
                    child: noTransactionsFound(),
                  ),
          )),
    );
  }
}
