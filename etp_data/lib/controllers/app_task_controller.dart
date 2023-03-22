import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:etp_data/models/author.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/utils/app_response.dart';
import 'package:etp_data/utils/app_utils.dart';

class AppTaskController extends ResourceController {
  final ManagedContext managedContext;

  AppTaskController(this.managedContext);

  @Operation.post()
  Future<Response> createTask(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Task task) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final author = await managedContext.fetchObjectWithID<Author>(id);
      if (author == null) {
        final qCreateAuthor = Query<Author>(managedContext)..values.id = id;
        await qCreateAuthor.insert();
      }
      final qCreateTask = Query<Task>(managedContext)
        ..values.author?.id = id
        ..values.title = task.title
        ..values.content = task.content
        ..values.startOfWork = task.startOfWork
        ..values.endOfWork = task.endOfWork
        ..values.contractorCompany = task.contractorCompany
        ..values.responsibleMaster = task.responsibleMaster
        ..values.representative = task.representative
        ..values.equipmentLevel = task.equipmentLevel
        ..values.staffLevel = task.staffLevel
        ..values.resultsOfTheWork = task.resultsOfTheWork;
      await qCreateTask.insert();
      return AppResponse.ok(message: "Успешное создание задачи");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка создания задачи");
    }
  }

  @Operation.get()
  Future<Response> getTasks() async {
    try {
      return AppResponse.ok(message: "Успешное получение задач");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка получения задач");
    }
  }
}
