import 'package:driver_app/model/message_model.dart';
import 'package:driver_app/repository/chat_repo.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController textController = TextEditingController();
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    readData();
    DatabaseUtils().listenChangeMessages(readData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Messages"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  bool self = (messages[index].sender == "driver");
                  return Align(
                    alignment:
                        self ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: self ? Colors.green : Colors.grey),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(messages[index].msg),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                },
                itemCount: messages.length,
              )),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                ChatRepo().uploadChatData(textController.text);
                                textController.text = "";
                                readData();
                              },
                              icon: const Icon(Icons.send)),
                          border: const OutlineInputBorder(),
                          hintText: "Message your driver..",
                          hintStyle: const TextStyle(color: Colors.grey)),
                    ))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void readData() async {
    List<MessageModel> list = await ChatRepo().fetchMessageData();
    setState(() {
      messages = list;
    });
  }
}
