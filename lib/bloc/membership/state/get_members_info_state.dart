import 'package:cengli/bloc/membership/membership.dart';

import '../../../data/modules/auth/model/user_profile.dart';

class GetMembersInfoLoadingState extends MembershipState {
  const GetMembersInfoLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetMembersInfoErrorState extends MembershipState {
  final String message;

  const GetMembersInfoErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetMembersInfoSuccessState extends MembershipState {
  final List<UserProfile> membersInfo;

  const GetMembersInfoSuccessState(this.membersInfo) : super();

  @override
  List<Object?> get props => [membersInfo];
}
