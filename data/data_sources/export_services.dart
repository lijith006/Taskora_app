import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../domain/entities/item_entity.dart';

class ExportService {
  Future<String> exportPDF(List<ItemEntity> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Table.fromTextArray(
          headers: ['ID', 'Title', 'Status', 'Date'],
          data: items.map((e) {
            return [
              e.id,
              e.title,
              e.status,
              DateFormat.yMMMd().format(e.createdDate),
            ];
          }).toList(),
        ),
      ),
    );

    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/report.pdf");
    await file.writeAsBytes(bytes);

    //  share PDF immediately-quick
    await Printing.sharePdf(bytes: bytes, filename: 'report.pdf');

    return file.path;
  }

  Future<String> exportCSV(List<ItemEntity> items) async {
    final data = [
      ['ID', 'Title', 'Status', 'Date'],
      ...items.map(
        (e) => [
          e.id,
          e.title,
          e.status,
          DateFormat.yMMMd().format(e.createdDate),
        ],
      ),
    ];

    final csvData = const ListToCsvConverter().convert(data);
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/report.csv");
    await file.writeAsString(csvData);

    return file.path;
  }

  Future<String> exportExcel(List<ItemEntity> items) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Report'];

    sheet.appendRow(['ID', 'Title', 'Status', 'Date']);
    for (var e in items) {
      sheet.appendRow([
        e.id,
        e.title,
        e.status,
        DateFormat.yMMMd().format(e.createdDate),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/report.xlsx");
    await file.writeAsBytes(excel.encode()!);

    return file.path;
  }
}
