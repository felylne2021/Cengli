import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/data/modules/transactional/model/participant.dart';
import 'package:cengli/data/modules/transactional/transactional_remote_repository.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/error/error_handler.dart';
import 'package:cengli/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:uuid/uuid.dart';

import 'model/charges.dart';
import 'model/group.dart';

class TransactionalDataStore extends TransactionalRemoteRepository {
  final DatabaseService _databaseService;
  final firestore.FirebaseFirestore _firestoreDb;

  TransactionalDataStore(this._databaseService, this._firestoreDb);

  @override
  Future<void> createExpense(Expense expense, List<Charges> charges) async {
    final String expenseId = const Uuid().v4();
    await _firestoreDb
        .collection(CollectionEnum.expenses.name)
        .doc(expenseId)
        .set(Expense(
                id: expenseId,
                title: expense.title,
                groupId: expense.groupId,
                amount: expense.amount,
                category: expense.category,
                memberPayId: expense.memberPayId,
                tokenUnit: expense.tokenUnit,
                date: expense.date)
            .toJson())
        .catchError((error) {
      firebaseErrorHandler(error);
    });

    List<Map<String, dynamic>> mappedCharges =
        charges.map((charge) => charge.toJson()).toList();

    await _firestoreDb
        .collection(CollectionEnum.expenses.name)
        .doc(expenseId)
        .update({
      "charges": firestore.FieldValue.arrayUnion(mappedCharges)
    }).catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<List<Expense>> getExpenses(String groupId) async {
    final documents = await _firestoreDb
        .collection(CollectionEnum.expenses.name)
        .where("group_id", isEqualTo: groupId)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });
    return documents.docs
        .map((value) => Expense.fromJson(value.data()))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getCharges(String groupId, String userId) async {
    final expenses = await _firestoreDb
        .collection(CollectionEnum.expenses.name)
        .where("group_id", isEqualTo: groupId)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });

    Map<String, dynamic> chargeParent = {"userId": userId, "data": []};

    Map<String, dynamic> chargeDetails = {"payTo": "", "amount": 0};

    for (var expenseDocs in expenses.docs) {
      final Expense expense = Expense.fromJson(expenseDocs.data());

      if (expense.charges != null) {
        for (var charge in expense.charges!) {
          if (charge.userId == userId) {
            chargeDetails["payTo"] = expense.memberPayId ?? "";
            chargeDetails["amount"] += charge.price;
            chargeParent["data"] = chargeDetails;
          }
        }
      }
    }
    return chargeParent;
  }

  @override
  Future<void> createGroup(Group group) async {
    await _firestoreDb
        .collection(CollectionEnum.groups.name)
        .doc(group.id)
        .set(group.toJson())
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<List<Group>> getGroups(String userId) async {
    final documents = await _firestoreDb
        .collection(CollectionEnum.groups.name)
        .where(CollectionEnum.users.name, arrayContains: userId)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });
    return documents.docs.map((value) => Group.fromJson(value.data())).toList();
  }

  @override
  Future<void> joinGroup(String groupId, String userId) async {
    await _firestoreDb
        .collection(CollectionEnum.groups.name)
        .doc(groupId)
        .update({
      CollectionEnum.users.name: firestore.FieldValue.arrayUnion([userId]),
    }).catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<void> migrateData(String userId) async {
    try {
      final groupsFromSQLite = await _fetchGroupsFromLocalData();
      await _migrateGroupsToFirestore(groupsFromSQLite, userId);
      final transactionsFromSQLite = await _fetchExpensesFromLocalData();
      await _migrateExpensesToFirestore(transactionsFromSQLite);
      await _clearLocalData();
    } catch (error) {
      firebaseErrorHandler(error);
    }
  }

  Future<List<Map<String, dynamic>>> _fetchGroupsFromLocalData() async {
    final database = await _databaseService.database;
    return await database.query(CollectionEnum.groups.name);
  }

  Future<void> _migrateGroupsToFirestore(
      List<Map<String, dynamic>> groupsFromSQLite, String userId) async {
    for (final group in groupsFromSQLite) {
      final List<Participant> participants =
          await _fetchParticipants(group['id']);
      final List<String> participantNames =
          participants.map((value) => value.name ?? "").toList();

      final newGroup =
          Group(id: group['id'], name: group['name'], members: [userId]);

      await _firestoreDb
          .collection(CollectionEnum.groups.name)
          .doc(newGroup.id)
          .set(newGroup.toJson());
    }
  }

  Future<List<Map<String, dynamic>>> _fetchExpensesFromLocalData() async {
    final database = await _databaseService.database;
    return await database.query(CollectionEnum.expenses.name);
  }

  Future<List<Participant>> _fetchParticipants(String groupId) async {
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

  Future<void> _migrateExpensesToFirestore(
      List<Map<String, dynamic>> expensesFromSQLite) async {
    for (final transaction in expensesFromSQLite) {
      await _firestoreDb
          .collection(CollectionEnum.expenses.name)
          .doc(transaction['id'])
          .set(transaction);
    }
  }

  Future<void> _clearLocalData() async {
    final database = await _databaseService.database;
    await database.delete(CollectionEnum.groups.name);
    await database.delete(CollectionEnum.expenses.name);
    await database.delete(CollectionEnum.participants.name);
  }
}
