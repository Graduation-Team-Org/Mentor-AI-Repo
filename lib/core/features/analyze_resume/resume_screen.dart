import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ResumeScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String linkedin;
  final String github;
  final String summary;
  final String education;
  final String skills;
  final String projects;
  final String languages;
  final String activities;

  const ResumeScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.linkedin,
    required this.github,
    required this.summary,
    required this.education,
    required this.skills,
    required this.projects,
    required this.languages,
    required this.activities,
  });

  Future<void> _generateAndDownloadPdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(name,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(
                children: [
                  pw.Text('Phone: $phone'),
                  pw.SizedBox(width: 15),
                  pw.Text('Email: $email'),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('LinkedIn: $linkedin'),
                  pw.SizedBox(width: 15),
                  pw.Text('GitHub: $github'),
                ],
              ),
              pw.SizedBox(height: 16),
              if (summary.isNotEmpty) ...[
                pw.Text('Summary',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(summary),
                pw.SizedBox(height: 12),
              ],
              if (education.isNotEmpty) ...[
                pw.Text('Education',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(education),
                pw.SizedBox(height: 12),
              ],
              if (skills.isNotEmpty) ...[
                pw.Text('Skills',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(skills),
                pw.SizedBox(height: 12),
              ],
              if (projects.isNotEmpty) ...[
                pw.Text('Projects',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(projects),
                pw.SizedBox(height: 12),
              ],
              if (languages.isNotEmpty) ...[
                pw.Text('Languages',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(languages),
                pw.SizedBox(height: 12),
              ],
              if (activities.isNotEmpty) ...[
                pw.Text('Activities',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(activities),
                pw.SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/resume.pdf');
      await file.writeAsBytes(await pdf.save());

      // Show a confirmation and offer to open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resume saved to ${file.path}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              await OpenFile.open(file.path);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generated Resume')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Phone: $phone'),
                SizedBox(width: 15),
                Text('Email: $email'),
              ],
            ),
            Row(
              children: [
                Text('LinkedIn: $linkedin'),
                SizedBox(width: 15),
                Text('GitHub: $github'),
              ],
            ),
            SizedBox(height: 16),
            if (summary.isNotEmpty) ...[
              Text('Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(summary),
              SizedBox(height: 12),
            ],
            if (education.isNotEmpty) ...[
              Text('Education',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(education),
              SizedBox(height: 12),
            ],
            if (skills.isNotEmpty) ...[
              Text('Skills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(skills),
              SizedBox(height: 12),
            ],
            if (projects.isNotEmpty) ...[
              Text('Projects',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(projects),
              SizedBox(height: 12),
            ],
            if (languages.isNotEmpty) ...[
              Text('Languages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(languages),
              SizedBox(height: 12),
            ],
            if (activities.isNotEmpty) ...[
              Text('Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(activities),
              SizedBox(height: 12),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _generateAndDownloadPdf(context),
        child: Icon(Icons.download),
      ),
    );
  }
}
