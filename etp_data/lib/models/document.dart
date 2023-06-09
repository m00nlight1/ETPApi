import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/models/user.dart';

class FileDocument extends ManagedObject<_FileDocument> implements _FileDocument {}

class _FileDocument {
  @primaryKey
  int? id;
  @Column(indexed: true)
  String? name;
  @Column(nullable: true, indexed: true)
  String? filePath;
  @Column(indexed: true)
  DateTime? createdAt;

  @Serialize(input: true, output: false)
  int? idTask;

  @Relate(#documents, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
  @Relate(#documentsList, isRequired: false, onDelete: DeleteRule.cascade)
  Task? task;
}