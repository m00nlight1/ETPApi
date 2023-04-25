import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task_type.dart';
import 'package:etp_data/utils/app_response.dart';

class AppTaskTypeController extends ResourceController {
  AppTaskTypeController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createTaskType(@Bind.body() TaskType taskType) async {
    try {
      final qCreateTaskType = Query<TaskType>(managedContext)
        ..values.name = taskType.name;
      await qCreateTaskType.insert();
      return AppResponse.ok(
          message: "Успешное создание типа предписания авторского надзора");
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Ошибка создания типа предписания авторского надзора");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteTaskType(@Bind.path("id") int id) async {
    try {
      final taskType = await managedContext.fetchObjectWithID<TaskType>(id);
      if (taskType == null) {
        return AppResponse.ok(
            message: "Тип предписания авторского надзора не найден");
      }
      final qDeleteTaskType = Query<TaskType>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteTaskType.delete();

      return AppResponse.ok(
          message: "Успешное удаление типа предписания авторского надзора");
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.get()
  Future<Response> getAllTypes() async {
    try {
      final qGetAllTypes = Query<TaskType>(managedContext)
        ..returningProperties((x) => [x.id, x.name]);
      final List<TaskType> taskTypes = await qGetAllTypes.fetch();
      if (taskTypes.isEmpty) return Response.notFound();
      return Response.ok(taskTypes);
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка вывода типов предписания авторского надзора");
    }
  }
}
