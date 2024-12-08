import 'dart:convert';

import 'package:jaket_mobile/presentation/service_page/reschedule_appointment.dart';
import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/service_page/models/tiket_entry.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jaket_mobile/widgets/dots_indicator.dart';

class BookedTicketsSection extends StatefulWidget {
  final Future<List<Tiket>>? ticketsFuture;

  const BookedTicketsSection({Key? key, required this.ticketsFuture}) : super(key: key);

  @override
  _BookedTicketsSectionState createState() => _BookedTicketsSectionState();
}

class _BookedTicketsSectionState extends State<BookedTicketsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Use state variable to hold Future
  late Future<List<Tiket>>? _ticketsFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _ticketsFuture = widget.ticketsFuture ?? fetchTickets(request);
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

  @override
  void didUpdateWidget(covariant BookedTicketsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ticketsFuture != oldWidget.ticketsFuture) {
      setState(() {
        _ticketsFuture = widget.ticketsFuture;
      });
    }
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
                                  formatCustomDate(ticket.serviceDate),
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min, 
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.white,
                                semanticLabel: 'Service Time',
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatTime(ticket.serviceTime),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.timelapse,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Time Until Appointment:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 28),
                            Expanded(
                              child: Text(
                                calculateTimeLeft(ticket.serviceDate, ticket.serviceTime),
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
                      'Specific Problems:',
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
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Confirm Cancellation'),
                            content: const Text('Are you sure you want to cancel this appointment?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Get.back(result: true);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back(result: true);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        // User confirmed cancellation
                        final request = context.read<CookieRequest>();
                        final response = await request.postJson(
                          "http://10.0.2.2:8000/tiket/cancel-appointment-flutter/",
                          jsonEncode(<String, dynamic>{
                            'ticket_id': ticket.id.toString(),
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Appointment cancelled successfully!"),
                              ),
                            );
                            // Refresh the tickets after successful cancellation
                            setState(() {
                              _ticketsFuture = fetchTickets(request);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response['message'] ?? "An error occurred. Please try again.",
                                ),
                              ),
                            );
                          }
                        }
                      }
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
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool? didReschedule = await Get.to(() => RescheduleTicketPage(ticket: ticket));

                      if (didReschedule == true) {
                        // Refresh tickets after successful reschedule
                        final request = context.read<CookieRequest>();
                        setState(() {
                          _ticketsFuture = fetchTickets(request);
                        });
                      }
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load booked tickets.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No booked tickets available.',
                style: TextStyle(fontSize: 16),
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
                  height: screenHeight * 0.62,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: snapshot.data!.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return buildTicketCard(snapshot.data![index]);
                    },
                  ),
                ),
                const SizedBox(height: 10),
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

// Methods for formatting
String formatCustomDate(DateTime date) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String day = twoDigits(date.day);
  String month = twoDigits(date.month);
  String year = date.year.toString();
  return '$day/$month/$year';
}

String formatTime(String time) {
  List<String> parts = time.split(':');
  if (parts.length >= 2) {
    // Just take HH:MM
    return '${parts[0]}:${parts[1]}';
  }
  return time; 
}

String calculateTimeLeft(DateTime serviceDate, String serviceTime) {
  List<String> timeParts = serviceTime.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  DateTime appointmentDateTime = DateTime(
    serviceDate.year,
    serviceDate.month,
    serviceDate.day,
    hour,
    minute,
  );

  DateTime currentTime = DateTime.now();

  Duration diff = appointmentDateTime.difference(currentTime);

  if (diff.isNegative) {
    return 'Appointment has passed';
  }

  int daysLeft = diff.inDays;
  int hoursLeft = diff.inHours % 24;
  int minutesLeft = diff.inMinutes % 60;

  return '$daysLeft days, $hoursLeft hours, and $minutesLeft minutes';
}
