import 'package:equatable/equatable.dart';

enum MemberSaleListEventStatus {
  initial,
  refresh,
  other
}

abstract class MemberSaleListEvent extends Equatable{
  const MemberSaleListEvent();
}

class MemberSaleListClickEvent
    extends MemberSaleListEvent {
  final dynamic mMemberSaleListRequest;
  final MemberSaleListEventStatus eventStatus;
  const MemberSaleListClickEvent({required this.mMemberSaleListRequest,required this.eventStatus });

  @override
  List<Object> get props => [mMemberSaleListRequest];
}
