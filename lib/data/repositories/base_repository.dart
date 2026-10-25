import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/database.dart';

/// All repositories follow the offline-first pattern:
/// reads go directly to the local Drift DB,
/// writes save locally AND enqueue a SyncQueue entry.
///
/// On web, repositories bypass Drift for reads (using Firestore real-time
/// snapshots) and write directly to Firestore, so [enqueueSync] is a no-op.
abstract class BaseRepository {
  final AppDatabase db;

  const BaseRepository(this.db);

  Future<void> enqueueSync({
    required String collectionName,
    required String documentId,
    required OperationType opType,
    required String payload,
  }) {
    if (kIsWeb) return Future.value();
    return db.enqueue(
      collectionName: collectionName,
      documentId: documentId,
      opType: opType,
      payload: payload,
    );
  }
}
