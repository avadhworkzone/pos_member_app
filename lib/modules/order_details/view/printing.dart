// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../common/app_constants.dart';
import '../../../data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_bloc.dart';
import '../../../data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_state.dart';
import '../../../data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import '../order_details_model_controller.dart';

class PrinSaleDetailScreen extends StatefulWidget {
  const PrinSaleDetailScreen(
      {Key? key, required this.saleList, required this.qty})
      : super(key: key);
  final List<Sales> saleList;
  final String qty;

  @override
  State<PrinSaleDetailScreen> createState() => _PrinSaleDetailScreenState();
}

class _PrinSaleDetailScreenState extends State<PrinSaleDetailScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   mOrderDetailsModelController =
  //       OrderDetailsModelController(context, widget.sSaleId);
  //   mOrderDetailsModelController.setMemberSalesDetailsBloc();
  //   mOrderDetailsModelController
  //       .initMemberSalesDetails(MemberSalesDetailsEventStatus.initial);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sale Details')),
      body: PdfPreview(
        useActions: true,
        shouldRepaint: false,
        canDebug: false,
        initialPageFormat: PdfPageFormat.undefined,
        dpi: 70,
        build: (format) => _generatePdf(format),
      ),
    );
  }

  // pdgWidget() {
  //   return FocusDetector(
  //       onVisibilityGained: () {},
  //       child: SafeArea(
  //         child: MultiBlocListener(listeners: [
  //           BlocListener<MemberSalesDetailsBloc, MemberSalesDetailsState>(
  //             bloc: mOrderDetailsModelController.getMemberSalesDetailsBloc(),
  //             listener: (context, state) {
  //               mOrderDetailsModelController.fMemberSalesDetailsBlocListener(
  //                   context, state);
  //             },
  //           ),
  //         ], child: apiWidget()),
  //       ));
  // }

  // Widget apiWidget() {
  //   return StreamBuilder<SalesResponse>(
  //     stream: mOrderDetailsModelController.responseSubject,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.active) {
  //         var responseData = snapshot.data;
  //         if (responseData != null && responseData.sales != null) {
  //           mOrderDetailsModelController.salesList
  //               .addAll(responseData.sales ?? []);
  //           return PdfPreview(
  //             initialPageFormat: PdfPageFormat.undefined,
  //             dpi: 70,
  //             build: (format) => _generatePdf(format),
  //           );
  //         }
  //       }
  //       return const SizedBox();
  //     },
  //   );
  // }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
      deflate: zlib.encode,
    );

    // final inputDate =
    //     "${mOrderDetailsModelController.salesList.first.happenedAt}";
    // final formattedDate = formatDateTime(inputDate);
    // final font = await PdfGoogleFonts.nunitoMedium();

    pdf.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat(
        //     MediaQuery.of(context).size.height * PdfPageFormat.inch,
        //     MediaQuery.of(context).size.height * PdfPageFormat.inch),
        // pageFormat: format,
        // PdfPageFormat.standard
        //     .copyWith(marginBottom: 0.5 * PdfPageFormat.cm),
        build: (context) {
          return [
            pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // pw.Align(
                    // alignment: pw.Alignment.center,

                    // pw.Text('',
                    //     textAlign: pw.TextAlign.center,
                    //     style: pw.TextStyle(
                    //         font: font, fontSize: 18, color: PdfColors.black)),

                    commonTextWidget(
                        title: widget.saleList.first.company == null
                            ? ''
                            : widget.saleList.first.company!.name ?? ""),
                    // commonTextWidget(title: '--'),
                    // commonTextWidget(title: 'KUALA LUMPUR - 85000'),
                    // commonTextWidget(title: 'TEL: 8852124521'),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        mainAxisSize: pw.MainAxisSize.max,
                        children: [
                          commonTextWidget(title: 'Counter'),
                          commonTextWidget(
                              title: widget.saleList.first.counter == null
                                  ? ''
                                  : widget.saleList.first.counter!.name ?? "")
                        ]),
                    pw.SizedBox(height: 10),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        mainAxisSize: pw.MainAxisSize.max,
                        children: [
                          commonTextWidget(title: 'Cashier'),
                          commonTextWidget(
                              title:
                                  widget.saleList.first.cashierDetails == null
                                      ? ''
                                      : widget.saleList.first.cashierDetails!
                                              .firstName ??
                                          "")
                        ]),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    commonTextWidget(title: widget.saleList.first.status ?? ""),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    // commonTextWidget(
                    //     title: widget.saleList.first.status == "" ||
                    //             widget.saleList.first.status == null
                    //         ? ""
                    //         : widget.saleList.first.status!.toUpperCase()),
                    // commonTextWidget(
                    //     title:
                    //         '------------------------------------------------------------------',
                    //     color: PdfColors.grey,
                    //     fontSize: 21),
                    // commonTextWidget(title: 'Duplicate Copy'),
                    // commonTextWidget(
                    //     title:
                    //         '------------------------------------------------------------------',
                    //     color: PdfColors.grey,
                    //     fontSize: 21),
                    commonTextWidget(
                        title:
                            'Date : ${formatDateTime(widget.saleList.first.happenedAt ?? "")}'),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    commonTextWidget(
                        title:
                            'Invoice : ${widget.saleList.first.offlineSaleId ?? "NA"}'),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          commonTextWidget(
                              title: 'Item', fontWeights: pw.FontWeight.bold),
                          commonTextWidget(
                              title: 'Qty', fontWeights: pw.FontWeight.bold),
                          commonTextWidget(
                              title: 'Price', fontWeights: pw.FontWeight.bold),
                          commonTextWidget(
                              title: 'Discount',
                              fontWeights: pw.FontWeight.bold),
                          commonTextWidget(
                              title: 'Total', fontWeights: pw.FontWeight.bold),
                        ]),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),

                    // pw.Expanded(
                    //   child:

                    widget.saleList.first.saleItems == [] ||
                            widget.saleList.first.saleItems!.isEmpty ||
                            widget.saleList.first.saleItems == null
                        ? pw.SizedBox()
                        : pw.ListView.builder(
                            itemBuilder: (context, index) {
                              return widget.saleList.first.saleItems![index]
                                          .product ==
                                      null
                                  ? pw.SizedBox()
                                  : pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Column(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            commonTextWidget(
                                                title:
                                                    '${index + 1}.${widget.saleList.first.saleItems![index].product!.name ?? "NA"}'),
                                            pw.SizedBox(height: 8),
                                            commonTextWidget(
                                                title: widget
                                                        .saleList
                                                        .first
                                                        .saleItems![index]
                                                        .product!
                                                        .upc ??
                                                    ""),
                                            pw.SizedBox(height: 8),
                                            commonTextWidget(
                                                title:
                                                    '${widget.saleList.first.saleItems![index].quantity ?? ""} × ${widget.saleList.first.saleItems![index].product == null || widget.saleList.first.saleItems![index].product!.size == null ? '' : widget.saleList.first.saleItems![index].product!.size!.name ?? ""}-${widget.saleList.first.saleItems![index].product == null || widget.saleList.first.saleItems![index].product!.color == null ? '' : widget.saleList.first.saleItems![index].product!.color!.name ?? ""}'),
                                            // pw.SizedBox(height: 8),
                                            // commonTextWidget(title: 'DISCOUNT :  %'),
                                            pw.SizedBox(height: 8),
                                            pw.Row(
                                                mainAxisAlignment: pw
                                                    .MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  pw.SizedBox(),
                                                  commonTextWidget(
                                                      title:
                                                          '× ${widget.saleList.first.saleItems![index].quantity ?? ""}'),
                                                  commonTextWidget(
                                                      title:
                                                          '${widget.saleList.first.saleItems![index].originalPricePerUnit?.toStringAsFixed(2) ?? ""}'),
                                                  commonTextWidget(
                                                      title:
                                                          '-${widget.saleList.first.saleItems![index].itemDiscountAmount?.toStringAsFixed(2) ?? ""}'),
                                                  commonTextWidget(
                                                      title:
                                                          '${widget.saleList.first.saleItems![index].pricePaidPerUnit?.toStringAsFixed(2) ?? ""}'),
                                                ])
                                          ]));
                            },
                            itemCount: widget.saleList.first.saleItems!.length),
                    // ),
                    commonTextWidget(
                        title:
                            '------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    memberRowCommonData(
                        title: AppConstants.mWordConstants.totalItems,
                        value: widget.saleList.first.saleItems == [] ||
                                widget.saleList.first.saleItems == null ||
                                widget.saleList.first.saleItems!.isEmpty
                            ? '0'
                            : widget.saleList.first.saleItems!.length
                                .toString()),
                    memberRowCommonData(
                        title: AppConstants.mWordConstants.totalQuantities,
                        value: widget.qty == '' ? '0' : widget.qty),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    memberRowCommonData(
                        title:
                            AppConstants.mWordConstants.subTotal.toUpperCase(),
                        value:
                            '${widget.saleList.first.totalAmountPaid?.toStringAsFixed(2) ?? '0'}',
                        fontWeights: pw.FontWeight.bold),
                    memberRowCommonData(
                        title:
                            AppConstants.mWordConstants.discount.toUpperCase(),
                        value:
                            '${widget.saleList.first.totalDiscountAmount?.toStringAsFixed(2) ?? '0'}',
                        fontWeights: pw.FontWeight.bold),
                    memberRowCommonData(
                        title: AppConstants.mWordConstants.roundingAdjustment,
                        value:
                            '${widget.saleList.first.saleRoundOffAmount?.toStringAsFixed(2) ?? ""}',
                        fontWeights: pw.FontWeight.bold),
                    memberRowCommonData(
                        title: AppConstants.mWordConstants.total,
                        value:
                            '${widget.saleList.first.totalAmountPaid?.toStringAsFixed(2) ?? ""}',
                        fontWeights: pw.FontWeight.bold),
                    memberRowCommonData(
                        title: AppConstants.mWordConstants.totalPaid,
                        value: widget.saleList.first.totalAmountPaid
                                ?.toStringAsFixed(2) ??
                            "",
                        fontWeights: pw.FontWeight.bold),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),

                    widget.saleList.first.payments == null ||
                            widget.saleList.first.payments == [] ||
                            widget.saleList.first.payments!.isEmpty
                        ? pw.SizedBox()
                        : pw.ListView.builder(
                            itemCount: widget.saleList.first.payments!.length,
                            itemBuilder: (context, index) {
                              return pw.Column(
                                children: [
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          commonTextWidget(
                                              title: widget
                                                          .saleList
                                                          .first
                                                          .payments![index]
                                                          .paymentType ==
                                                      null
                                                  ? ''
                                                  : widget
                                                          .saleList
                                                          .first
                                                          .payments![index]
                                                          .paymentType!
                                                          .name ??
                                                      'NA'),
                                          pw.SizedBox(
                                            height: 5,
                                          ),
                                          commonTextWidget(
                                              title:
                                                  'at ${widget.saleList.first.payments![index].happenedAt}'),
                                        ],
                                      ),
                                      commonTextWidget(
                                          title:
                                              '${widget.saleList.first.payments![index].amount?.toStringAsFixed(2) ?? 0}'),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    commonTextWidget(title: 'Member'),
                    pw.SizedBox(height: 6),
                    memberRowCommonData(
                      title: 'Name',
                      value: widget.saleList.first.userDetails == null
                          ? ''
                          : widget.saleList.first.userDetails!.firstName ?? "",
                    ),
                    pw.SizedBox(height: 6),
                    memberRowCommonData(
                      title: 'Previous Points',
                      value: widget.saleList.first.userDetails == null
                          ? ''
                          : '${widget.saleList.first.userDetails!.previousPoints?.toInt() ?? '0'}',
                    ),
                    pw.SizedBox(height: 6),
                    memberRowCommonData(
                      title: 'This Sale Points',
                      value: widget.saleList.first.userDetails == null
                          ? ''
                          : '${widget.saleList.first.userDetails!.currentSalePoints?.toInt() ?? '0'}',
                    ),
                    pw.SizedBox(height: 6),
                    memberRowCommonData(
                      title: 'Accumulated Points',
                      value: widget.saleList.first.userDetails == null
                          ? ''
                          : '${widget.saleList.first.userDetails!.accumulatedPoints?.toInt() ?? '0'}',
                    ),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    memberRowCommonData(
                      title: 'Remarks',
                      value: '--',
                    ),
                    pw.SizedBox(height: 6),
                    memberRowCommonData(
                      title: 'Bill Ref No',
                      value: widget.saleList.first.billReferenceNumber ?? '',
                    ),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: commonTextWidget(
                            title: widget.saleList.first.userDetails == null
                                ? ''
                                : '1. ${widget.saleList.first.userDetails!.firstName ?? ""}')),

                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    commonTextWidget(title: 'THANK YOU & PLEASE COME AGAIN.'),
                    commonTextWidget(title: 'TEST'),
                    commonTextWidget(title: 'HAVE A NICE DAY'),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    commonTextWidget(
                        title: 'Printed on : ${formatCurrentDate()}'),
                    commonTextWidget(
                        title:
                            '--------------------------------------------------------------------',
                        color: PdfColors.grey,
                        fontSize: 21),
                    // commonTextWidget(
                    //     title: '--------Pos Version : 1.51.0--------'),
                    // commonTextWidget(
                    //     title:
                    //         '--------------------------------------------------------------------',
                    //     color: PdfColors.grey,
                    //     fontSize: 21),

                    ///
                    // commonTextWidget(
                    //     title:
                    //         '------------------------------------------------------------------',
                    //     color: PdfColors.grey,
                    //     fontSize: 21),

                    // )
                    // pw.SizedBox(
                    //   width: double.infinity,
                    //   child: pw.FittedBox(
                    //     child: pw.Text(title, style: pw.TextStyle(font: font)),
                    //   ),
                    // ),
                    // pw.SizedBox(height: 20),
                  ],
                ))
          ];
        },
      ),
    );
    return pdf.save();
  }

  var fonts;

  font() async {
    fonts = await PdfGoogleFonts.nunitoBlack();
  }

  commonTextWidget(
      {required String title,
      double? fontSize,
      PdfColor? color,
      pw.FontWeight? fontWeights}) {
    return pw.Text(title,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
            font: fonts,
            fontSize: fontSize ?? 18,
            color: color ?? PdfColors.black,
            fontWeight: fontWeights));
  }

  memberRowCommonData(
      {String? title, String? value, pw.FontWeight? fontWeights}) {
    return pw.Row(
      children: [
        commonTextWidget(title: title!, fontWeights: fontWeights),
        // Text(title!,
        //     style: getTextRegular(
        //         colors: Colors.grey.withOpacity(0.5),
        //         size: SizeConstants.width * 0.045)),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: commonTextWidget(title: value!, fontWeights: fontWeights),
          ),
        ),
      ],
    );
  }

  String formatDateTime(String dateTimeString) {
    final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    final outputFormat = DateFormat("E, d MMM, y, hh:mm a");
    final dateTime = inputFormat.parse(dateTimeString);
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }

  String formatCurrentDate() {
    final now = DateTime.now();
    final outputFormat = DateFormat("EEE, dd MMM, yyyy");
    final formattedDate = outputFormat.format(now);

    return formattedDate.toUpperCase(); // To make it uppercase as in "TUE"
  }
}
