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
