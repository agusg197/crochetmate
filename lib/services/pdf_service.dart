import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/project.dart';
import '../models/pattern.dart';

class PDFService {
  Future<String> generateProjectPDF(Project project) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(project.name,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Descripción:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(project.description),
            pw.SizedBox(height: 10),
            pw.Text('Detalles:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Gancho: ${project.hookSize ?? "No especificado"}'),
            pw.Text('Hilo: ${project.yarnType ?? "No especificado"}'),
            pw.Text('Estado: ${project.status.displayName}'),
            if (project.deadline != null)
              pw.Text('Fecha límite: ${_formatDate(project.deadline!)}'),
            pw.SizedBox(height: 20),
            pw.Text('Rondas:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.ListView.builder(
              itemCount: project.rounds.length,
              itemBuilder: (context, index) {
                final round = project.rounds[index];
                return pw.Text('Ronda ${round.number}: ${round.instructions}');
              },
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file =
        File('${output.path}/${project.name.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> generatePatternPDF(Pattern pattern) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(pattern.name, style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text(pattern.description),
            pw.SizedBox(height: 20),
            pw.Text('Dificultad: ${pattern.difficulty}'),
            pw.SizedBox(height: 20),
            pw.Text(pattern.instructions),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file =
        File('${output.path}/${pattern.name.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
