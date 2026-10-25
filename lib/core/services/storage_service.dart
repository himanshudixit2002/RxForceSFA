import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads a receipt image for the given user and expense.
  /// Returns the download URL on success.
  Future<String> uploadReceiptImage({
    required String userId,
    required String expenseId,
    required String localPath,
    Uint8List? bytes,
  }) async {
    final ext = p.extension(localPath).isNotEmpty
        ? p.extension(localPath)
        : '.jpg';
    final ref = _storage.ref('receipts/$userId/$expenseId$ext');

    UploadTask task;
    if (kIsWeb) {
      if (bytes != null) {
        task = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        throw UnsupportedError(
          'On web, bytes must be provided for upload',
        );
      }
    } else {
      final file = File(localPath);
      if (!await file.exists()) {
        throw FileSystemException('Receipt file not found', localPath);
      }
      final mime = ext.replaceAll('.', '') == 'jpg' ? 'jpeg' : ext.replaceAll('.', '');
      task = ref.putFile(file, SettableMetadata(contentType: 'image/$mime'));
    }

    final snapshot = await task;
    return snapshot.ref.getDownloadURL();
  }

  /// Deletes a receipt image from storage.
  Future<void> deleteReceiptImage({
    required String userId,
    required String expenseId,
    String extension = '.jpg',
  }) async {
    try {
      final ref = _storage.ref('receipts/$userId/$expenseId$extension');
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  /// Gets the download URL for an existing receipt.
  Future<String?> getReceiptUrl({
    required String userId,
    required String expenseId,
    String extension = '.jpg',
  }) async {
    try {
      final ref = _storage.ref('receipts/$userId/$expenseId$extension');
      return await ref.getDownloadURL();
    } on FirebaseException {
      return null;
    }
  }

  /// Checks if a path looks like a Firebase Storage download URL.
  static bool isDownloadUrl(String? path) {
    if (path == null || path.isEmpty) return false;
    return path.startsWith('https://firebasestorage.googleapis.com') ||
        path.startsWith('https://storage.googleapis.com') ||
        path.contains('firebasestorage.app');
  }
}
