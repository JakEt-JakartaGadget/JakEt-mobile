import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, 
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.normal,
              ),
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.miscellaneous_services_outlined),
                  label: 'Service Center',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(), 
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined),
                  label: 'Article',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  label: 'Wishlist',
                ),
                
              ],
            ),
          ),

          Positioned(
            bottom: 10, 
            child: GestureDetector(
              onTap: () => onItemTapped(2),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D0CC9), 
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3), 
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.smartphone_outlined,
                      size: 30,
                      color: Colors.white, 
                    ),
                  ),
                  const SizedBox(height: 4), 
                  Text(
                    'Product',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6D0CC9),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
