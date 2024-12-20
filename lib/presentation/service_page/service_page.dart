import 'package:jaket_mobile/presentation/service_page/models/tiket_entry.dart';
import 'package:jaket_mobile/presentation/service_page/booked_tickets.dart';
import 'package:jaket_mobile/presentation/service_page/schedule_appointment.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';
import 'package:jaket_mobile/widgets/service_center_utils.dart';
import 'package:jaket_mobile/presentation/service_page/servicecenter_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/presentation/service_page/models/service_entry.dart';

class ServiceCenterPage extends StatefulWidget {
  const ServiceCenterPage({super.key});

  @override
  State<ServiceCenterPage> createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  // Controllers for PageView
  final PageController _pageController = PageController();

  Future<List<Tiket>>? _ticketsFuture;
  Future<List<ServiceCenter>>? _serviceCentersFuture;

  // TextEditingController for search
  final TextEditingController _searchController = TextEditingController();

  // Sort options
  String _selectedSortOption = 'Alphabetical\n(A-Z)';
  final List<String> sortOptions = [
    'Alphabetical\n(A-Z)',
    'Alphabetical\n(Z-A)',
    'Best\nRating',
    'Most\nReviews'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the Futures in initState with delayed callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      setState(() {
        _ticketsFuture = fetchTickets(request);
        _serviceCentersFuture = fetchServiceCenters(request);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Fetch service centers
  Future<List<ServiceCenter>> fetchServiceCenters(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/servicecenter/json/');
    List<ServiceCenter> serviceCenters = [];
    for (var d in response) {
      if (d != null) {
        serviceCenters.add(ServiceCenter.fromJson(d));
      }
    }
    return serviceCenters;
  }

  Future<List<Tiket>> fetchTickets(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/tiket/json/');
    List<Tiket> tickets = [];
    for (var d in response) {
      if (d != null) {
        tickets.add(Tiket.fromJson(d));
      }
    }
    return tickets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Centers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BookedTicketsSection(ticketsFuture: _ticketsFuture),
            ),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                      items: buildDropdownItems(sortOptions: sortOptions), 
                      onChanged: (value) {
                        setState(() {
                          _selectedSortOption = value!;
                        });
                      },
                      dropdownColor:const Color.fromARGB(255, 107, 164, 244),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
                        filled: true,
                        fillColor:const Color.fromARGB(255, 107, 164, 244),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
            // Service center section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<ServiceCenter>>(
                future: _serviceCentersFuture,
                builder: (context, AsyncSnapshot<List<ServiceCenter>> snapshot) {
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
                            fontSize: 19,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<ServiceCenter> serviceCenters =
                        filterAndSortData(
                          data: snapshot.data!,
                          query: _searchController.text.toLowerCase(),
                          selectedSortOption: _selectedSortOption,
                        ); 
                    if (serviceCenters.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 80.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/service_center/notavailable.png', 
                              height: 150, 
                            ),
                            const SizedBox(height: 16), 
                            const Center(
                              child: Text(
                                'No service centers match your search.',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 39, 15, 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final double screenWidth = MediaQuery.of(context).size.width;
                    final double itemWidth = (screenWidth / 2) - 24;
                    final double itemHeight = itemWidth * 2.25;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: serviceCenters.map((product) {
                        final serviceCenter = product.fields;
                        final String imageUrl = 'http://10.0.2.2:8000/media/' + serviceCenter.image;
                        return GestureDetector(
                          onTap: () async {
                            bool? didUpdate = await Get.to(() => ServiceCenterDetailPage(serviceCenter: product));

                            if (didUpdate == true) {
                              setState(() {
                                final request = context.read<CookieRequest>();
                                _ticketsFuture = fetchTickets(request);
                              });
                            }
                          },
                          child: SizedBox(
                            width: itemWidth,
                            child: Container(
                              height: itemHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Fixed Height Image Section
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
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
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceCenter.name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            // Use the StarRating widget
                                            StarRating( 
                                              rating: double.parse(serviceCenter.rating),
                                              size: 16.0,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${serviceCenter.rating} (${serviceCenter.totalReviews})',
                                              style: const TextStyle(fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          serviceCenter.address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14.0),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Contact",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          serviceCenter.contact,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14.0),
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
                                        onPressed: () async {
                                          bool? didSubmit = await Get.to(() => TicketFormPage(serviceCenter: product));
                                          
                                          if (didSubmit == true) {
                                            setState(() {
                                              final request = context.read<CookieRequest>();
                                              _ticketsFuture = fetchTickets(request);
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 4, 93, 236),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        child: const Text(
                                          'Schedule Appointment',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.6,
                                          ),
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
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
