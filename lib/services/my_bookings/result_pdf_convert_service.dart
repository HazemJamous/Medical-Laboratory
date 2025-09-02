import 'dart:typed_data';
import 'dart:io' as io;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart'
    show BuildContext, SnackBar, ScaffoldMessenger, Colors, Color;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:open_filex/open_filex.dart';

import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';

class ResultPdfService {
  static PdfColor _toPdfColor(Color c) => PdfColor.fromInt(c.value);

  static String _fmtNum(double? v) {
    if (v == null || v.isNaN) return 'غير متوفر';
    return NumberFormat('#,##0.##', 'en').format(v);
  }

  static String _fmtDate(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('yyyy/MM/dd • HH:mm', 'en').format(dt);
  }

  static String _arabicStatus(String status) {
    switch (status.toLowerCase()) {
      case 'high':
        return 'مرتفع';
      case 'low':
        return 'منخفض';
      case 'normal':
        return 'طبيعي';
      case 'pending':
        return 'معلّق';
      default:
        return status;
    }
  }

  static PdfColor _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'high':
        return PdfColors.red;
      case 'low':
        return PdfColors.orange;
      case 'normal':
        return PdfColors.green;
      case 'pending':
        return PdfColors.blue;
      default:
        return PdfColors.grey700;
    }
  }

  static Future<Uint8List> buildResultsPdf({
    required MyBokingsModel booking,
    required List<ResultsBookingsAppointmentModel> results,
  }) async {
    try {
      await initializeDateFormatting('ar', null);
      await initializeDateFormatting('en', null);
    } catch (_) {}

    final byteData = await rootBundle.load('fonts/Almarai-Regular.ttf');
    final ttf = pw.Font.ttf(byteData);

    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('assets/icon.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      logoImage = null;
    }

    final doc = pw.Document();

    final dateStr = DateFormat('yyyy/MM/dd', 'en').format(booking.dateTime);
    final timeStr = DateFormat('HH:mm', 'en').format(booking.dateTime);

    final PdfColor accentPdf = _toPdfColor(AppColors.accent);
    final PdfColor textPdf = PdfColors.black;

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: ttf),
          buildBackground: (context) {
            if (logoImage != null) {
              // علامة مائية
              return pw.Center(
                child: pw.Opacity(
                  opacity: 0.05,
                  child: pw.Image(logoImage, width: 300, height: 300),
                ),
              );
            }
            return pw.Container();
          },
        ),
        build: (context) {
          final headers = <String>[
            'الاختبار',
            'النتيجة',
            'الوحدة',
            'المجال المرجعي',
            'الحالة',
          ];

          final data = results.map((r) {
            final status = r.computedStatus;
            final refRange = r.range == null
                ? '—'
                : '${_fmtNum(r.range!.min)} – ${_fmtNum(r.range!.max)} ${r.range!.unit ?? ''}';
            return [
              r.analysisName,
              _fmtNum(r.result),
              r.displayUnit.isEmpty ? '—' : r.displayUnit,
              refRange,
              _arabicStatus(status),
            ];
          }).toList();

          final table = pw.Table.fromTextArray(
            headers: headers,
            data: data,
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
            rowDecoration: const pw.BoxDecoration(
              border: pw.TableBorder(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.3),
              ),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1.2),
              2: const pw.FlexColumnWidth(1.0),
              3: const pw.FlexColumnWidth(2.2),
              4: const pw.FlexColumnWidth(1.2),
            },
          );

          final header = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoImage != null)
                pw.Center(child: pw.Image(logoImage, width: 100, height: 100)),
              pw.SizedBox(height: 12),
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
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'المخبر: ${booking.labName}',
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                        pw.Text(
                          'رقم الموعد: ${booking.appointmentId}',
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'التاريخ: $dateStr • $timeStr',
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                        pw.Text(
                          'اسم المريض: ${results.isNotEmpty ? results.first.patientName ?? 'غير متوفر' : 'غير متوفر'}',
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'تاريخ التوليد: ${_fmtDate(DateTime.now())}',
                      style: pw.TextStyle(font: ttf, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          );

          List<pw.Widget> detailsSections = [];
          for (final r in results) {
            final hasAnyExtra =
                (r.method?.isNotEmpty == true) ||
                (r.specimen?.isNotEmpty == true) ||
                (r.device?.isNotEmpty == true) ||
                (r.technician?.isNotEmpty == true) ||
                (r.notes?.isNotEmpty == true) ||
                r.collectedAt != null ||
                r.receivedAt != null ||
                r.reportedAt != null ||
                (r.category?.isNotEmpty == true) ||
                (r.patientGender?.isNotEmpty == true) ||
                r.patientAgeYears != null;

            final statusChip = pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2.5,
              ),
              decoration: pw.BoxDecoration(
                color: _statusColor(r.computedStatus),
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(
                  color: _statusColor(r.computedStatus),
                  width: 0.5,
                ),
              ),
              child: pw.Text(
                _arabicStatus(r.computedStatus),
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 10,
                  color: _statusColor(r.computedStatus),
                ),
              ),
            );

            final refRange = r.range == null
                ? '—'
                : '${_fmtNum(r.range!.min)} – ${_fmtNum(r.range!.max)} ${r.range!.unit ?? ''}';

            final core = pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.grey300, width: 0.6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        r.analysisName,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 13.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      statusChip,
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _kv(ttf, 'القيمة', _fmtNum(r.result)),
                      _kv(
                        ttf,
                        'الوحدة',
                        r.displayUnit.isEmpty ? '—' : r.displayUnit,
                      ),
                      _kv(ttf, 'المجال المرجعي', refRange),
                      if (r.category?.isNotEmpty == true)
                        _kv(ttf, 'الفئة', r.category!),
                      if (r.patientAgeYears != null)
                        _kv(ttf, 'عمر المريض', '${r.patientAgeYears} سنة'),
                      if (r.patientGender?.isNotEmpty == true)
                        _kv(ttf, 'جنس المريض', r.patientGender!),
                    ],
                  ),
                  if (hasAnyExtra) pw.SizedBox(height: 8),
                  if (hasAnyExtra)
                    pw.Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        if (r.method?.isNotEmpty == true)
                          _kv(ttf, 'الطريقة', r.method!),
                        if (r.specimen?.isNotEmpty == true)
                          _kv(ttf, 'نوع العينة', r.specimen!),
                        if (r.device?.isNotEmpty == true)
                          _kv(ttf, 'الجهاز', r.device!),
                        if (r.technician?.isNotEmpty == true)
                          _kv(ttf, 'المسؤول', r.technician!),
                        if (r.collectedAt != null)
                          _kv(ttf, 'وقت الجمع', _fmtDate(r.collectedAt)),
                        if (r.receivedAt != null)
                          _kv(ttf, 'وقت الاستلام', _fmtDate(r.receivedAt)),
                        if (r.reportedAt != null)
                          _kv(ttf, 'وقت الإصدار', _fmtDate(r.reportedAt)),
                      ],
                    ),
                  if (r.notes?.isNotEmpty == true) pw.SizedBox(height: 8),
                  if (r.notes?.isNotEmpty == true)
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Text(
                        r.notes!,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10.5,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                ],
              ),
            );

            detailsSections.add(core);
          }

          return [
            header,
            pw.SizedBox(height: 14),
            table,
            pw.SizedBox(height: 12),
            pw.Text(
              'تفاصيل إضافية لكل اختبار',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
            pw.SizedBox(height: 8),
            ...detailsSections.expand((w) => [w, pw.SizedBox(height: 8)]),
            pw.SizedBox(height: 12),
            pw.Text(
              'هذه النتائج مقدمة برعاية تطبيق MatchLab لمتابعة وتحليل الفحوصات الطبية بشكل آمن وموثوق.',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 11,
                color: PdfColors.grey700,
              ),
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _kv(pw.Font ttf, String k, String v) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: pw.BoxDecoration(
      color: PdfColors.grey100,
      borderRadius: pw.BorderRadius.circular(6),
      border: pw.Border.all(color: PdfColors.grey300, width: 0.4),
    ),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          '$k: ',
          style: pw.TextStyle(
            font: ttf,
            fontSize: 10.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(v, style: pw.TextStyle(font: ttf, fontSize: 10.5)),
      ],
    ),
  );

  static Future<void> saveAndShareResultsPdf({
    required BuildContext context,
    required MyBokingsModel booking,
    required List<ResultsBookingsAppointmentModel> results,
  }) async {
    try {
      final bytes = await buildResultsPdf(booking: booking, results: results);
      final fileName =
          'results_${booking.appointmentId}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await Printing.sharePdf(bytes: bytes, filename: fileName);

      if (!kIsWeb && io.Platform.isAndroid) {
        final downloadsDir = io.Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        final filePath = '${downloadsDir.path}/$fileName';
        final file = io.File(filePath);
        await file.writeAsBytes(bytes);

        try {
          await OpenFilex.open(filePath);
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الملف في مجلد التنزيلات.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إنشاء/مشاركة PDF: $e')),
      );
    }
  }
}
