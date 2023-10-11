import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/data/modules/transactional/model/participant.dart';
import 'package:cengli/data/modules/transactional/transactional_local_repository.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/error/error_handler.dart';
import 'package:cengli/services/database_service.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';

class TransactionalLocalDataStore extends TransactionalLocalRepository {
  final DatabaseService _databaseService;

  TransactionalLocalDataStore(this._databaseService);

  @override
  Future<void> createExpense(Expense transaction) async {
    final db = await _databaseService.database;

    await db
        .insert(
      CollectionEnum.expenses.name,
      transaction.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    )
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<List<Expense>> getExpenses(String groupId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> transactions = await db.query(
      CollectionEnum.expenses.name,
      where: 'group_id = ?',
      whereArgs: [groupId],
    ).catchError((error) {
      firebaseErrorHandler(error);
    });
    return List.generate(
        transactions.length, (index) => Expense.fromJson(transactions[index]));
  }

  @override
  Future<void> createGroup(Group group, List<String> participants) async {
    try {
      final db = await _databaseService.database;
      final String groupId = const Uuid().v4();
      await db.insert(
        CollectionEnum.groups.name,
        <String, dynamic>{
          'id': groupId,
          'name': group.name,
        },
      );
      await _createParticipants(participants, groupId);
    } catch (error) {
      firebaseErrorHandler(error);
    }
  }

  @override
  Future<List<Group>> getGroups() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(CollectionEnum.groups.name).catchError((error) {
      firebaseErrorHandler(error);
    });

    return List.generate(maps.length, (index) => Group.fromJson(maps[index]));
  }

  @override
  Future<List<Participant>> getParticipants(String groupId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> participants = await db.query(
      CollectionEnum.participants.name,
      where: 'group_id = ?',
      whereArgs: [groupId],
    ).catchError((error) {
      firebaseErrorHandler(error);
    });
    return List.generate(participants.length,
        (index) => Participant.fromJson(participants[index]));
  }

  Future<void> _createParticipants(
      List<String> participants, String groupId) async {
    final db = await _databaseService.database;

    for (var participant in participants) {
      final Participant newParticipant = Participant(
          id: const Uuid().v4(), groupId: groupId, name: participant);
      await db.insert(
          CollectionEnum.participants.name, newParticipant.toJson());
    }
  }
}
