import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:etp_data/models/message.dart';
import 'package:etp_data/models/task.dart';
import 'package:etp_data/utils/app_response.dart';
import 'package:etp_data/utils/app_utils.dart';

class AppChatController extends ResourceController {
  final ManagedContext managedContext;

  AppChatController(this.managedContext);

  @Operation.post()
  Future<Response> sentMessage(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Message message) async {
    try {
      final userId = AppUtils.getIdFromHeader(header);
      final Task currentTask = Task();
      currentTask.id = message.idTask;
      final qSentMessage = Query<Message>(managedContext)
        ..values.content = message.content
        ..values.imageUrl = message.imageUrl
        ..values.sentTo = DateTime.now()
        ..values.user?.id = userId
        ..values.task = currentTask;
      await qSentMessage.insert();
      return AppResponse.ok(message: "Сообщение отправлено");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка отправки сообщения");
    }
  }

  @Operation.get("id")
  Future<Response> getTaskChat(@Bind.path("id") int taskId) async {
    try {
      final currentTask = await managedContext.fetchObjectWithID<Task>(taskId);
      if (currentTask == null) {
        return AppResponse.ok(message: "Задача не найдена");
      }
      final qGetTaskChat = Query<Message>(managedContext)
        ..where((x) => x.task?.id).equalTo(taskId)
        ..returningProperties(
            (x) => [x.id, x.content, x.imageUrl, x.sentTo, x.user, x.task])
        ..join(object: (x) => x.user)
            .returningProperties((x) => [x.id, x.username, x.email])
        ..join(object: (x) => x.task);
      final List<Message> messagesList = await qGetTaskChat.fetch();
      if (messagesList.isEmpty) return AppResponse.ok(message: "Сообщений нет");
      return Response.ok(messagesList);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка загрузки чата");
    }
  }

  @Operation.get()
  Future<Response> getAllChats() async {
    try {
      final qGetAllChats = Query<Message>(managedContext)
        ..returningProperties((x) => [
              x.id,
              x.content,
              x.imageUrl,
              x.sentTo,
              x.user,
              x.task,
            ])
        ..join(object: (x) => x.user)
            .returningProperties((x) => [x.id, x.username, x.email])
        ..join(object: (x) => x.task);
      final List<Message> chats = await qGetAllChats.fetch();
      return Response.ok(chats);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка вывода чатов");
    }
  }
}
