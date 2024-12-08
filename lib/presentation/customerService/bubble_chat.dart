import 'package:flutter/material.dart';

class BubbleChat extends StatelessWidget {
  final bool sender;

  const BubbleChat({super.key, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: () {
        if (sender) {
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
                'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet.',
                textAlign: () {
                  if (sender) {
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
              const Text(
                '10:00 AM',
                style: TextStyle(
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
