import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:etp_data/models/document.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/utils/app_response.dart';
import 'package:etp_data/utils/app_utils.dart';

class AppDocumentController extends ResourceController {
  final ManagedContext managedContext;

  AppDocumentController(this.managedContext);

  @Operation.post()
  Future<Response> createDocument(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() FileDocument fileDocument) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final Task task = Task();
      task.id = fileDocument.idTask;
      final qCreateDocument = Query<FileDocument>(managedContext)
        ..values.name = fileDocument.name
        ..values.filePath = fileDocument.filePath
        ..values.createdAt = DateTime.now()
        ..values.user?.id = currentUserId
        ..values.task?.id = task.id;
      await qCreateDocument.insert();
      return AppResponse.ok(message: "Файл добавлен");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка создания файла");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteDocument(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final doc = await managedContext.fetchObjectWithID<FileDocument>(id);
      if (doc == null) {
        return AppResponse.ok(message: "Документ не найден");
      }
      if (doc.user?.id != currentAuthorId) {
        return AppResponse.ok(
            message: "Нельзя удалить документ другого пользователя");
      }
      final qDeleteDocument = Query<FileDocument>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteDocument.delete();
      return AppResponse.ok(message: "Документ удалён");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка удаления документа");
    }
  }

  @Operation.get()
  Future<Response> getAllDocuments(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final qGetAllDocuments = Query<FileDocument>(managedContext)
        ..where((x) => x.user?.id).equalTo(id)
        ..returningProperties(
            (x) => [x.id, x.name, x.filePath, x.createdAt, x.user, x.task])
        ..join(object: (x) => x.user)
            .returningProperties((x) => [x.id, x.username, x.email])
        ..join(object: (x) => x.task);
      final List<FileDocument> docs = await qGetAllDocuments.fetch();
      if (docs.isEmpty) return Response.notFound();
      return Response.ok(docs);
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка вывода документов");
    }
  }
}
