import 'package:conduit/conduit.dart';
import 'package:etp_data/models/category.dart';
import 'package:etp_data/utils/app_response.dart';

class AppCategoryController extends ResourceController {
  AppCategoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createCategory(@Bind.body() Category category) async {
    try {
      final qCreateCategory = Query<Category>(managedContext)
        ..values.name = category.name;
      await qCreateCategory.insert();
      return AppResponse.ok(message: "Успешное создание категории");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания категории");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteCategory(@Bind.path("id") int id) async {
    try {
      final category = await managedContext.fetchObjectWithID<Category>(id);
      if (category == null) {
        return AppResponse.ok(message: "Категория не найдена");
      }
      final qDeleteCategory = Query<Category>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteCategory.delete();

      return AppResponse.ok(message: "Успешное удаление категории");
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
}
