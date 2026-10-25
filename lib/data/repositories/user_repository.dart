import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository(super.db);

  Future<List<User>> getAllUsers() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((s) => s.docs.map(userFromFirestore).toList());
    }
    return db.select(db.users).get();
  }

  Stream<List<User>> watchAllUsers() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((s) => s.docs.map(userFromFirestore).toList());
    }
    return db.select(db.users).watch();
  }

  Future<User?> getUserById(String id) async {
    if (kIsWeb) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      if (!doc.exists) return null;
      return userFromFirestore(doc);
    }
    return (db.select(db.users)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<User?> watchUserById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .snapshots()
          .map((doc) => doc.exists ? userFromFirestore(doc) : null);
    }
    return (db.select(db.users)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<List<User>> getUsersByParentId(String parentId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('users')
          .where('parentId', isEqualTo: parentId)
          .get()
          .then((s) => s.docs.map(userFromFirestore).toList());
    }
    return (db.select(db.users)..where((t) => t.parentId.equals(parentId)))
        .get();
  }

  Stream<List<User>> watchTeamMembers(String managerId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('users')
          .where('parentId', isEqualTo: managerId)
          .snapshots()
          .map((s) => s.docs.map(userFromFirestore).toList());
    }
    return (db.select(db.users)
          ..where((t) => t.parentId.equals(managerId)))
        .watch();
  }

  Stream<List<User>> watchUsersByRole(String role) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: role)
          .snapshots()
          .map((s) => s.docs.map(userFromFirestore).toList());
    }
    return (db.select(db.users)..where((t) => t.role.equals(role))).watch();
  }

  Future<void> upsertUser(UsersCompanion user) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id.value)
          .set({
        'id': user.id.value,
        'email': user.email.value,
        'name': user.name.value,
        'role': user.role.value,
        'parentId': user.parentId.value,
        'territoryId': user.territoryId.value,
        'isActive': user.isActive.value,
        'phone': user.phone.value,
        'profileImageUrl': user.profileImageUrl.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.users).insertOnConflictUpdate(user);
    await enqueueSync(
      collectionName: 'users',
      documentId: user.id.value,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': user.id.value,
        'email': user.email.value,
        'name': user.name.value,
        'role': user.role.value,
        'parentId': user.parentId.value,
        'territoryId': user.territoryId.value,
        'isActive': user.isActive.value,
        'phone': user.phone.value,
        'profileImageUrl': user.profileImageUrl.value,
      }),
    );
  }

  Future<void> deleteUser(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      return;
    }
    await (db.delete(db.users)..where((t) => t.id.equals(id))).go();
    await enqueueSync(
      collectionName: 'users',
      documentId: id,
      opType: OperationType.delete,
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> insertLocalOnly(UsersCompanion user) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id.value)
          .set({
        'id': user.id.value,
        'email': user.email.value,
        'name': user.name.value,
        'role': user.role.value,
        'parentId': user.parentId.value,
        'territoryId': user.territoryId.value,
        'isActive': user.isActive.value,
        'phone': user.phone.value,
        'profileImageUrl': user.profileImageUrl.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.users).insertOnConflictUpdate(user);
  }
}
