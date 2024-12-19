import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';
import 'package:jaket_mobile/widgets/custom_slider.dart';
import 'package:jaket_mobile/presentation/authentication/login.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:jaket_mobile/presentation/homepage/choice_row.dart';
import 'package:jaket_mobile/presentation/homepage/limited_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Page Content')),
    Center(child: Text('Service Center Content')),
    Center(child: Text('Product Page Content')),
    Center(child: Text('Article Page Content')),
    Center(child: Text('Wishlist Page Content')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refresh() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by brand or model',
                    hintStyle: GoogleFonts.inter(color: Colors.grey[800], fontSize: 13.0),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[900]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 172, 172, 172),
                  width: 0.6,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  if (authController.isLoggedIn) {
                    print("User is logged in");
                    _onItemTapped(4); 
                  } else {
                    print("User not logged in");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF2E29A6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomCarousel(),
              const SizedBox(height: 16.0),
              const ChoiceRow(),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommended Product",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "View All",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF2E29A6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 15,
                          color: Color(0xFF2E29A6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const LimitedProductPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
