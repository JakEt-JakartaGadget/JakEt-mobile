import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion_model.dart';
import 'package:jaket_mobile/presentation/discussionForum/reply_model.dart';

class DiscussionCard extends StatefulWidget {
  final DiscussionModel discussion;
  final Reply? lastReply;

  const DiscussionCard(
      {super.key, required this.discussion, required this.lastReply});

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  @override
  Widget build(BuildContext context) {
    final discussion = widget.discussion;
    final lastReply = widget.lastReply;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCECECE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and metadata
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile picture
              // User Avatar
              Container(
                height: 54,
                width: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xCECECECE),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discussion title
                    Text(
                      discussion.fields.topic,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Discussion metadata
                    Row(
                      children: [
                        // Owner username
                        const Text(
                          // ganti ke username dari discussion.owner
                          "Username",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Started date
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('yyyy-MM-dd - kk:mm')
                                  .format(widget.discussion.fields.started),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Last reply info
          Row(
            children: [
              // Message Icon
              // TODO: Change to user profile page
              const Icon(
                Icons.message_rounded,
                color: Color(0xFF666666),
                size: 10,
              ),

              // Spacing
              const SizedBox(width: 4),

              // Last Reply Username
              lastReply != null
                  ? const Text(
                      // TODO: ganti sama username dari lastreply
                      "Last Reply by: Username",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF666666),
                      ),
                    )
                  : const Text(
                      // lastReply.sender.username,
                      "No Replies Yet",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF666666),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 12),

          // Action button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Get.to(
                  Discussion(
                    discussion: discussion,
                  ),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: const Text(
                "View More >",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
