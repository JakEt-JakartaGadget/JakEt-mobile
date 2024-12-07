import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    hintStyle: GoogleFonts.inter(color: Colors.grey[800], fontSize: 12.0),
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
                  width: 0.6
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _onItemTapped(4); 
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

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
