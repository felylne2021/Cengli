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
