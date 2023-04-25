import 'package:conduit/conduit.dart';
import 'package:etp_data/models/industry.dart';
import 'package:etp_data/utils/app_response.dart';

class AppIndustryController extends ResourceController {
  AppIndustryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createIndustry(@Bind.body() Industry industry) async {
    try {
      final qCreateIndustry = Query<Industry>(managedContext)
        ..values.name = industry.name;
      await qCreateIndustry.insert();
      return AppResponse.ok(
          message: "Успешное создание отрасли предписания авторского надзора");
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Ошибка создания отрасли предписания авторского надзора");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteIndustry(@Bind.path("id") int id) async {
    try {
      final industry = await managedContext.fetchObjectWithID<Industry>(id);
      if (industry == null) {
        return AppResponse.ok(
            message: "Отрасль предписания авторского надзора не найдена");
      }
      final qDeleteIndustry = Query<Industry>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteIndustry.delete();

      return AppResponse.ok(
          message: "Успешное удаление отрасли предписания авторского надзора");
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.get()
  Future<Response> getAllIndustries() async {
    try {
      final qGetAllIndustries = Query<Industry>(managedContext)
        ..returningProperties((x) => [x.id, x.name]);
      final List<Industry> industries = await qGetAllIndustries.fetch();
      if (industries.isEmpty) return Response.notFound();
      return Response.ok(industries);
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка вывода отраслей предписания авторского надзора");
    }
  }
}
