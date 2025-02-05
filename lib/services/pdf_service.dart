import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/pattern.dart';

class PdfService {
  Future<String> exportPatternToPdf(Pattern pattern) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(pattern.name,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Paragraph(text: pattern.description),
          pw.Header(level: 1, child: pw.Text('Dificultad')),
          pw.Paragraph(text: pattern.difficulty),
          pw.Header(level: 1, child: pw.Text('Instrucciones')),
          pw.Paragraph(text: pattern.content),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pattern_${pattern.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
