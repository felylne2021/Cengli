import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:velix/velix.dart';

abstract class TransactionalEvent extends BaseEvent {
  const TransactionalEvent();
}

//Local
class CreateGroupEvent extends TransactionalEvent {
  final Group group;
  final List<String> participants;

  const CreateGroupEvent(this.group, this.participants);

  @override
  List<Object?> get props => [group];
}

class FetchGroupsEvent extends TransactionalEvent {
  const FetchGroupsEvent();

  @override
  List<Object?> get props => [];
}

class CreateExpenseEvent extends TransactionalEvent {
  final Expense expense;

  const CreateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class FetchExpensesEvent extends TransactionalEvent {
  final String groupId;

  const FetchExpensesEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class FetchParticipantsEvent extends TransactionalEvent {
  final String groupId;

  const FetchParticipantsEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

//Remote
class CreateGroupStoreEvent extends TransactionalEvent {
  final Group group;

  const CreateGroupStoreEvent(this.group);

  @override
  List<Object?> get props => [group];
}

class FetchGroupsStoreEvent extends TransactionalEvent {
  final String userId;

  const FetchGroupsStoreEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateExpenseStoreEvent extends TransactionalEvent {
  final Expense expense;

  const CreateExpenseStoreEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class FetchExpensesStoreEvent extends TransactionalEvent {
  final String groupId;

  const FetchExpensesStoreEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class MigrateDataEvent extends TransactionalEvent {
  final String userId;

  const MigrateDataEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class JoinGroupEvent extends TransactionalEvent {
  final String userId;
  final String groupId;

  const JoinGroupEvent(this.userId, this.groupId);

  @override
  List<Object?> get props => [userId, groupId];
}
