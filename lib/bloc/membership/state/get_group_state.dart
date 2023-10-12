import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';

class GetGroupLoadingState extends MembershipState {
  const GetGroupLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetGroupErrorState extends MembershipState {
  final String message;

  const GetGroupErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetGroupSuccessState extends MembershipState {
  final Group group;
  final GroupDTO groupDto;

  const GetGroupSuccessState(this.group, this.groupDto) : super();

  @override
  List<Object?> get props => [group, groupDto];
}
