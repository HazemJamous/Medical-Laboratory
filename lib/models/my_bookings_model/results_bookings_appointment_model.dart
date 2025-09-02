// To parse this JSON data, do
//
//   final resultsBookingsAppointmentModel = resultsBookingsAppointmentModelFromMap(jsonString);

import 'dart:convert';

ResultsBookingsAppointmentModel resultsBookingsAppointmentModelFromMap(String str) =>
    ResultsBookingsAppointmentModel.fromMap(json.decode(str));

String resultsBookingsAppointmentModelToMap(ResultsBookingsAppointmentModel data) =>
    json.encode(data.toMap());

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

DateTime? _toDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

class ResultsBookingsAppointmentModel {
  // أساسية
  final String patientName;
  final int analysisId;
  final String analysisName;

  // القيم
  final double? result;
  final String? unit; // وحدة القياس للنتيجة نفسها (إن وُجدت)
  final Range? range;

  // حالة ومعلومات إضافية
  final String? status; // normal/high/low/pending/...
  final String? method; // طريقة القياس (ELISA, PCR, …)
  final String? specimen; // نوع العينة (Serum, Plasma, …)
  final String? device; // اسم الجهاز
  final String? technician; // اسم الفني/المُراجع
  final String? category; // فئة الاختبار إن وُجدت
  final String? notes; // ملاحظات

  // بيانات المريض (اختيارية لو رجعت من الباك)
  final int? patientAgeYears;
  final String? patientGender; // M/F/Other

  // أزمنة
  final DateTime? collectedAt;
  final DateTime? receivedAt;
  final DateTime? reportedAt;

  const ResultsBookingsAppointmentModel({
    required this.patientName,
    required this.analysisId,
    required this.analysisName,
    this.result,
    this.unit,
    this.range,
    this.status,
    this.method,
    this.specimen,
    this.device,
    this.technician,
    this.category,
    this.notes,
    this.patientAgeYears,
    this.patientGender,
    this.collectedAt,
    this.receivedAt,
    this.reportedAt,
  });

  ResultsBookingsAppointmentModel copyWith({
    String? patientName,
    int? analysisId,
    String? analysisName,
    double? result,
    String? unit,
    Range? range,
    String? status,
    String? method,
    String? specimen,
    String? device,
    String? technician,
    String? category,
    String? notes,
    int? patientAgeYears,
    String? patientGender,
    DateTime? collectedAt,
    DateTime? receivedAt,
    DateTime? reportedAt,
  }) =>
      ResultsBookingsAppointmentModel(
        patientName: patientName ?? this.patientName,
        analysisId: analysisId ?? this.analysisId,
        analysisName: analysisName ?? this.analysisName,
        result: result ?? this.result,
        unit: unit ?? this.unit,
        range: range ?? this.range,
        status: status ?? this.status,
        method: method ?? this.method,
        specimen: specimen ?? this.specimen,
        device: device ?? this.device,
        technician: technician ?? this.technician,
        category: category ?? this.category,
        notes: notes ?? this.notes,
        patientAgeYears: patientAgeYears ?? this.patientAgeYears,
        patientGender: patientGender ?? this.patientGender,
        collectedAt: collectedAt ?? this.collectedAt,
        receivedAt: receivedAt ?? this.receivedAt,
        reportedAt: reportedAt ?? this.reportedAt,
      );

  factory ResultsBookingsAppointmentModel.fromMap(Map<String, dynamic> json) {
    Range? parsedRange;
    final r = json['range'];
    if (r is Map<String, dynamic>) {
      parsedRange = Range.fromMap(r);
    }

    return ResultsBookingsAppointmentModel(
      patientName: (json['patient_name'] ?? '').toString(),
      analysisId: json['analysis_id'] is String
          ? int.tryParse(json['analysis_id']) ?? 0
          : (json['analysis_id'] ?? 0) as int,
      analysisName: (json['analysis_name'] ?? '').toString(),
      result: _toDouble(json['result']),
      unit: json['unit']?.toString(),
      range: parsedRange,
      status: json['status']?.toString(),
      method: json['method']?.toString(),
      specimen: json['specimen']?.toString(),
      device: json['device']?.toString(),
      technician: json['technician']?.toString(),
      category: json['category']?.toString(),
      notes: json['notes']?.toString(),
      patientAgeYears: json['patient_age_years'] is String
          ? int.tryParse(json['patient_age_years'])
          : json['patient_age_years'] as int?,
      patientGender: json['patient_gender']?.toString(),
      collectedAt: _toDateTime(json['collected_at']),
      receivedAt: _toDateTime(json['received_at']),
      reportedAt: _toDateTime(json['reported_at']),
    );
  }

  Map<String, dynamic> toMap() => {
        'patient_name': patientName,
        'analysis_id': analysisId,
        'analysis_name': analysisName,
        'result': result,
        'unit': unit,
        'range': range?.toMap(),
        'status': status,
        'method': method,
        'specimen': specimen,
        'device': device,
        'technician': technician,
        'category': category,
        'notes': notes,
        'patient_age_years': patientAgeYears,
        'patient_gender': patientGender,
        'collected_at': collectedAt?.toIso8601String(),
        'received_at': receivedAt?.toIso8601String(),
        'reported_at': reportedAt?.toIso8601String(),
      };

  // وحدات مفيدة للعرض
  String get displayUnit => unit ?? range?.unit ?? '';

  bool get hasValue => result != null && !(result!.isNaN);

  /// إن لم تأتِ حالة من الباك، نحسبها من المجال المرجعي إن توفر
  String get computedStatus {
    if (status != null && status!.trim().isNotEmpty) return status!;
    if (!hasValue || range == null || range!.min == null || range!.max == null) {
      return 'pending';
    }
    final v = result!;
    final lo = range!.min!;
    final hi = range!.max!;
    if (v < lo) return 'low';
    if (v > hi) return 'high';
    return 'normal';
  }
}

class Range {
  final double? min;
  final double? max;
  final String? unit;

  const Range({this.min, this.max, this.unit});

  Range copyWith({double? min, double? max, String? unit}) =>
      Range(min: min ?? this.min, max: max ?? this.max, unit: unit ?? this.unit);

  factory Range.fromMap(Map<String, dynamic> json) => Range(
        min: _toDouble(json['min']),
        max: _toDouble(json['max']),
        unit: json['unit']?.toString(),
      );

  Map<String, dynamic> toMap() => {
        'min': min,
        'max': max,
        'unit': unit,
      };
}
