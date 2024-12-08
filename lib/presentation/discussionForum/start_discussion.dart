import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/discussionForum/discussion.dart';
import 'package:jaket_mobile/widgets/custom_elevated_button.dart';

class NewTopicDialog extends StatelessWidget {
  const NewTopicDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
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
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'What\'s on your mind? Share your thoughts or questions...',
          hintStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF9FAFB),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xCECECECE)),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      actions: [
        CustomElevatedButton(
          text: 'Post',
          buttonTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
          ),
          width: 80.0,
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D0CC9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            Get.back(); // Close the dialog
            Get.to(
              Discussion(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            ); // Navigate to the discussion page
          },
        )
      ],
    );
  }
}
