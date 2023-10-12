import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';

class GetChatRequestLoadingState extends MembershipState {
  const GetChatRequestLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetChatRequestErrorState extends MembershipState {
  final String message;

  const GetChatRequestErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetChatRequestEmptyState extends MembershipState {
  final String message;

  const GetChatRequestEmptyState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetChatRequestSuccessState extends MembershipState {
  final List<Feeds> feeds;

  const GetChatRequestSuccessState(this.feeds) : super();

  @override
  List<Object?> get props => [feeds];
}
