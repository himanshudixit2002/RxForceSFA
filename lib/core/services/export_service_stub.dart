ExportService createExportService() => throw UnsupportedError('No implementation');

abstract class ExportService {
  Future<void> exportCsv({
    required String fileName,
    required List<String> headers,
    required List<List<dynamic>> rows,
  });

  Future<void> exportText({
    required String fileName,
    required String content,
  });
}
