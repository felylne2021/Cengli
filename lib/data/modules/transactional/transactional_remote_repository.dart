import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'model/charges.dart';
import 'model/group.dart';

abstract class TransactionalRemoteRepository {
  Future<void> createGroup(Group group);
  Future<void> createExpense(Expense expense, List<Charges> charges);
  Future<List<Expense>> getExpenses(String groupId);
  Future<List<Group>> getGroups(String userId);
  Future<void> joinGroup(String groupId, String userId);
  Future<void> migrateData(String userId);
  Future<List<Map<String, dynamic>>> getCharges(String groupId, String userId);
  List<Map<String, dynamic>> removeDuplicateCharges(
      List<Map<String, dynamic>> charges);
}
