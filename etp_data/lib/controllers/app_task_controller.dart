import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:etp_data/models/category.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/models/user.dart';
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
      final Category category = Category();
      category.id = task.idCategory;
      final qCreateTask = Query<Task>(managedContext)
        ..values.category = category
        ..values.user?.id = id
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
  Future<Response> getTask(@Bind.path("id") int id) async {
    try {
      final task = await managedContext.fetchObjectWithID<Task>(id);
      if (task == null) {
        return AppResponse.ok(message: "Задача не найдена");
      }
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
              x.user,
              x.category
            ])
        ..join(object: (x) => x.user)
            .returningProperties((x) => [x.id, x.username, x.email])
        ..join(object: (x) => x.category);
      final currentTask = await qGetTask.fetchOne();
      return Response.ok(currentTask);
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
      if (task.user?.id != currentAuthorId) {
        return AppResponse.ok(message: "Нет доступа к редактированию задачи");
      }
      final Category category = Category();
      category.id = updatedTask.idCategory;
      final qUpdateTask = Query<Task>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.user?.id = currentAuthorId
        ..values.category = category
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
      return AppResponse.ok(message: "Задача успешно обновлена");
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
      if (task.user?.id != currentAuthorId) {
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
      final qGetAllTasks = Query<Task>(managedContext)
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
              x.user,
              x.category
            ])
        ..join(object: (x) => x.user)
            .returningProperties((x) => [x.id, x.username, x.email])
        ..join(object: (x) => x.category);
      final List<Task> tasks = await qGetAllTasks.fetch();
      if (tasks.isEmpty) return Response.notFound();
      return Response.ok(tasks);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка вывода задач");
    }
  }
}
