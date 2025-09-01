// lib/services/pdf/result_pdf_service.dart
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart'
    show BuildContext, Color, SnackBar, ScaffoldMessenger;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';

class ResultPdfService {
  /// تحويل Flutter Color إلى PdfColor
  static PdfColor _toPdfColor(Color c) => PdfColor.fromInt(c.value);

  /// بناء PDF لكل نتائج الموعد
  static Future<Uint8List> buildResultsPdf({
    required MyBokingsModel booking,
    required List<ResultsBookingsAppointmentModel> results,
  }) async {
    // تهيئة بيانات locale للتواريخ
    try {
      await initializeDateFormatting('ar', null);
      await initializeDateFormatting('en', null);
    } catch (_) {}

    // تحميل خط Almarai
    final byteData = await rootBundle.load('fonts/Almarai-Regular.ttf');
    final ttf = pw.Font.ttf(byteData);

    final doc = pw.Document();

    final dateStr = DateFormat('yyyy/MM/dd', 'en').format(booking.dateTime);
    final timeStr = DateFormat('HH:mm', 'en').format(booking.dateTime);

    String fmtNum(double? v) {
      if (v == null || v.isNaN) return 'غير متوفر';
      return NumberFormat('#,##0.##', 'en').format(v);
    }

    final tableData = results
        .map((r) => [r.analysisName, fmtNum(r.result)])
        .toList();

    final PdfColor accentPdf = _toPdfColor(AppColors.accent);
    final PdfColor textPdf = PdfColors.black;

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: ttf),
        ),
        build: (context) => <pw.Widget>[
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(8),
              color: PdfColors.grey200,
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'نتائج الفحص',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: textPdf,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'المخبر: ${booking.labName}',
                  style: pw.TextStyle(font: ttf, fontSize: 12),
                ),
                pw.Text(
                  'تاريخ الموعد: $dateStr  •  $timeStr',
                  style: pw.TextStyle(font: ttf, fontSize: 12),
                ),
                pw.Text(
                  'رقم الموعد: ${booking.appointmentId}',
                  style: pw.TextStyle(font: ttf, fontSize: 12),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 14),

          // جدول النتائج
          pw.Table.fromTextArray(
            headers: <String>['الاختبار', 'القيمة'],
            data: tableData.map((row) => [row[0], row[1]]).toList(),
            headerStyle: pw.TextStyle(
              font: ttf,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(color: accentPdf),
            cellStyle: pw.TextStyle(font: ttf, fontSize: 11, color: textPdf),
            cellAlignment: pw.Alignment.centerRight,
            headerAlignment: pw.Alignment.centerRight,
            cellPadding: const pw.EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 6,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3), // الاختبار (أوسع)
              1: const pw.FlexColumnWidth(1), // القيمة (أضيق)
            },
          ),

          pw.SizedBox(height: 18),

          pw.Text(
            'ملاحظة: للحصول على تفسير النتائج، راجع القيم المرجعية لدى المختبر أو استشر طبيبك.',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 11,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  /// بناء الملف وحفظه ومشاركته
  static Future<void> saveAndShareResultsPdf({
    required BuildContext context,
    required MyBokingsModel booking,
    required List<ResultsBookingsAppointmentModel> results,
  }) async {
    try {
      final bytes = await buildResultsPdf(booking: booking, results: results);
      final fileName =
          'results_${booking.appointmentId}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // مشاركة
      await Printing.sharePdf(bytes: bytes, filename: fileName);

      if (!kIsWeb) {
        String path;
        // حفظ داخل Downloads
        final downloadsDir = io.Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          path = '${downloadsDir.path}/$fileName';
        } else {
          // fallback لو ما في Downloads
          final docsDir = await getApplicationDocumentsDirectory();
          path = '${docsDir.path}/$fileName';
        }

        final file = io.File(path);
        await file.writeAsBytes(bytes);

        try {
          await OpenFilex.open(path);
        } catch (_) {}

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حفظ الملف في: $path')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إنشاء/مشاركة PDF: $e')),
      );
    }
  }
}
