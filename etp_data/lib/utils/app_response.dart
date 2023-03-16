import 'package:conduit/conduit.dart';
import 'package:etp_data/models/response_model.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppResponse extends Response {
  AppResponse.serverError(dynamic error, {String? message})
      : super.serverError(body: _getResponseModel(error, message));

  static ResponseAppModel _getResponseModel(error, String? message) {
    if (error is QueryException) {
      return ResponseAppModel(
          error: error.toString(), message: message ?? error.message);
    }

    if (error is JwtException) {
      return ResponseAppModel(
          error: error.toString(), message: message ?? error.message);
    }

    return ResponseAppModel(
        error: error.toString(), message: message ?? "Неизвестная ошибка");
  }

  AppResponse.ok({dynamic body, String? message})
      : super.ok(ResponseAppModel(data: body, message: message));

  AppResponse.badRequest({String? message})
      : super.badRequest(
            body: ResponseAppModel(message: message ?? "Ошибка запроса"));
}
