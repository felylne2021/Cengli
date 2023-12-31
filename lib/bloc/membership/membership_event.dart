import 'package:velix/velix.dart';

abstract class MembershipEvent extends BaseEvent {
  const MembershipEvent();
}

class SearchUserEvent extends MembershipEvent {
  final bool isUsername;
  final String value;

  const SearchUserEvent(this.isUsername, this.value);

  @override
  List<Object?> get props => [isUsername, value];
}

class GetGroupEvent extends MembershipEvent {
  final String id;

  const GetGroupEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetMembersEvent extends MembershipEvent {
  final List<String> ids;

  const GetMembersEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}

class GetChatRequestEvent extends MembershipEvent {
  const GetChatRequestEvent();

  @override
  List<Object?> get props => [];
}

class ApproveEvent extends MembershipEvent {
  final String senderAddress;

  const ApproveEvent(this.senderAddress);

  @override
  List<Object?> get props => [senderAddress];
}

class GetGroupOrderEvent extends MembershipEvent {
  final String groupId;

  const GetGroupOrderEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class UpdateUserNameEvent extends MembershipEvent {
  final String fullname;
  final String userName;
  final String userId;

  const UpdateUserNameEvent(this.fullname, this.userName, this.userId);

  @override
  List<Object?> get props => [fullname, userName, userId];
}

class GetListOfGroupsEvent extends MembershipEvent {
  final String userId;

  const GetListOfGroupsEvent(this.userId) : super();

  @override
  List<Object?> get props => [userId];
}

class GetRegistrationEvent extends MembershipEvent {
  final String walletAddress;

  const GetRegistrationEvent(this.walletAddress);

  @override
  List<Object?> get props => [walletAddress];
}

class RequestPartnerEvent extends MembershipEvent {
  final String walletAddress;

  const RequestPartnerEvent(this.walletAddress);

  @override
  List<Object?> get props => [walletAddress];
}
