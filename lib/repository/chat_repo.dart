import 'package:driver_app/model/message_model.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> uploadChatData(String msg) async {
    databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("messages")
        .push()
        .set({"message": msg, "sender": "driver"});
  }

  Future<List<MessageModel>> fetchMessageData() async {
    List<MessageModel> list = [];
    await databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("messages")
        .once()
        .then((value) {
      for (var event in value.snapshot.children) {
        Map map = event.value as Map;
        MessageModel model = MessageModel().fromMap(map);
        list.add(model);
      }
    });
    return list;
  }
}
