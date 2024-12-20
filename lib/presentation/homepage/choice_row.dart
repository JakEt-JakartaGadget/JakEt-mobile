import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/comparison/comparison.dart'; 


class ChoiceRow extends StatefulWidget {
  const ChoiceRow({super.key});
  @override
  State<ChoiceRow> createState() => _ChoiceRowState();
}

class _ChoiceRowState extends State<ChoiceRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFeatureIcon(
            icon: Icons.headphones,
            label: "Support",
            onTap: () {
              print("Support tapped");
            },
          ),
          const SizedBox(width: 20.0),
          _buildFeatureIcon(
            icon: Icons.sync_alt,
            label: "Comparison",
            onTap: () {
              Get.to(() => const ComparisonPage()); // Navigasi dengan Get.to
            },
          ),
          const SizedBox(width: 20.0),
          _buildFeatureIcon(
            icon: Icons.forum,
            label: "Forum",
            onTap: () {
              print("Forum tapped");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 23.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(7.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1, 
                  blurRadius: 4, 
                  offset: const Offset(0, 2), 
                ),
              ],
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6D0CC9), 
              size: 24.0,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
