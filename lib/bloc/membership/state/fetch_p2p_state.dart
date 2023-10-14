import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';

class FetchP2pLoadingState extends MembershipState {
  const FetchP2pLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchP2pErrorState extends MembershipState {
  final String message;

  const FetchP2pErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchP2pSuccessState extends MembershipState {
  final List<UserProfile> partners;

  const FetchP2pSuccessState(this.partners) : super();

  @override
  List<Object?> get props => [];
}
