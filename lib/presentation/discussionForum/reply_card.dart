import 'package:flutter/material.dart';

class ReplyCard extends StatefulWidget {
  const ReplyCard({super.key});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
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
                      width: MediaQuery.of(context).size.width - 160,
                      child: const Text(
                        'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet.',
                        style: TextStyle(
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