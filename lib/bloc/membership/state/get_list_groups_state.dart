import 'package:cengli/bloc/membership/membership_state.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';

class GetListOfGroupsLoadingState extends MembershipState {
  @override
  List<Object?> get props => [];
}

class GetListOfGroupIdSuccessState extends MembershipState {
  final List<Group> groups;

  const GetListOfGroupIdSuccessState(this.groups) : super();
  @override
  List<Object?> get props => [groups];
}

class GetListOfGroupsErrorState extends MembershipState {
  final String message;

  const GetListOfGroupsErrorState(this.message) : super();
  @override
  List<Object?> get props => [message];
}
