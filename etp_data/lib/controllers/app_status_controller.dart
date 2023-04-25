import 'package:conduit/conduit.dart';
import 'package:etp_data/models/status.dart';
import 'package:etp_data/utils/app_response.dart';

class AppStatusController extends ResourceController {
  AppStatusController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createStatus(@Bind.body() Status status) async {
    try {
      final qCreateStatus = Query<Status>(managedContext)
        ..values.name = status.name;
      await qCreateStatus.insert();
      return AppResponse.ok(message: "Успешное создание статуса");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания статуса");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteStatus(@Bind.path("id") int id) async {
    try {
      final status = await managedContext.fetchObjectWithID<Status>(id);
      if (status == null) {
        return AppResponse.ok(message: "Статус не найден");
      }
      final qDeleteStatus = Query<Status>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteStatus.delete();

      return AppResponse.ok(message: "Успешное удаление статуса");
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.get()
  Future<Response> getAllStatuses() async {
    try {
      final qGetAllStatuses = Query<Status>(managedContext)
        ..returningProperties((x) => [x.id, x.name]);
      final List<Status> statuses = await qGetAllStatuses.fetch();
      if (statuses.isEmpty) return Response.notFound();
      return Response.ok(statuses);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка вывода статусов задачи");
    }
  }
}
