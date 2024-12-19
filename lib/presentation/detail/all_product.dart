import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:jaket_mobile/presentation/detail/detail_product.dart';
import 'package:jaket_mobile/presentation/detail/product_card.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<String> selectedBrands = [];
  List<String> selectedStorages = [];
  List<String> selectedRAMs = [];
  String? sortOrder;
  List<String> brands = [];
  List<String> storages = [];
  List<String> rams = [];
  List<ProductEntry> allProducts = [];
  List<ProductEntry> filteredProducts = [];
  bool isLoading = true;
  String? errorMessage;

  TextEditingController _searchController = TextEditingController();
  List<ProductEntry> productSuggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProducts();
    });
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
      final response =
          await request.get('http://10.0.2.2:8000/json_allproduct/');
      List<ProductEntry> listProducts = [];
      List<String> tempBrands = [];
      List<String> tempStorages = [];
      List<String> tempRAMs = [];

      for (var d in response) {
        if (d != null) {
          ProductEntry product = ProductEntry.fromJson(d);
          listProducts.add(product);
          if (!tempBrands.contains(product.fields.brand)) {
            tempBrands.add(product.fields.brand);
          }
          if (!tempStorages.contains(product.fields.storage)) {
            tempStorages.add(product.fields.storage);
          }
          if (!tempRAMs.contains(product.fields.ram)) {
            tempRAMs.add(product.fields.ram);
          }
          productSuggestions.add(product);
        }
      }

      setState(() {
        allProducts = listProducts;
        filteredProducts = List.from(allProducts);
        brands = tempBrands;
        storages = tempStorages;
        rams = tempRAMs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void applyFilters() {
    List<ProductEntry> tempList = List.from(allProducts);

    if (selectedBrands.isNotEmpty) {
      tempList = tempList
          .where((p) => selectedBrands.contains(p.fields.brand))
          .toList();
    }
    if (selectedStorages.isNotEmpty) {
      tempList = tempList
          .where((p) => selectedStorages.contains(p.fields.storage))
          .toList();
    }
    if (selectedRAMs.isNotEmpty) {
      tempList =
          tempList.where((p) => selectedRAMs.contains(p.fields.ram)).toList();
    }
    if (sortOrder != null) {
      tempList.sort((a, b) {
        double priceA = a.fields.priceInr ?? 0.0;
        double priceB = b.fields.priceInr ?? 0.0;
        if (sortOrder == 'asc') {
          return priceA.compareTo(priceB);
        } else {
          return priceB.compareTo(priceA);
        }
      });
    }

    setState(() {
      filteredProducts = tempList;
    });
  }

  void resetFilters() {
    setState(() {
      selectedBrands.clear();
      selectedStorages.clear();
      selectedRAMs.clear();
      sortOrder = null;
      filteredProducts = List.from(allProducts);
      _searchController.clear();
    });
  }

  Future<void> refreshProducts() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.checkLoginStatus();
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await fetchProducts();
    applyFilters();
    resetFilters();
  }

  Future<void> _openMultiSelectionDialog({
    required String title,
    required List<String> options,
    required List<String> currentSelections,
    required Function(List<String>) onSelected,
  }) async {
    List<String> tempSelected = List.from(currentSelections);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    String option = options[index];
                    bool isSelected = tempSelected.contains(option);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            tempSelected.remove(option);
                          } else {
                            tempSelected.add(option);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Color(0xFF7FADD0) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: isSelected ? Color(0xFF7FADD0) : Colors.grey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSelected(tempSelected);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSortOrder() {
    setState(() {
      if (sortOrder == null || sortOrder == 'desc') {
        sortOrder = 'asc';
      } else {
        sortOrder = 'desc';
      }
      applyFilters();
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        setState(() {
          filteredProducts = List.from(allProducts);
        });
        return;
      }

      List<ProductEntry> searchResults = allProducts.where((product) {
        final q = query.toLowerCase();
        return product.fields.model.toLowerCase().contains(q) ||
            product.fields.brand.toLowerCase().contains(q) ||
            product.fields.storage.toLowerCase().contains(q) ||
            product.fields.ram.toLowerCase().contains(q) ||
            product.fields.cameraMp.toLowerCase().contains(q) ||
            product.fields.batteryCapacityMah.toString().contains(q);
      }).toList();

      setState(() {
        filteredProducts = searchResults;
      });
    });
  }

  void _onSearchSubmitted(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (query.isEmpty) {
      setState(() {
        filteredProducts = List.from(allProducts);
      });
      return;
    }

    List<ProductEntry> searchResults = allProducts.where((product) {
      final q = query.toLowerCase();
      return product.fields.model.toLowerCase().contains(q) ||
          product.fields.brand.toLowerCase().contains(q) ||
          product.fields.storage.toLowerCase().contains(q) ||
          product.fields.ram.toLowerCase().contains(q) ||
          product.fields.cameraMp.toLowerCase().contains(q) ||
          product.fields.batteryCapacityMah.toString().contains(q);
    }).toList();

    setState(() {
      filteredProducts = searchResults;
    });
  }

  ElevatedButton _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 8,
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor:
            isSelected ? const Color(0xFF7FADD0) : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }

  ElevatedButton _buildSortButton({
    required String label,
    required Icon icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 8, // Set font size to 8
            ),
          ),
          const SizedBox(width: 2),
          icon,
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected
            ? (label.contains('(Low)') ? Colors.blue : const Color(0xFF7FADD0))
            : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
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
    Icon sortIcon;
    Color sortColor;
    if (sortOrder == 'asc') {
      sortIcon = Icon(Icons.arrow_upward, size: 16, color: Colors.black);
      sortColor = Colors.blue;
    } else if (sortOrder == 'desc') {
      sortIcon = Icon(Icons.arrow_downward, size: 16, color: Colors.white);
      sortColor = Color(0xFF7FADD0);
    } else {
      sortIcon = Icon(Icons.sort, size: 16, color: Colors.black);
      sortColor = Colors.grey[200]!;
    }

    return Scaffold(
      appBar: AppBar(
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
                  _searchController.text =
                      '${selection.fields.brand} ${selection.fields.model}';
                  _onSearchChanged(
                      '${selection.fields.brand} ${selection.fields.model}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: selection),
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
                      onSubmitted: _onSearchSubmitted,
                      style:
                          GoogleFonts.inter(fontSize: 12), 
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
                        width: MediaQuery.of(context).size.width -
                            16, 
                        color: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ProductEntry option =
                                options.elementAt(index);
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: option),
                                  ),
                                );
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
                  // Implement user profile navigation if needed
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
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: RefreshIndicator(
        onRefresh: refreshProducts,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton(
                      label: selectedBrands.isEmpty
                          ? 'Brand'
                          : 'Brand (${selectedBrands.length})',
                      isSelected: selectedBrands.isNotEmpty,
                      onPressed: () {
                        _openMultiSelectionDialog(
                          title: 'Select Brand',
                          options: brands,
                          currentSelections: selectedBrands,
                          onSelected: (List<String> selections) {
                            setState(() {
                              selectedBrands = selections;
                              applyFilters();
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 5.0),
                    _buildFilterButton(
                      label: selectedStorages.isEmpty
                          ? 'Storage'
                          : 'Storage (${selectedStorages.length})',
                      isSelected: selectedStorages.isNotEmpty,
                      onPressed: () {
                        _openMultiSelectionDialog(
                          title: 'Select Storage',
                          options: storages,
                          currentSelections: selectedStorages,
                          onSelected: (List<String> selections) {
                            setState(() {
                              selectedStorages = selections;
                              applyFilters();
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 5.0),
                    _buildFilterButton(
                      label: selectedRAMs.isEmpty
                          ? 'RAM'
                          : 'RAM (${selectedRAMs.length})',
                      isSelected: selectedRAMs.isNotEmpty,
                      onPressed: () {
                        _openMultiSelectionDialog(
                          title: 'Select RAM',
                          options: rams,
                          currentSelections: selectedRAMs,
                          onSelected: (List<String> selections) {
                            setState(() {
                              selectedRAMs = selections;
                              applyFilters();
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 5.0),
                    _buildSortButton(
                      label: sortOrder == null
                          ? 'Sort'
                          : sortOrder == 'asc'
                              ? 'Sort (Low)'
                              : 'Sort (High)',
                      icon: sortIcon,
                      isSelected: sortOrder != null,
                      onPressed: () {
                        _toggleSortOrder();
                      },
                    ),
                    const SizedBox(width: 5.0),
                    ElevatedButton(
                      onPressed: () {
                        applyFilters();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filters Applied')),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Apply',
                            style: GoogleFonts.inter(
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0), 
                        foregroundColor: Colors.grey[800],
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text('Error: $errorMessage'))
                        : filteredProducts.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada data produk pada Ayo Belanja.',
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xff59A5D8)),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  return ProductCard(product: product);
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
