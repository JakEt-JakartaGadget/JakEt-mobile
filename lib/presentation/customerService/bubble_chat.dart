import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/customerService/models.dart';

class BubbleChat extends StatelessWidget {
  final Chat chat;

  const BubbleChat({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: () {
        if (chat.fields.sentByUser) {
          return Alignment.centerRight;
        } else {
          return Alignment.centerLeft;
        }
      }(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFCECECE),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.fields.message,
                textAlign: () {
                  if (chat.fields.sentByUser) {
                    return TextAlign.right;
                  } else {
                    return TextAlign.left;
                  }
                }(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                chat.fields.timeSent,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
