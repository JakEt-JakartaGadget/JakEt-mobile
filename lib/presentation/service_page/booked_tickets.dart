// lib/widgets/booked_tickets_section.dart

import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/service_page/models/tiket_entry.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jaket_mobile/widgets/dots_indicator.dart';

class BookedTicketsSection extends StatefulWidget {
  const BookedTicketsSection({Key? key}) : super(key: key);

  @override
  _BookedTicketsSectionState createState() => _BookedTicketsSectionState();
}

class _BookedTicketsSectionState extends State<BookedTicketsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State variable to hold the Future
  late Future<List<Tiket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the Future in initState
    final request = context.read<CookieRequest>();
    _ticketsFuture = fetchTickets(request);
  }

  // Fetch tickets
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildTicketCard(Tiket ticket) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(236, 186, 154, 255),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Center Name
                    Text(
                      ticket.serviceCenter.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.white, thickness: 1), 
                    const SizedBox(height: 8),
                    // Date and Time Row
                    Row(
                      children: [
                        // Date
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.white, 
                                semanticLabel: 'Service Date',
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${ticket.serviceDate.toLocal().toIso8601String().split('T')[0]}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, 
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Time
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.white, 
                                semanticLabel: 'Service Time',
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${ticket.serviceTime}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.white, thickness: 1),
                    const SizedBox(height: 8),
                    // Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.white, 
                          semanticLabel: 'Location Icon',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, 
                                ),
                              ),
                              Text(
                                ticket.serviceCenter.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, 
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Contact
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.contact_phone,
                          size: 20,
                          color: Colors.white, 
                          semanticLabel: 'Contact Icon',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Contact',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, 
                                ),
                              ),
                              Text(
                                ticket.serviceCenter.contact,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, 
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.white, thickness: 1), 
                    const SizedBox(height: 8),
                    // Specific Problems
                    const Text(
                      'Specific Problems',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                    Text(
                      ticket.specificProblems,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  // Cancel Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Placeholder for Cancel action
                      // Implement cancel functionality here
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 16, 
                      color: Colors.white, 
                    ),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white, 
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, 
                      foregroundColor: Colors.white, 
                      shape: const StadiumBorder(), 
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8), 
                      minimumSize: const Size(0, 0), 
                    ),
                  ),
                  const SizedBox(width: 8), 
                  // Reschedule Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Placeholder for Reschedule action
                      // Implement reschedule functionality here
                    },
                    icon: const Icon(
                      Icons.my_library_books_rounded,
                      size: 16, 
                      color: Colors.white, 
                    ),
                    label: const Text(
                      'Reschedule',
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      foregroundColor: Colors.white, 
                      shape: const StadiumBorder(), 
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: const Size(0, 0), 
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the screen height
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: FutureBuilder<List<Tiket>>(
        future: _ticketsFuture,
        builder: (context, AsyncSnapshot<List<Tiket>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Failed to load booked tickets.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'No booked tickets available.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Booked Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, 
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenHeight * 0.55, 
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: snapshot.data!.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      var ticket = snapshot.data![index];
                      return buildTicketCard(ticket);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Dots Indicator
                DotsIndicator(
                  currentPage: _currentPage,
                  itemCount: snapshot.data!.length,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
