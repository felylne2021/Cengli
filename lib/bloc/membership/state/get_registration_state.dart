import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/membership/model/registration.dart';

class GetRegistrationLoadingState extends MembershipState {
  const GetRegistrationLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetRegistrationErrorState extends MembershipState {
  final String message;

  const GetRegistrationErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetRegistrationSuccessState extends MembershipState {
  final Registration? registration;

  const GetRegistrationSuccessState(this.registration) : super();

  @override
  List<Object?> get props => [registration];
}
