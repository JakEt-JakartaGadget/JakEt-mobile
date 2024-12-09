import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/customerService/bubble_chat.dart';
import 'package:jaket_mobile/widgets/custom_icon_button.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jaket_mobile/presentation/customerService/models.dart';
import 'package:provider/provider.dart';

class CustomerServiceChat extends StatefulWidget {
  const CustomerServiceChat({super.key});

  @override
  State<CustomerServiceChat> createState() => _CustomerServiceChatState();
}

class _CustomerServiceChatState extends State<CustomerServiceChat> {
  final messageController = TextEditingController();
  late Future<Map<DateTime, List<Chat>>> futureChats;

  Future<Map<DateTime, List<Chat>>> getChats(CookieRequest request) async {
    // Fetch data from the server
    final response =
        await request.get('http://127.0.0.1:8000/customer-service/json/');

    var data = response;

    List<Chat> chats = [];
    for (var chat in data) {
      if (chat != null) {
        chats.add(Chat.fromJson(chat));
      }
    }

    // Group chats by date
    Map<DateTime, List<Chat>> groupedChats = {};

    for (var chat in chats) {
      // Extract date from fields
      DateTime chatDate = chat.fields.date;

      // Group chats by their date
      if (!groupedChats.containsKey(chatDate)) {
        groupedChats[chatDate] = [];
      }
      groupedChats[chatDate]?.add(chat);
    }

    return groupedChats;
  }

  @override
  void initState() {
    super.initState();
    futureChats = getChats(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
          leading: CustomIconButton(
            height: 20,
            width: 20,
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Color(0xFFB9B9BD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 10.0,
            ),
            onTap: () {
              Get.back();
            },
          ),
          title: const Text(
            'Customer Service',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: FutureBuilder(
          future: futureChats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  // Date
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      '${snapshot.data!.keys.elementAt(index).day.toString().padLeft(2, '0')}/'
                                      '${snapshot.data!.keys.elementAt(index).month.toString().padLeft(2, '0')}/'
                                      '${snapshot.data!.keys.elementAt(index).year}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF527EEE),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),

                                  // Chat
                                  Column(
                                    children: snapshot.data!.values
                                        .elementAt(index)
                                        .map<Widget>((chat) {
                                      return BubbleChat(chat: chat);
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Chat Input
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xCECECECE)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  hintText: 'Type your message...',
                                  hintStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF999999),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            CustomIconButton(
                              height: 30,
                              width: 30,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6D0CC9),
                                    Color(0xFF2E29A6)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              onTap: () async {
                                final response = await request.postJson(
                                  "http://127.0.0.1:8000/customer-service/send_message_flutter/",
                                  jsonEncode({
                                    "message": messageController.text,
                                  }),
                                );

                                // Print the entire response to see its structure
                                print("Full response: $response");

                                // Check if the response indicates success
                                // This might need to be adjusted based on your actual API response
                                if (response != null &&
                                    response['status'] == 'success') {
                                  messageController.clear();
                                  setState(() {
                                    // Refresh the chat
                                    futureChats = getChats(request);
                                  });
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to send message',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ));
            }
          },
        ));
  }
}
