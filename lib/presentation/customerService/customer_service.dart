import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/customerService/bubble_chat.dart';
import 'package:jaket_mobile/widgets/custom_icon_button.dart';

class CustomerServiceChat extends StatefulWidget {
  const CustomerServiceChat({super.key});

  @override
  State<CustomerServiceChat> createState() => _CustomerServiceChatState();

  List<Widget> getBubbleChat() {
    List<Widget> bubbleChat = [];
    for (int i = 0; i < 20; i++) {
      if (i % 2 == 0) {
        bubbleChat.add(BubbleChat(sender: true));
      } else {
        bubbleChat.add(BubbleChat(sender: false));
      }
    }
    return bubbleChat;
  }
}

class _CustomerServiceChatState extends State<CustomerServiceChat> {
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.getBubbleChat().length,
                  itemBuilder: (context, index) {
                    return widget.getBubbleChat()[index];
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
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xCECECECE)),
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
                          colors: [Color(0xFF6D0CC9), Color(0xFF2E29A6)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
