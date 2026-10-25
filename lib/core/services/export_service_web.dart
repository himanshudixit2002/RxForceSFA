// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

import 'package:csv/csv.dart';

import 'export_service_stub.dart' as stub;

stub.ExportService createExportService() => WebExportService();

class WebExportService implements stub.ExportService {
  @override
  Future<void> exportCsv({
    required String fileName,
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) async {
    final csvData = const ListToCsvConverter().convert([headers, ...rows]);
    _downloadFile('$fileName.csv', csvData, 'text/csv');
  }

  @override
  Future<void> exportText({
    required String fileName,
    required String content,
  }) async {
    _downloadFile('$fileName.txt', content, 'text/plain');
  }

  void _downloadFile(String name, String data, String mimeType) {
    final bytes = utf8.encode(data);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', name)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
