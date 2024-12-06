import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/service_page/servicecenter_detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/presentation/service_page/models/service_entry.dart';

class ServiceCenterPage extends StatefulWidget {
  const ServiceCenterPage({super.key});

  @override
  State<ServiceCenterPage> createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  Future<List<Product>> fetchServiceCenters(CookieRequest request) async {
    final response =
        await request.get('http://10.0.2.2:8000/servicecenter/json/');
    List<Product> serviceCenters = [];
    for (var d in response) {
      if (d != null) {
        serviceCenters.add(Product.fromJson(d));
      }
    }
    return serviceCenters;
  }

  // Function to render stars based on the rating
  Widget renderStars(double rating) {
    int fullStars = rating.floor();
    int halfStar = (rating % 1 >= 0.5) ? 1 : 0;
    int emptyStars = 5 - fullStars - halfStar;

    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    if (halfStar == 1) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  final TextEditingController _searchController = TextEditingController();

  // Updated sort options to include 'Rating Ascending'
  String _selectedSortOption = 'Alphabetical\n(A-Z)';

  List<String> sortOptions = [
    'Alphabetical\n(A-Z)',
    'Alphabetical\n(Z-A)',
    'Best\nRating',
    'Most\nReviews'
  ];

  // Function to filter and sort data
  List<Product> filterAndSortData(List<Product> data) {
    String query = _searchController.text.toLowerCase();
    List<Product> filtered = data.where((product) {
      return product.fields.name.toLowerCase().contains(query);
    }).toList();

    switch (_selectedSortOption) {
      case 'Alphabetical\n(A-Z)':
        filtered.sort((a, b) => a.fields.name.compareTo(b.fields.name));
        break;
      case 'Alphabetical\n(Z-A)':
        filtered.sort((a, b) => b.fields.name.compareTo(a.fields.name));
        break;
      case 'Best\nRating':
        filtered.sort((a, b) => double.parse(b.fields.rating).compareTo(double.parse(a.fields.rating)));
        break;
      case 'Most\nReviews':
        filtered.sort((a, b) => b.fields.totalReviews.compareTo(a.fields.totalReviews));
        break;
      default:
        break;
    }

    return filtered;
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return sortOptions.map((option) {
      if (option.contains('\n')) {
        final lines = option.split('\n');
        return DropdownMenuItem<String>(
          value: option,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: lines.map((line) {
              return Text(
                line,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(fontSize: 10.0, color: Colors.white),
              );
            }).toList(),
          ),
        );
      } else {
        // Single-line option
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(fontSize: 12.0, color: Colors.white),
          ),
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Centers'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedSortOption,
                      iconEnabledColor: Colors.white,
                      items: _buildDropdownItems(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSortOption = value!;
                        });
                      },
                      dropdownColor: const Color.fromARGB(255, 107, 164, 244),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Colors.black, fontSize: 12.0),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 107, 164, 244),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ),
            // FutureBuilder for data
            FutureBuilder(
              future: fetchServiceCenters(request),
              builder:
                  (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        'No service centers available.',
                        style: TextStyle(
                            fontSize: 20, color: Color(0xff59A5D8)),
                      ),
                    ),
                  );
                } else {
                  List<Product> serviceCenters =
                      filterAndSortData(snapshot.data!);
                  if (serviceCenters.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text(
                          'No service centers match your search.',
                          style: TextStyle(
                              fontSize: 20, color: Color(0xff59A5D8)),
                        ),
                      ),
                    );
                  }
                  final double screenWidth =
                      MediaQuery.of(context).size.width;
                  final double itemWidth = (screenWidth / 2) - 24;
                  final double itemHeight = itemWidth * 2.25;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: serviceCenters.map((product) {
                        final serviceCenter = product.fields;
                        final String imageUrl =
                            'http://10.0.2.2:8000/media/' + serviceCenter.image;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ServiceCenterDetailPage(serviceCenter: product),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: itemWidth,
                            child: Container(
                              height: itemHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(16.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  // Fixed Height Image Section
                                  ClipRRect(
                                    borderRadius:
                                        const BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Details Section
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceCenter.name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            renderStars(
                                                double.parse(
                                                    serviceCenter
                                                        .rating)),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${serviceCenter.rating} (${serviceCenter.totalReviews})',
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          serviceCenter.address,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14.0),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Contact",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          serviceCenter.contact,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Button Section
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0,
                                        left: 12.0,
                                        right: 12.0),
                                    child: SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Handle scheduling logic
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color.fromARGB(
                                                  255, 4, 93, 236),
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    20.0),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Schedule Appointment',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.6,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

