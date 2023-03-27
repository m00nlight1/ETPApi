import 'package:conduit/conduit.dart';
import 'package:etp_data/models/category.dart';
import 'package:etp_data/models/user.dart';

class Task extends ManagedObject<_Task> implements _Task {}

class _Task {
  @primaryKey
  int? id;
  @Column(indexed: true)
  String? title;
  @Column(indexed: true)
  String? content;
  @Column(indexed: true)
  DateTime? createdAt;
  @Column(indexed: true)
  DateTime? startOfWork;
  @Column(indexed: true)
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

  @Serialize(input: true, output: false)
  int? idCategory;
  
  @Relate(#taskList, isRequired: true, onDelete: DeleteRule.cascade)
  Category? category;
  @Relate(#tasks, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
}
