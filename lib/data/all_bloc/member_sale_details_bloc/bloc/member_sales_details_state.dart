import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/member_sale_list_bloc/repo/SalesResponse.dart';
import 'package:member_app/data/remote/web_response_failed.dart';




enum MemberSalesDetailsStatus { loading, success, failed }

class MemberSalesDetailsState extends Equatable {
  const MemberSalesDetailsState(
      {this.status = MemberSalesDetailsStatus.loading,
        this.mSalesList = const <Sales>[],
        this.mSalesResponse,
        this.webResponseFailed,});

  final MemberSalesDetailsStatus status;
  final List<Sales> mSalesList;
  final SalesResponse? mSalesResponse;
  final WebResponseFailed? webResponseFailed;


  MemberSalesDetailsState copyWith({
    MemberSalesDetailsStatus? status,
    List<Sales>? mSalesList,
    SalesResponse? mSalesResponse,
    WebResponseFailed? webResponseFailed,
  }) {
    return MemberSalesDetailsState(
      status: status ?? this.status,
      mSalesList:
      mSalesList ?? this.mSalesList,
      mSalesResponse:
      mSalesResponse ?? this.mSalesResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, SalesResponse: $mSalesList }''';
  }

  @override
  List<Object> get props => [
    status,
    mSalesList,
    mSalesResponse??SalesResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
