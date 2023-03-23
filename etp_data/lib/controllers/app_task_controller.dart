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
      if (task.title == null ||
          task.title?.isEmpty == true ||
          task.content == null ||
          task.content?.isEmpty == true) {
        return AppResponse.badRequest(
            message: "Поля Название и Описание обязательны");
      }
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
        ..values.createdAt = DateTime.now()
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

  @Operation.get("id")
  Future<Response> getTask(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final qGetTask = Query<Task>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..returningProperties((x) => [
              x.id,
              x.title,
              x.content,
              x.createdAt,
              x.startOfWork,
              x.endOfWork,
              x.contractorCompany,
              x.responsibleMaster,
              x.representative,
              x.equipmentLevel,
              x.staffLevel,
              x.resultsOfTheWork,
              x.author
            ]);
      final task = await qGetTask.fetchOne();
      if (task == null) {
        return AppResponse.ok(message: "Задача не найдена");
      }
      return AppResponse.ok(
          body: task.backing.contents, message: "Успешное получение задачи");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка доступа");
    }
  }

  @Operation.put("id")
  Future<Response> updateTask(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      @Bind.body() Task updatedTask) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final task = await managedContext.fetchObjectWithID<Task>(id);
      if (task == null) {
        return AppResponse.ok(message: "Задача не найдена");
      }
      if (task.author?.id != currentAuthorId) {
        return AppResponse.ok(message: "Нет доступа к редактированию задачи");
      }
      final qUpdateTask = Query<Task>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.author?.id = currentAuthorId
        ..values.title = updatedTask.title
        ..values.content = updatedTask.content
        ..values.createdAt = DateTime.now()
        ..values.startOfWork = updatedTask.startOfWork
        ..values.endOfWork = updatedTask.endOfWork
        ..values.contractorCompany = updatedTask.contractorCompany
        ..values.responsibleMaster = updatedTask.responsibleMaster
        ..values.representative = updatedTask.representative
        ..values.equipmentLevel = updatedTask.equipmentLevel
        ..values.staffLevel = updatedTask.staffLevel
        ..values.resultsOfTheWork = updatedTask.resultsOfTheWork;
      if (updatedTask.title == null ||
          updatedTask.title?.isEmpty == true ||
          updatedTask.content == null ||
          updatedTask.content?.isEmpty == true) {
        return AppResponse.badRequest(
            message: "Поля Название и Описание обязательны");
      }
      await qUpdateTask.update();
      return AppResponse.ok(message: "Заметка успешно обновлена");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка редактирования задачи");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteTask(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final task = await managedContext.fetchObjectWithID<Task>(id);
      if (task == null) {
        return AppResponse.ok(message: "Задача не найдена");
      }
      if (task.author?.id != currentAuthorId) {
        return AppResponse.ok(
            message: "Нельзя удалить задачу другого пользователя");
      }
      final qDeleteTask = Query<Task>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteTask.delete();
      return AppResponse.ok(message: "Задача удалена");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка удаления задачи");
    }
  }

  @Operation.get()
  Future<Response> getAllTasks() async {
    try {
      final qGetAllTasks = Query<Task>(managedContext);
      final List<Task> tasks = await qGetAllTasks.fetch();
      if (tasks.isEmpty) return Response.notFound();
      return Response.ok(tasks);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка вывода задач");
    }
  }
}
