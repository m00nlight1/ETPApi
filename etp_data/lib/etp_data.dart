import 'package:conduit/conduit.dart';
import 'package:etp_data/controllers/app_auth_controller.dart';
import 'package:etp_data/controllers/app_task_controller.dart';
import 'package:etp_data/controllers/app_token_controller.dart';
import 'package:etp_data/controllers/app_user_controller.dart';
import 'package:etp_data/utils/app_env.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/models/author.dart';

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
