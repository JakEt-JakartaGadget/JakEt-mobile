import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:jaket_mobile/presentation/authentication/login.dart';
import 'package:jaket_mobile/presentation/detail/all_product.dart';
import 'package:jaket_mobile/presentation/detail/detail_product.dart';
import 'package:jaket_mobile/presentation/homepage/choice_row.dart';
import 'package:jaket_mobile/presentation/homepage/limited_product.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';
import 'package:jaket_mobile/widgets/custom_slider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<ProductEntry> allProducts = [];
  List<ProductEntry> productSuggestions = [];
  bool isLoading = true;
  String? errorMessage;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://10.0.2.2:8000/json_allproduct/');
      List<ProductEntry> listProducts = [];

      for (var d in response) {
        if (d != null) {
          ProductEntry product = ProductEntry.fromJson(d);
          listProducts.add(product);
        }
      }

      setState(() {
        allProducts = listProducts;
        productSuggestions = List.from(allProducts);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {}); // Trigger rebuild to update suggestions
    });
  }

  List<TextSpan> _buildHighlightedText(String text, String query) {
    List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
          text: text.substring(index, index + lowerQuery.length),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue)));
      start = index + lowerQuery.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
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
              child: RawAutocomplete<ProductEntry>(
                textEditingController: _searchController,
                focusNode: FocusNode(),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<ProductEntry>.empty();
                  }
                  return productSuggestions.where((ProductEntry option) {
                    final q = textEditingValue.text.toLowerCase();
                    return option.fields.model.toLowerCase().contains(q) ||
                        option.fields.brand.toLowerCase().contains(q) ||
                        option.fields.storage.toLowerCase().contains(q) ||
                        option.fields.ram.toLowerCase().contains(q) ||
                        option.fields.cameraMp.toLowerCase().contains(q) ||
                        option.fields.batteryCapacityMah.toString().contains(q);
                  }).take(5); 
                },
                onSelected: (ProductEntry selection) {
                  _searchController.text = '${selection.fields.brand} ${selection.fields.model}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: selection),
                    ),
                  );
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  _searchController = fieldTextEditingController;
                  return Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Search by brand or model',
                        hintStyle: GoogleFonts.inter(color: Colors.grey[800], fontSize: 13.0),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[900]),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<ProductEntry> onSelected,
                    Iterable<ProductEntry> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 16, 
                        color: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ProductEntry option = options.elementAt(index);
                            return ListTile(
                              leading: option.fields.imageUrl.isNotEmpty
                                  ? Image.network(
                                      option.fields.imageUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported),
                              title: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                      fontSize: 12, color: Colors.black),
                                  children: _buildHighlightedText(
                                      '${option.fields.brand} ${option.fields.model}',
                                      _searchController.text),
                                ),
                              ),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
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
        onRefresh: () async {
          await fetchProducts();
        },
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductPage()),
                        );
                      },
                      child: Row(
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
                    ),
                  ],
                ),
              ),
              const LimitedProductPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}