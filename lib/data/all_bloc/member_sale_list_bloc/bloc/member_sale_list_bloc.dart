import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_event.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/bloc/member_sale_list_state.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/member_sale_list_repo.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class MemberSaleListBloc extends Bloc<
    MemberSaleListEvent, MemberSaleListState> {
  final MemberSaleListRepository repository =
      MemberSaleListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  MemberSaleListBloc()
      : super(const MemberSaleListState()) {
    on<MemberSaleListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              MemberSaleListEventStatus.initial) {
            if (state.vouchersList.isNotEmpty) {
              state.vouchersList.clear();
            }
            emit(state.copyWith(
                status: MemberSaleListStatus.loading));
          } else if (event.eventStatus ==
              MemberSaleListEventStatus.refresh) {
            if (state.vouchersList.isNotEmpty) {
              state.vouchersList.clear();
            }
          }else{
          }
          var response = await repository.fetchMemberSaleList(
              event.mMemberSaleListRequest);

          if (response is SalesResponse) {
            if (response.sales != null ) {
              if (response.sales!.isNotEmpty) {
                emit(state.copyWith(
                  mSalesResponse: response,
                    status: MemberSaleListStatus.success,
                    vouchersList: List.of(state.vouchersList)
                      ..addAll(
                        response.sales!,
                      ),
                    hasReachedMax: response.sales!.length==10));
              } else {
                emit(state.copyWith(
                    status: MemberSaleListStatus.success,
                    mSalesResponse: response,
                    vouchersList: state.vouchersList,
                    hasReachedMax: false));
              }
            } else {
              emit(state.copyWith(
                  status: MemberSaleListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: MemberSaleListStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: MemberSaleListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
