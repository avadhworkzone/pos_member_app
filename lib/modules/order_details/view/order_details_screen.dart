import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/widget/no_transactions_found.dart';
import 'package:member_app/common/widget/pull_to_refresh_header_widget.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_bloc.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_event.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_state.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/modules/order_details/order_details_model_controller.dart';
import 'package:member_app/modules/order_details/view/printing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../common/color_constants.dart';
import '../../../common/text_styles_constants.dart';

class MyOrderDetailsScreenWidget extends StatefulWidget {
  final String sSaleId;

  const MyOrderDetailsScreenWidget({super.key, required this.sSaleId});

  @override
  State<MyOrderDetailsScreenWidget> createState() =>
      _MyOrderDetailsScreenWidgetState();
}

class _MyOrderDetailsScreenWidgetState
    extends State<MyOrderDetailsScreenWidget> {
  late OrderDetailsModelController mOrderDetailsModelController;

  @override
  void initState() {
    super.initState();
    mOrderDetailsModelController =
        OrderDetailsModelController(context, widget.sSaleId);
    mOrderDetailsModelController.setMemberSalesDetailsBloc();
    mOrderDetailsModelController
        .initMemberSalesDetails(MemberSalesDetailsEventStatus.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBar(
            (value) {}, AppConstants.mWordConstants.sSaleDetails),
        body: _buildMyOrderDetailsScreenWidgetView());
  }

  _buildMyOrderDetailsScreenWidgetView() {
    return FocusDetector(
        onVisibilityGained: () {},
        child: SafeArea(
          child: MultiBlocListener(listeners: [
            BlocListener<MemberSalesDetailsBloc, MemberSalesDetailsState>(
              bloc: mOrderDetailsModelController.getMemberSalesDetailsBloc(),
              listener: (context, state) {
                mOrderDetailsModelController.fMemberSalesDetailsBlocListener(
                    context, state);
              },
            ),
          ], child: apiWidget()),
        ));
  }

  Widget apiWidget() {
    return StreamBuilder<SalesResponse>(
      stream: mOrderDetailsModelController.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var responseData = snapshot.data;
          if (responseData != null && responseData.sales != null) {
            mOrderDetailsModelController.salesList
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
      margin: EdgeInsets.only(top: SizeConstants.s1 * 5),
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
            controller: mOrderDetailsModelController.refreshController,
            //onLoading: mOrderDetailsModelController.onLoadingList,
            onRefresh: mOrderDetailsModelController.onRefreshList,
            enablePullUp: false,
            enablePullDown: true,
            footer: CustomFooter(builder: (context, loadStatus) {
              return customFooter(loadStatus);
            }),
            header: waterDropHeader(),
            child: mOrderDetailsModelController.salesList.isNotEmpty
                ? showView(mOrderDetailsModelController.salesList.first)
                : Center(
                    child: noTransactionsFound(),
                  ),
          )),
    );
  }

  showView(Sales mSales) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ///print
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrinSaleDetailScreen(
                          saleList: mOrderDetailsModelController.salesList,
                          qty: mOrderDetailsModelController.getTotalQuantities(
                              mOrderDetailsModelController.salesList.first)),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.save,
                    color: ColorConstants.kPrimaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(AppConstants.mWordConstants.save,
                      style: getTextMedium(
                          colors: Colors.black,
                          size: SizeConstants.width * 0.045)),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),

            ///receipt no
            commonDataField(
                title: AppConstants.mWordConstants.receiptNo,
                value: mOrderDetailsModelController
                        .salesList.first.offlineSaleId ??
                    "NA"),

            ///cashier and counter
            Row(
              children: [
                Expanded(
                    child: commonDataField(
                        title: AppConstants.mWordConstants.cashier,
                        value: mOrderDetailsModelController
                                    .salesList.first.cashierDetails ==
                                null
                            ? ''
                            : mOrderDetailsModelController.salesList.first
                                    .cashierDetails!.firstName ??
                                "NA")),
                const SizedBox(width: 7),
                Expanded(
                    child: commonDataField(
                        title: AppConstants.mWordConstants.counter,
                        value: mOrderDetailsModelController
                                    .salesList.first.counterDetails ==
                                null
                            ? ""
                            : mOrderDetailsModelController
                                    .salesList.first.counterDetails!.name ??
                                "NA")),
              ],
            ),

            /// member
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: SizeConstants.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          offset: const Offset(0, 5),
                          color: Colors.grey.withOpacity(0.3))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                      title: Text(AppConstants.mWordConstants.member,
                          style: getTextBold(
                              colors: Colors.black,
                              size: SizeConstants.width * 0.05)),
                      children: [
                        Column(
                          children: [
                            memberRowCommonData(
                                title: AppConstants.mWordConstants.name,
                                value: mOrderDetailsModelController
                                            .salesList.first.userDetails ==
                                        null
                                    ? "0"
                                    : mOrderDetailsModelController.salesList
                                            .first.userDetails!.firstName ??
                                        "NA"),
                            memberRowCommonData(
                                title:
                                    AppConstants.mWordConstants.previousPoints,
                                value: mOrderDetailsModelController
                                            .salesList.first.userDetails ==
                                        null
                                    ? "0"
                                    : mOrderDetailsModelController.salesList
                                            .first.userDetails!.previousPoints!
                                            .toInt()
                                            .toString() ??
                                        "0"),
                            memberRowCommonData(
                                title:
                                    AppConstants.mWordConstants.thisSalePoints,
                                value: mOrderDetailsModelController
                                            .salesList.first.userDetails ==
                                        null
                                    ? "0"
                                    : '${mOrderDetailsModelController.salesList.first.userDetails!.currentSalePoints!.toInt() ?? "0"}'),
                            memberRowCommonData(
                                title: AppConstants
                                    .mWordConstants.accumulatedPoints,
                                value: mOrderDetailsModelController
                                            .salesList.first.userDetails ==
                                        null
                                    ? "0"
                                    : mOrderDetailsModelController
                                            .salesList
                                            .first
                                            .userDetails!
                                            .accumulatedPoints!
                                            .toInt()
                                            .toString() ??
                                        "0"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ///Sales Summary
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: SizeConstants.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          offset: Offset(0, 5),
                          color: Colors.grey.withOpacity(0.3))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      onExpansionChanged: (val) {
                        // qtyCount() {
                        //   num qty = 0;
                        //   addToCartLocalData['data']!.forEach((element) {
                        //     if ((element['menu'] as List).isNotEmpty) {
                        //       element['menu'].forEach((element) {
                        //         qty += element['qty'];
                        //       });
                        //     }
                        //   });
                        //   return qty;
                        // }
                      },
                      tilePadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Text(AppConstants.mWordConstants.salesSummary,
                          style: getTextBold(
                              colors: Colors.black,
                              size: SizeConstants.width * 0.05)),
                      children: [
                        mOrderDetailsModelController
                                .salesList.first.saleItems!.isEmpty
                            ? Center(
                                child: Text(
                                    AppConstants.mWordConstants.noDataFound))
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: mOrderDetailsModelController
                                          .salesList.first.saleItems!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${index + 1}.${mOrderDetailsModelController.salesList.first.saleItems![index].product!.name ?? "NA"}',
                                                    style: getTextRegular(
                                                        colors: Colors.grey
                                                            .withOpacity(0.5),
                                                        size: SizeConstants
                                                                .width *
                                                            0.035)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: Text(
                                                      '${AppConstants.mWordConstants.promotor} ${mOrderDetailsModelController.salesList.first.saleItems![index].promoters!.length ?? '0'}',
                                                      style: getTextRegular(
                                                          colors: Colors.grey
                                                              .withOpacity(0.5),
                                                          size: SizeConstants
                                                                  .width *
                                                              0.035),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                mOrderDetailsModelController
                                                            .salesList
                                                            .first
                                                            .saleItems![index]
                                                            .product!
                                                            .color ==
                                                        null
                                                    ? SizedBox()
                                                    : Text(
                                                        '${mOrderDetailsModelController.salesList.first.saleItems![index].product!.color!.name ?? 'NA'}',
                                                        style: getTextRegular(
                                                            colors: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            size: SizeConstants
                                                                    .width *
                                                                0.035),
                                                      ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                mOrderDetailsModelController
                                                            .salesList
                                                            .first
                                                            .saleItems![index]
                                                            .product!
                                                            .size ==
                                                        null
                                                    ? SizedBox()
                                                    : Text(
                                                        '${mOrderDetailsModelController.salesList.first.saleItems![index].product!.size!.name ?? 'NA'}',
                                                        style: getTextRegular(
                                                            colors: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            size: SizeConstants
                                                                    .width *
                                                                0.035),
                                                      ),
                                              ],
                                            ),
                                            Text(
                                              'X ${mOrderDetailsModelController.salesList.first.saleItems![index].quantity}',
                                              style: getTextRegular(
                                                  colors: Colors.grey
                                                      .withOpacity(0.5),
                                                  size: SizeConstants.width *
                                                      0.035),
                                            ),
                                            Text(
                                              'RM ${mOrderDetailsModelController.salesList.first.saleItems![index].totalPricePaid ?? 0}',
                                              style: getTextRegular(
                                                  colors: Colors.grey
                                                      .withOpacity(0.5),
                                                  size: SizeConstants.width *
                                                      0.035),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.3),
                                    thickness: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: memberRowCommonData(
                                        title: AppConstants
                                            .mWordConstants.totalItems,
                                        value: mOrderDetailsModelController
                                            .salesList.first.saleItems!.length
                                            .toString()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: memberRowCommonData(
                                        title: AppConstants
                                            .mWordConstants.totalQuantities,
                                        value: mOrderDetailsModelController
                                            .getTotalQuantities(
                                                mOrderDetailsModelController
                                                    .salesList.first)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// payments
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: SizeConstants.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          offset: Offset(0, 5),
                          color: Colors.grey.withOpacity(0.3))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Text(AppConstants.mWordConstants.payments,
                          style: getTextBold(
                              colors: Colors.black,
                              size: SizeConstants.width * 0.05)),
                      children: [
                        mOrderDetailsModelController
                                .salesList.first.payments!.isEmpty
                            ? Center(
                                child: Text(
                                    AppConstants.mWordConstants.noDataFound))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mOrderDetailsModelController
                                    .salesList.first.payments!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${index + 1}. ${mOrderDetailsModelController.salesList.first.payments![index].paymentType!.name ?? 'NA'}',
                                                  style: getTextRegular(
                                                      colors: Colors.grey
                                                          .withOpacity(0.5),
                                                      size:
                                                          SizeConstants.width *
                                                              0.045)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'at ${mOrderDetailsModelController.salesList.first.payments![index].happenedAt}',
                                                  style: getTextRegular(
                                                      colors: Colors.grey
                                                          .withOpacity(0.5),
                                                      size:
                                                          SizeConstants.width *
                                                              0.045)),
                                            ],
                                          ),
                                          Text(
                                              'RM ${mOrderDetailsModelController.salesList.first.payments![index].amount ?? 0}',
                                              style: getTextRegular(
                                                  colors: Colors.grey
                                                      .withOpacity(0.5),
                                                  size: SizeConstants.width *
                                                      0.045)),
                                        ],
                                      ),
                                      index ==
                                              mOrderDetailsModelController
                                                      .salesList
                                                      .first
                                                      .payments!
                                                      .length -
                                                  1
                                          ? SizedBox()
                                          : Divider(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              thickness: 1,
                                            ),
                                    ],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// voucher generated
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: SizeConstants.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          offset: Offset(0, 5),
                          color: Colors.grey.withOpacity(0.3))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(AppConstants.mWordConstants.voucherGenerated,
                          style: getTextBold(
                              colors: Colors.black,
                              size: SizeConstants.width * 0.05)),
                      children: [
                        mOrderDetailsModelController
                                .salesList.first.vouchers!.isEmpty
                            ? Center(
                                child: Text(
                                    AppConstants.mWordConstants.noDataFound))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mOrderDetailsModelController
                                    .salesList.first.vouchers!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${index + 1}) ${mOrderDetailsModelController.salesList.first.vouchers![index].discountType ?? 'NA'}',
                                          style: getTextRegular(
                                              colors:
                                                  Colors.grey.withOpacity(0.5),
                                              size:
                                                  SizeConstants.width * 0.045)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      memberRowCommonData(
                                          title: 'Number',
                                          value: mOrderDetailsModelController
                                              .salesList
                                              .first
                                              .vouchers![index]
                                              .number),
                                      memberRowCommonData(
                                          title: 'Expiry',
                                          value: mOrderDetailsModelController
                                              .salesList
                                              .first
                                              .vouchers![index]
                                              .expiryDate),
                                      index ==
                                              mOrderDetailsModelController
                                                      .salesList
                                                      .first
                                                      .vouchers!
                                                      .length -
                                                  1
                                          ? SizedBox()
                                          : Divider(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              thickness: 1,
                                            ),
                                    ],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ///other details
            Column(
              children: [
                otherRowCommonData(
                    title: AppConstants.mWordConstants.subTotal,
                    value: mOrderDetailsModelController
                            .salesList.first.totalAmountPaid
                            .toString() ??
                        '0'),
                otherRowCommonData(
                    title: AppConstants.mWordConstants.discount,
                    value: mOrderDetailsModelController
                            .salesList.first.totalDiscountAmount
                            .toString() ??
                        '0'),
                otherRowCommonData(
                    title: AppConstants.mWordConstants.tax,
                    value: mOrderDetailsModelController
                            .salesList.first.totalTaxAmount
                            .toString() ??
                        '0'),
                otherRowCommonData(
                    title: AppConstants.mWordConstants.roundingAdjustment,
                    value: mOrderDetailsModelController
                            .salesList.first.saleRoundOffAmount
                            .toString() ??
                        '0'),
                otherRowCommonData(
                    title: AppConstants.mWordConstants.total,
                    value: mOrderDetailsModelController
                            .salesList.first.totalAmountPaid
                            .toString() ??
                        '0'),
                otherRowCommonData(
                    title: AppConstants.mWordConstants.totalPaid,
                    value: mOrderDetailsModelController
                            .salesList.first.totalAmountPaid
                            .toString() ??
                        '0'),
                otherRowCommonData(
                    title: AppConstants.mWordConstants.changeDue,
                    value: mOrderDetailsModelController
                            .salesList.first.changeDue
                            .toString() ??
                        '0'),
              ],
            ),

            ///remarks
            commonDataField(
                title: AppConstants.mWordConstants.remarks, value: "NA"),

            ///bill reference Number
            commonDataField(
                title: AppConstants.mWordConstants.billReferenceNumber,
                value: mOrderDetailsModelController
                        .salesList.first.billReferenceNumber ??
                    "NA"),
          ],
        ),
      ),
    );
  }

  Row memberRowCommonData({String? title, String? value}) {
    return Row(
      children: [
        Text(title!,
            style: getTextRegular(
                colors: Colors.grey.withOpacity(0.5),
                size: SizeConstants.width * 0.045)),
        SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(value!,
                style: getTextRegular(
                    colors: Colors.grey.withOpacity(0.5),
                    size: SizeConstants.width * 0.045)),
          ),
        ),
      ],
    );
  }

  Widget otherRowCommonData({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(title!,
              style: getTextRegular(
                  colors: Colors.black, size: SizeConstants.width * 0.045)),
          SizedBox(width: 10),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('RM ' + value!,
                  style: getTextBold(
                      colors: Colors.black, size: SizeConstants.width * 0.045)),
            ),
          ),
        ],
      ),
    );
  }

  Padding commonDataField({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: SizeConstants.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  color: Colors.grey.withOpacity(0.3))
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!,
                  style: getTextBold(
                      colors: Colors.black, size: SizeConstants.width * 0.05)),
              const SizedBox(
                height: 20,
              ),
              Text(value!,
                  style: getTextRegular(
                      colors: Colors.grey.withOpacity(0.5),
                      size: SizeConstants.width * 0.045)),
            ],
          ),
        ),
      ),
    );
  }
}
