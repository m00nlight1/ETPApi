import 'package:conduit/conduit.dart';
import 'package:etp_data/etp_data.dart';
import 'package:etp_data/utils/app_env.dart';

void main(List<String> arguments) async {
  final int port = int.tryParse(AppEnv.port) ?? 0;
  final service = Application<AppService>()..options.port = port;
  await service.start(numberOfInstances: 3, consoleLogging: true);
}


