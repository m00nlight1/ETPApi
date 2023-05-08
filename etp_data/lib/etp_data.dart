import 'package:conduit/conduit.dart';
import 'package:etp_data/controllers/app_auth_controller.dart';
import 'package:etp_data/controllers/app_category_controller.dart';
import 'package:etp_data/controllers/app_chat_controller.dart';
import 'package:etp_data/controllers/app_document_controller.dart';
import 'package:etp_data/controllers/app_industry_controller.dart';
import 'package:etp_data/controllers/app_status_controller.dart';
import 'package:etp_data/controllers/app_task_controller.dart';
import 'package:etp_data/controllers/app_task_type_controller.dart';
import 'package:etp_data/controllers/app_token_controller.dart';
import 'package:etp_data/controllers/app_user_controller.dart';
import 'package:etp_data/utils/app_env.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/models/category.dart';
import 'package:etp_data/models/message.dart';
import 'package:etp_data/models/status.dart';
import 'package:etp_data/models/industry.dart';
import 'package:etp_data/models/task_type.dart';
import 'package:etp_data/models/document.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route("token/[:refresh]").link(
      () => AppAuthController(managedContext),
    )
    ..route("tasks/[:id]")
        .link(() => AppTokenController())!
        .link(() => AppTaskController(managedContext))
    ..route("messages/[:id]")
        .link(() => AppTokenController())!
        .link(() => AppChatController(managedContext))
    ..route('category/[:id]')
        .link(() => AppTokenController())!
        .link(() => AppCategoryController(managedContext))
    ..route('status/[:id]')
        .link(() => AppTokenController())!
        .link(() => AppStatusController(managedContext))
    ..route('industry/[:id]')
        .link(() => AppTokenController())!
        .link(() => AppIndustryController(managedContext))
    ..route('tasktype/[:id]')
        .link(() => AppTokenController())!
        .link(() => AppTaskTypeController(managedContext))
    ..route('documents/[:id]')
        .link(() => AppTokenController())!
        .link(() => AppDocumentController(managedContext))
    ..route("user")
        .link(() => AppTokenController())!
        .link(() => AppUserController(managedContext));

  PostgreSQLPersistentStore _initDatabase() {
    return PostgreSQLPersistentStore(
      AppEnv.dbUsername,
      AppEnv.dbPassword,
      AppEnv.dbHost,
      int.tryParse(AppEnv.dbPort),
      AppEnv.dbDatabaseName,
    );
  }
}
