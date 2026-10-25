import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'export_service_stub.dart' as stub;

stub.ExportService createExportService() => MobileExportService();

class MobileExportService implements stub.ExportService {
  @override
  Future<void> exportCsv({
    required String fileName,
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) async {
    final csvData = const ListToCsvConverter().convert([headers, ...rows]);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.csv');
    await file.writeAsString(csvData);
    await Share.shareXFiles([XFile(file.path)], text: fileName);
  }

  @override
  Future<void> exportText({
    required String fileName,
    required String content,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.txt');
    await file.writeAsString(content);
    await Share.shareXFiles([XFile(file.path)], text: fileName);
  }
}
