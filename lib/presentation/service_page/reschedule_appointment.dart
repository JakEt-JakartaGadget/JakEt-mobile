import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/presentation/service_page/models/tiket_entry.dart';

class RescheduleTicketPage extends StatefulWidget {
  final Tiket ticket;

  const RescheduleTicketPage({Key? key, required this.ticket}) : super(key: key);

  @override
  State<RescheduleTicketPage> createState() => _RescheduleTicketPageState();
}

class _RescheduleTicketPageState extends State<RescheduleTicketPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _specificProblems = "";

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.ticket.serviceDate;
    _selectedTime = TimeOfDay(
      hour: int.parse(widget.ticket.serviceTime.split(":")[0]),
      minute: int.parse(widget.ticket.serviceTime.split(":")[1]),
    );
    _specificProblems = widget.ticket.specificProblems;
  }

  String formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}";
  }

  String formatTime(TimeOfDay time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(time.hour)}:${twoDigits(time.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reschedule Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Service Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'http://10.0.2.2:8000/${widget.ticket.serviceCenter.image}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Service Name
            Text(
              widget.ticket.serviceCenter.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Location subtitle
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.ticket.serviceCenter.address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Contact subtitle
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  widget.ticket.serviceCenter.contact,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Form Fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Service Date
                  GestureDetector(
                    onTap: () async {
                      DateTime now = DateTime.now();
                      DateTime initialDate = _selectedDate ?? now;

                      if (initialDate.isBefore(now)) {
                        initialDate = now;
                      }

                      // Limit to 30 days from now
                      DateTime lastDate = now.add(const Duration(days: 30));

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: now,
                        lastDate: lastDate,
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Service Date',
                          hintText: 'Select Date',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Please select a service date';
                          }
                          return null;
                        },
                        controller: TextEditingController(
                          text: _selectedDate == null ? '' : formatDate(_selectedDate!),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Service Time
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        // Check if pickedTime is between 8 AM and 9 PM
                        bool validTime = true;
                        if (pickedTime.hour < 8) {
                          validTime = false;
                        } else if (pickedTime.hour > 21) {
                          validTime = false;
                        } else if (pickedTime.hour == 21 && pickedTime.minute > 0) {
                          validTime = false;
                        }

                        if (!validTime) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a time between 8 AM and 9 PM."),
                            ),
                          );
                        } else {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Service Time',
                          hintText: 'Select Time',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                        validator: (value) {
                          if (_selectedTime == null) {
                            return 'Please select a service time';
                          }
                          return null;
                        },
                        controller: TextEditingController(
                          text: _selectedTime == null ? '' : formatTime(_selectedTime!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Specific Problems
                  TextFormField(
                    initialValue: _specificProblems,
                    decoration: InputDecoration(
                      labelText: 'Specific Problems',
                      hintText: 'Describe your issues',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    maxLines: 4,
                    maxLength: 75,
                    onChanged: (value) {
                      setState(() {
                        _specificProblems = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe your problems';
                      }
                      if (value.length > 75) {
                        return 'Maximum 75 characters allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedDate == null || _selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select date and time."),
                            ),
                          );
                          return;
                        }

                        String serviceDate = formatDate(_selectedDate!);
                        String serviceTime = formatTime(_selectedTime!);

                        final response = await request.postJson(
                          "http://10.0.2.2:8000/tiket/reschedule-ticket-flutter/",
                          jsonEncode(<String, dynamic>{
                            'ticket_id': widget.ticket.id.toString(),
                            'service_date': serviceDate,
                            'service_time': serviceTime,
                            'specific_problems': _specificProblems,
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Appointment rescheduled successfully!"),
                              ),
                            );
                            Get.back(result: true);
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
                    icon: const Icon(Icons.update, color: Colors.white),
                    label: const Text(
                      'Reschedule Appointment',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 4, 93, 236),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
