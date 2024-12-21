// lib/widgets/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/presentation/detail/all_product.dart'; // Import ProductPagee
import 'package:jaket_mobile/presentation/homepage/homepage.dart';
import 'package:jaket_mobile/presentation/service_page/service_page.dart';
import 'package:jaket_mobile/presentation/wishlist/wishlist.dart';
// import 'package:jaket_mobile/presentation/service_center/service_center_page.dart'; // Import ServiceCenterPage
// import 'package:jaket_mobile/presentation/article/article_page.dart'; // Import ArticlePage
// import 'package:jaket_mobile/presentation/wishlist/wishlist_page.dart'; // Import WishlistPage

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

  void _navigateTo(int index) {
    switch (index) {
      case 0:
        Get.offAll(() => const HomePage());
        break;
      case 1:
        Get.offAll(() => const ServiceCenterPage());
        break;
      case 3:
        // Get.offAll(() => const ArticlePage());
        break;
      case 4:
        Get.offAll(() => const WishlistPage());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentRoute = Get.currentRoute;
    int selectedIndex;

    if (currentRoute.contains('home')) {
      selectedIndex = 0;
    } else if (currentRoute.contains('service_center')) {
      selectedIndex = 1;
    } else if (currentRoute.contains('article')) {
      selectedIndex = 3;
    } else if (currentRoute.contains('wishlist')) {
      selectedIndex = 4;
    } else {
      selectedIndex = 0; // Default ke Home jika route tidak dikenali
    }

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
              onTap: (index) {
                if (index != 2) { // Indeks 2 adalah tombol Product
                  _navigateTo(index);
                }
              },
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
              onTap: () {
                Get.offAll(() => const ProductPage());
              },
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
