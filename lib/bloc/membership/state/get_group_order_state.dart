import 'package:cengli/bloc/membership/membership.dart';

import '../../../data/modules/transactional/model/group.dart';

class GetGroupOrderLoadingState extends MembershipState {
  const GetGroupOrderLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetGroupOrderErrorState extends MembershipState {
  final String message;

  const GetGroupOrderErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetGroupOrderSuccessState extends MembershipState {
  final Group group;

  const GetGroupOrderSuccessState(this.group) : super();

  @override
  List<Object?> get props => [group];
}
