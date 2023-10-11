import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';

class SearchUserLoadingState extends MembershipState {
  const SearchUserLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class SearchUserErrorState extends MembershipState {
  final String message;

  const SearchUserErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class SearchUserSuccessState extends MembershipState {
  final UserProfile user;
  const SearchUserSuccessState(this.user) : super();

  @override
  List<Object?> get props => [user];
}
