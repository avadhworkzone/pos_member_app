import 'package:equatable/equatable.dart';

enum MemberSalesDetailsEventStatus {
  initial,
  refresh,
  other
}

abstract class MemberSalesDetailsEvent extends Equatable{
  const MemberSalesDetailsEvent();
}

class MemberSalesDetailsClickEvent
    extends MemberSalesDetailsEvent {
  final dynamic mMemberSalesDetailsRequest;
  final MemberSalesDetailsEventStatus eventStatus;
  const MemberSalesDetailsClickEvent({required this.mMemberSalesDetailsRequest,required this.eventStatus });

  @override
  List<Object> get props => [mMemberSalesDetailsRequest];
}
