import 'package:conduit/conduit.dart';
import 'package:etp_data/etp_data.dart';
import 'package:etp_data/utils/app_env.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/models/category.dart';
import 'package:etp_data/models/message.dart';
import 'package:etp_data/models/status.dart';
import 'package:etp_data/models/industry.dart';
import 'package:etp_data/models/task_type.dart';
import 'package:etp_data/models/document.dart';

void main(List<String> arguments) async {
  final int port = int.tryParse(AppEnv.port) ?? 0;
  final service = Application<AppService>()..options.port = port;
  await service.start(numberOfInstances: 3, consoleLogging: true);
}


