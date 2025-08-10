import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

final class LogPrintInterceptor extends Interceptor {
  final bool request;
  final bool requestHeader;
  final bool requestBody;
  final bool responseBody;
  final bool responseHeader;
  final bool error;
  final void Function(Object object) logPrint;

  const LogPrintInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseBody = true,
    this.responseHeader = true,
    this.error = true,
    this.logPrint = _defaultLogPrint, // Use a default wrapper for log
  });

  static void _defaultLogPrint(Object object) {
    log(object.toString()); // Convert Object to String and pass to log
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (request) {
      logPrint(
        "┌───────────────────────────── Request ─────────────────────────────",
      );
      logPrint("│ URI: ${options.uri}");
      logPrint("│ Method: ${options.method}");
    }

    if (requestHeader) {
      logPrint("│ Headers: ${_prettyPrintJson(options.headers)}");
    }

    if (requestBody && options.data != null) {
      if (options.data is FormData) {
        final FormData formData = options.data as FormData;
        logPrint("│ Form Data Fields:");
        for (final field in formData.fields) {
          logPrint("│   ${field.key}: ${field.value}");
        }

        logPrint("│ Form Data Files:");
        for (final file in formData.files) {
          logPrint("│   ${file.key}: ${file.value.filename}");
        }
      } else if (options.data is Map) {
        logPrint("│ Request Data:");
        logPrint(_prettyPrintJson(options.data));
      }
    }

    logPrint(
      "└───────────────────────────────────────────────────────────────────",
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    logPrint(
      "┌───────────────────────────── Response ─────────────────────────────",
    );
    if (responseHeader) {
      logPrint("│ Status Code: ${response.statusCode}");
      logPrint("│ URI: ${response.requestOptions.uri}");
      logPrint("│ Headers: ${_prettyPrintJson(response.headers.map)}");
    }

    if (responseBody && response.data != null) {
      logPrint("│ Response Data:");
      if (response.data is Map<String, dynamic>) {
        logPrint(_prettyPrintJson(response.data as Map<String, dynamic>));
      } else if (response.data is List) {
        logPrint(_prettyPrintJson({'data': response.data}));
      } else {
        logPrint(response.data.toString());
      }
    }

    logPrint(
      "└────────────────────────────────────────────────────────────────────",
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (error) {
      logPrint(
        "┌───────────────────────────── Error ────────────────────────────────",
      );
      logPrint("│ URI: ${err.requestOptions.uri}");
      logPrint("│ Error Message: ${err.message}");
      logPrint("│ Error Response:");
      logPrint(_prettyPrintJson(err.response?.toString()));
      logPrint("│ Error Data:");
      logPrint(_prettyPrintJson(err.response?.data));

      logPrint(
        "└────────────────────────────────────────────────────────────────────",
      );
    }
    handler.next(err);
  }

  String _prettyPrintJson(Object? object) {
    return const JsonEncoder.withIndent('  ').convert(object);
  }
}
