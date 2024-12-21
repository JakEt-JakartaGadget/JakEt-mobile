import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaket_mobile/presentation/discussionForum/reply_model.dart';

class ReplyCard extends StatefulWidget {
  final Reply reply;

  const ReplyCard({super.key, required this.reply});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  @override
  Widget build(BuildContext context) {
    final reply = widget.reply;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xCECECECE),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xCECECECE),
                ),
                // TODO: Replace with user avatar
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 15,
                ),
              ),

              // Discussion Preview
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discussion Detail
                    Row(
                      children: [
                        // Discussion Owner Username
                        const Text(
                          // TODO: Replace with username
                          'Username',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        // Spacing
                        const SizedBox(width: 8),

                        // Discussion Started Date
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Color(0xFF666666),
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(reply.fields.replied),
                              style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    // Discussion Title
                    Container(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Text(
                        reply.fields.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
