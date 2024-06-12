import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_event.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/bloc/member_sales_details_state.dart';
import 'package:member_app/data/all_bloc/member_sale_details_bloc/repo/member_sales_details_repo.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class MemberSalesDetailsBloc extends Bloc<
    MemberSalesDetailsEvent, MemberSalesDetailsState> {
  final MemberSalesDetailsRepository repository =
      MemberSalesDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  MemberSalesDetailsBloc()
      : super(const MemberSalesDetailsState()) {
    on<MemberSalesDetailsClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              MemberSalesDetailsEventStatus.initial) {
            if (state.mSalesList.isNotEmpty) {
              state.mSalesList.clear();
            }
            emit(state.copyWith(
                status: MemberSalesDetailsStatus.loading));
          } else if (event.eventStatus ==
              MemberSalesDetailsEventStatus.refresh) {
            if (state.mSalesList.isNotEmpty) {
              state.mSalesList.clear();
            }
          }else{
          }
          var response = await repository.fetchMemberSalesDetails(
              event.mMemberSalesDetailsRequest);

          if (response is SalesResponse) {
            if (response.sales != null ) {
              if (response.sales!.isNotEmpty) {
                emit(state.copyWith(
                  mSalesResponse: response,
                    status: MemberSalesDetailsStatus.success,
                    mSalesList: List.of(state.mSalesList)
                      ..addAll(
                        response.sales!,
                      ),));
              } else {
                emit(state.copyWith(
                    status: MemberSalesDetailsStatus.success,
                    mSalesResponse: response,
                    mSalesList: state.mSalesList,));
              }
            } else {
              emit(state.copyWith(
                  status: MemberSalesDetailsStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: MemberSalesDetailsStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: MemberSalesDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
