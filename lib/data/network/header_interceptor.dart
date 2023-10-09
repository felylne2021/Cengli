import 'dart:convert';

import 'package:cengli/values/values.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class HeaderInterceptor extends Interceptor {
  final Logger _logger;

  HeaderInterceptor(this._logger);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.contentType = Headers.jsonContentType;

    if (options.baseUrl.contains("cometh")) {
      options.headers["apikey"] = Constant.commethApiKey;
    }

    _logger.d("--> ${options.method} ${options.baseUrl}${options.path}\n" +
        "Query: ${options.queryParameters}\n" +
        "Content type: ${options.contentType}\n" +
        "Headers: ${options.headers}\n" +
        "Request Body: ${options.data}\n" +
        "<-- END HTTP");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    _logger.i(
        '--> Response Code: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}\n' +
            'Query: ${response.requestOptions.queryParameters}\n' +
            'Headers: ${response.headers}' +
            'Response Body: ${json.encode(response.data)}\n' +
            '<-- END HTTP');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _logger.e('<-- Error -->\n' +
        'Status: ${err.error}\n' +
        'Response: ${err.response}\n' +
        '<-- End Error -->');

    super.onError(err, handler);
  }
}
