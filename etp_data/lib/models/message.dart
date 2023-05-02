import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/models/user.dart';

class Message extends ManagedObject<_Message> implements _Message {}

class _Message {
  @primaryKey
  int? id;
  @Column(indexed: true)
  String? content;
  @Column(nullable: true, indexed: true)
  String? imageUrl;
  @Column(indexed: true)
  DateTime? sentTo;

  @Serialize(input: true, output: false)
  int? idTask;

  @Relate(#messages, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
  @Relate(#messages, isRequired: true, onDelete: DeleteRule.cascade)
  Task? task;
}
