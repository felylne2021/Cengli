import 'package:cengli/data/transactional/model/expense.dart';
import 'model/group.dart';

abstract class TransactionalRemoteRepository {
  Future<void> createGroup(Group group);
  Future<void> createExpense(Expense expense);
  Future<List<Expense>> getExpenses(String groupId);
  Future<List<Group>> getGroups(String userId);
  Future<void> joinGroup(String groupId, String userId);
  Future<void> migrateData(String userId);
}
