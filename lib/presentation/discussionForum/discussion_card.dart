import 'package:flutter/material.dart';

class DiscussionCard extends StatefulWidget {
  const DiscussionCard({super.key});

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xCECECECE),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // User Avatar
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xCECECECE),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              // Discussion Preview
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discussion Detail
                    Row(
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
                              color: const Color(0xFF666666),
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '2 days ago',
                              style: TextStyle(
                                color: const Color(0xFF666666),
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
                      child: Text(
                        'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Additionals
                    Container(
                      width: MediaQuery.of(context).size.width - 210,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Last Reply Info
                          Row(
                            children: [
                              // Message Icon
                              Icon(
                                Icons.message_rounded,
                                color: const Color(0xFF666666),
                                size: 10,
                              ),

                              // Spacing
                              SizedBox(width: 4),

                              // Last Reply Username
                              Text(
                                'Last reply: by Username',
                                style: TextStyle(
                                  color: const Color(0xFF666666),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),

                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View More >',
                              style: TextStyle(
                                color: const Color(0xFF3859D1),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          )
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
