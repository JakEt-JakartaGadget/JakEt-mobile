import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion_model.dart';
import 'package:jaket_mobile/presentation/discussionForum/reply_card.dart';
import 'package:jaket_mobile/presentation/discussionForum/reply_model.dart';
import 'package:jaket_mobile/widgets/custom_icon_button.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Discussion extends StatefulWidget {
  final DiscussionModel discussion;

  const Discussion({
    super.key,
    required this.discussion,
  });

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController newReplyController = TextEditingController();

  Future<List<Reply>> getReplies(CookieRequest request) async {
    final response = await request
        .get("http://10.0.2.2:8000/forum/get-reply/${widget.discussion.pk}/");

    var data = response;

    List<Reply> replies = [];
    for (var reply in data['replies']) {
      if (reply != null) {
        replies.add(Reply.fromJson(reply));
      }
    }

    // Scroll to the bottom after the replies are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    return replies;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F8F8),
          leading: CustomIconButton(
            height: 20,
            width: 20,
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFB9B9BD),
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
            'Discussion',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: FutureBuilder(
          future: getReplies(request),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spacing
                    const SizedBox(height: 15),

                    // Discussion Topic
                    Text(
                      widget.discussion.fields.topic,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF527EEE),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    // Spacing
                    const SizedBox(height: 15),

                    // Discussion Owner Detail
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // User Avatar
                        Container(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6D0CC9),
                          ),

                          // TODO: Replace with profpic discussion.owner
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        // Spacing
                        const SizedBox(width: 10),

                        // Discussion Owner Username
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              // TODO: Replace with username discussion.owner
                              'Username',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF666666),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(widget.discussion.fields.started),
                                  style: const TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),

                    // Spacing
                    const SizedBox(height: 15),

                    // User Replies Title
                    const Text(
                      'User Replies',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    // User Replies

                    Expanded(
                      child: snapshot.data!.isEmpty
                          ? const Center(
                              child: Text(
                                'No replies yet. Be the first to reply!',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ReplyCard(
                                  reply: snapshot.data![index],
                                );
                              },
                            ),
                    ),

                    // Reply Input
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Textfield
                              Expanded(
                                child: TextField(
                                  maxLines: 2,
                                  controller: newReplyController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText:
                                        'What\'s on your mind? Share your thoughts or questions...',
                                    hintStyle: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xFF666666),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xCECECECE)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),

                              // Spacing
                              const SizedBox(width: 10),

                              // Send Button
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
                                    "http://10.0.2.2:8000/forum/send-reply-flutter/",
                                    jsonEncode(
                                      {
                                        "discussion": widget.discussion.pk,
                                        "reply": newReplyController.text,
                                      },
                                    ),
                                  );
                                  setState(() {
                                    newReplyController.clear();
                                  });
                                },
                              ),
                            ]))
                  ],
                ),
              );
            }
          },
        ));
  }
}
