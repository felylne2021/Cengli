import 'package:cengli/data/transactional/model/participant.dart';

import 'model/group.dart';
import 'model/expense.dart';

abstract class TransactionalLocalRepository {
  Future<void> createGroup(Group group, List<String> participants);
  Future<void> createExpense(Expense transaction);
  Future<List<Expense>> getExpenses(String groupId);
  Future<List<Group>> getGroups();
  Future<List<Participant>> getParticipants(String groupId);
}
