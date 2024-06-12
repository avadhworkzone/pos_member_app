import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/remote/web_response_failed.dart';




enum MemberSaleListStatus { loading, success, failed }

class MemberSaleListState extends Equatable {
  const MemberSaleListState(
      {this.status = MemberSaleListStatus.loading,
        this.vouchersList = const <Sales>[],
        this.mSalesResponse,
        this.webResponseFailed,
      this.hasReachedMax= false});

  final MemberSaleListStatus status;
  final List<Sales> vouchersList;
  final SalesResponse? mSalesResponse;
  final WebResponseFailed? webResponseFailed;
  final bool hasReachedMax;


  MemberSaleListState copyWith({
    MemberSaleListStatus? status,
    List<Sales>? vouchersList,
    SalesResponse? mSalesResponse,
    WebResponseFailed? webResponseFailed,
    bool? hasReachedMax
  }) {
    return MemberSaleListState(
      status: status ?? this.status,
      vouchersList:
      vouchersList ?? this.vouchersList,
      mSalesResponse:
      mSalesResponse ?? this.mSalesResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, MemberSaleListResponse: $vouchersList }''';
  }

  @override
  List<Object> get props => [
    status,
    vouchersList,
    mSalesResponse??SalesResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
