import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/widgets/custom_elevated_button.dart';
import 'package:jaket_mobile/widgets/custom_icon_button.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion_card.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion_model.dart';
import 'package:jaket_mobile/presentation/discussionForum/reply_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final ScrollController _scrollController = ScrollController();
  late Future<Map<DiscussionModel, Reply?>> discussionList;
  final TextEditingController topicController = TextEditingController();

  Future<Map<DiscussionModel, Reply?>> getDiscussions(
      CookieRequest request) async {
    // Fetch data from the server
    final response = await request.get("http://10.0.2.2:8000/forum/json/");

    var data = response;

    List<Reply> replies = [];
    for (var reply in data['replies']) {
      if (reply != null) {
        replies.add(Reply.fromJson(reply));
      }
    }

    Map<DiscussionModel, Reply?> discussionMap = {};

    for (var discussion in data['discussions']) {
      if (discussion != null) {
        DiscussionModel discussionModel = DiscussionModel.fromJson(discussion);
        List<Reply> discReplies = [];
        for (var reply in replies) {
          if (reply.fields.discussion == discussionModel.pk) {
            discReplies.add(reply);
          }
        }
        if (discReplies.isNotEmpty) {
          discussionMap[discussionModel] = discReplies[discReplies.length - 1];
        } else {
          discussionMap[discussionModel] = null;
        }
      }
    }

    // Scroll to the bottom after the replies are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    return discussionMap;
  }

  @override
  void initState() {
    super.initState();
    discussionList = getDiscussions(context.read<CookieRequest>());
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
            'Discussion Forum',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: FutureBuilder(
          future: discussionList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 41.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spacing
                    const SizedBox(height: 20),

                    // Header Message
                    const Text(
                      'Join the conversation and share your thoughts!',
                      style: TextStyle(
                        color: Color(0xFF6D0CC9),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    // Spacing
                    const SizedBox(height: 15),

                    // Card
                    Expanded(
                        child: ListView(
                      controller: _scrollController,
                      children: snapshot.data!.entries.map<Widget>((entry) {
                        return DiscussionCard(
                          discussion: entry.key,
                          lastReply: entry.value,
                        );
                      }).toList(),
                    )),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomElevatedButton(
                        leftIcon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        text: 'Start new discussion',
                        buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF527EEE)),
                        buttonTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start a new discussion',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF6D0CC9)),
                                    ),
                                    Text(
                                      'Share your thoughts with the community',
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                                content: TextField(
                                  controller: topicController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText:
                                        'What\'s on your mind? Share your thoughts or questions...',
                                    hintStyle: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xFF666666),
                                    ),
                                    fillColor: const Color(0xFFF9FAFB),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xCECECECE)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                actions: [
                                  CustomElevatedButton(
                                    text: 'Post',
                                    buttonTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    width: 80.0,
                                    buttonStyle: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6D0CC9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final response = await request.postJson(
                                        "http://10.0.2.2:8000/forum/add-discussion-flutter/",
                                        jsonEncode({
                                          "topic": topicController.text,
                                        }),
                                      );

                                      if (response != null &&
                                          response['status'] == 'success') {
                                        Get.back();
                                        setState(() {
                                          discussionList =
                                              getDiscussions(request);
                                        });
                                      } else {
                                        Get.back(); // Close the dialog
                                        Get.snackbar(
                                          'Error',
                                          'Failed to post discussion',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
