import 'package:conduit/conduit.dart';
import 'package:etp_data/models/author.dart';

class Task extends ManagedObject<_Task> implements _Task {}

class _Task {
  @primaryKey
  int? id;
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? startOfWork;
  DateTime? endOfWork;
  @Column(nullable: true, omitByDefault: true)
  String? contractorCompany;
  @Column(nullable: true, omitByDefault: true)
  String? responsibleMaster;
  @Column(nullable: true, omitByDefault: true)
  String? representative;
  @Column(nullable: true, omitByDefault: true)
  String? equipmentLevel;
  @Column(nullable: true, omitByDefault: true)
  String? staffLevel;
  @Column(nullable: true, omitByDefault: true)
  String? resultsOfTheWork;
  @Relate(#taskList, isRequired: true, onDelete: DeleteRule.cascade)
  Author? author;
}
