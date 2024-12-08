import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/discussionForum/reply_card.dart';
import 'package:jaket_mobile/widgets/custom_icon_button.dart';

class Discussion extends StatefulWidget {
  const Discussion({super.key});

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF8F8F8),
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
            'Discussion',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Spacing
              const SizedBox(height: 15),

              // Discussion Topic
              const Text(
                'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet.',
                textAlign: TextAlign.center,
                style: TextStyle(
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

                    // TODO: Replace with user avatarf
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // Spacing
                  const SizedBox(width: 10),

                  // Discussion Owner Username
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Color(0xFF666666),
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '2 days ago',
                            style: TextStyle(
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
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const ReplyCard();
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
                                borderSide:
                                    const BorderSide(color: Color(0xCECECECE)),
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
                      ]))
            ],
          ),
        ));
  }
}
