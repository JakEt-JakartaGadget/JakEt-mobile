import 'package:flutter/material.dart';
import 'package:jaket_mobile/widgets/custom_elevated_button.dart';
import 'package:jaket_mobile/widgets/custom_icon_button.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion_card.dart';
import 'package:jaket_mobile/presentation/discussionForum/start_discussion.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CustomIconButton(
            height: 30,
            width: 30,
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D0CC9), Color(0xFF2E29A6)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
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
        body: Padding(
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
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const DiscussionCard();
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: CustomElevatedButton(
                  leftIcon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  text: 'Start new discussion',
                  buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF527EEE)),
                  buttonTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NewTopicDialog();
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
