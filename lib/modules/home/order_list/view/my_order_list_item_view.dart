import 'package:flutter/material.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_response.dart';
import 'package:member_app/modules/home/order_list/order_list_model_controller.dart';
import 'package:member_app/routes/route_constants.dart';

class MyOrderListItemView extends StatefulWidget {
  final int index;
  final Sales mSales;
  final OrderListModelController mOrderListModelController;

  const MyOrderListItemView(
      {super.key,
      required this.index,
      required this.mSales,
      required this.mOrderListModelController});

  @override
  State<MyOrderListItemView> createState() => _MyOrderListItemViewState();
}

class _MyOrderListItemViewState extends State<MyOrderListItemView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMyOrderListItemViewView();
  }

  _buildMyOrderListItemViewView() {
    return GestureDetector(
      onTap: () {
        print("#####${widget.mSales.id.toString()}");
         Navigator.pushNamed(context,
            RouteConstants.rMyOrderDetailsScreenWidget,
            arguments: widget.mSales.id.toString());
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: SizeConstants.s_14),
        padding: EdgeInsets.only(
          left: SizeConstants.s_14,
          right: SizeConstants.s_14,
          top: SizeConstants.s_6,
        ),
        width: SizeConstants.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.mSales.company?.name??"",
                style: getTextMedium(
                    colors: ColorConstants.kPrimaryColor, size: SizeConstants.s_16)),
            SizedBox(height: SizeConstants.s1*5,),
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Text("ID: ",
                            style: getTextRegular(
                                colors: Colors.black, size: SizeConstants.s_16)),
                        Text(widget.mSales.id.toString(),
                            style: getTextMedium(
                                colors: Colors.grey, size: SizeConstants.s_16)),
                      ],
                    )),
                Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Text("Total Item: ",
                            style: getTextRegular(
                                colors: Colors.black, size: SizeConstants.s_16)),
                        Text(
                            widget.mOrderListModelController
                                .totalItem(widget.mSales).toString(),
                            style: getTextMedium(
                                colors: Colors.grey, size: SizeConstants.s_16)),
                      ],
                    ))
              ],
            ),
            SizedBox(height: SizeConstants.s1*5,),
            Row(
              children: [
                Expanded(
                  flex: 5,
                    child: Row(
                      children: [
                        Text("Counter : ",
                            style: getTextRegular(
                                colors: Colors.black, size: SizeConstants.s_16)),
                        Text(widget.mSales.counter?.name??"",
                            style: getTextMedium(
                                colors: Colors.grey, size: SizeConstants.s_16)),
                      ],
                    )),
                Expanded(
                  flex: 6,
                    child: Row(
                      children: [
                        Text("Total Pay: ",
                            style: getTextRegular(
                                colors: Colors.black, size: SizeConstants.s_16)),
                        Text(
                            "RM ${(widget.mSales.totalAmountPaid??0.0)}",
                            style: getTextMedium(
                                colors:  ColorConstants.kPrimaryColor, size: SizeConstants.s_16)),
                      ],
                    ))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConstants.s_15),
              width: SizeConstants.width,
              height: SizeConstants.s_05,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
