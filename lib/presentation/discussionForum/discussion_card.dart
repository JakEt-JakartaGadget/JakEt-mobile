import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion.dart';
import 'package:jaket_mobile/widgets/custom_elevated_button.dart';

class DiscussionCard extends StatefulWidget {
  const DiscussionCard({super.key});

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  @override
  Widget build(BuildContext context) {
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
            children: [
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

              // Discussion Preview
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discussion Detail
                    const Row(
                      children: [
                        // Discussion Owner Username
                        Text(
                          'Username',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        // Spacing
                        SizedBox(width: 8),

                        // Discussion Started Date
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

                    // Discussion Title
                    Container(
                      width: MediaQuery.of(context).size.width - 210,
                      child: const Text(
                        'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Additionals
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 210,
                      child: Wrap(
                        children: [
                          // Last Reply Info
                          const Row(
                            children: [
                              // Message Icon
                              Icon(
                                Icons.message_rounded,
                                color: Color(0xFF666666),
                                size: 10,
                              ),

                              // Spacing
                              SizedBox(width: 4),

                              // Last Reply Username
                              Text(
                                'Last reply: by Username',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),

                          Container(
                            height: 15.0,
                            child: CustomElevatedButton(
                              width: 120.0,
                              text: ' ',
                              leftIcon: const Text(
                                'View More >',
                                style: TextStyle(
                                  color: Color(0xFF527EEE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              buttonStyle: ButtonStyle(
                                elevation: WidgetStateProperty.all(0),
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.transparent),
                              ),
                              onPressed: () {
                                Get.to(
                                  const Discussion(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
