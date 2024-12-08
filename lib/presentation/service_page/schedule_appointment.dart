import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/presentation/service_page/models/service_entry.dart';

class TicketFormPage extends StatefulWidget {
  final ServiceCenter serviceCenter;

  const TicketFormPage({Key? key, required this.serviceCenter}) : super(key: key);

  @override
  State<TicketFormPage> createState() => _TicketFormPageState();
}

class _TicketFormPageState extends State<TicketFormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _specificProblems = "";

  String formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String year = date.year.toString();
    String month = twoDigits(date.month);
    String day = twoDigits(date.day);
    return "$year-$month-$day";
  }

  String formatTime(TimeOfDay time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hour = twoDigits(time.hour);
    String minute = twoDigits(time.minute);
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar Service Center
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'http://10.0.2.2:8000/media/${widget.serviceCenter.fields.image}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Detail Service Center
            Text(
              widget.serviceCenter.fields.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Location Subtitle with Icon
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
            const SizedBox(height: 4),

            // Location Details
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.serviceCenter.fields.address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Contact Subtitle with Icon
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
            const SizedBox(height: 4),

            // Contact Details
            Row(
              children: [
                Text(
                  widget.serviceCenter.fields.contact,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
                        // Validate time between 8 AM and 9 PM
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

                        // Prepare data
                        String serviceDate = formatDate(_selectedDate!);
                        String serviceTime = formatTime(_selectedTime!);

                        // Send POST request
                        final response = await request.postJson(
                          "http://10.0.2.2:8000/tiket/create-ticket-flutter/",
                          jsonEncode(<String, dynamic>{
                            'service_center_id':
                                widget.serviceCenter.pk.toString(),
                            'service_date': serviceDate,
                            'service_time': serviceTime,
                            'specific_problems': _specificProblems,
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Appointment scheduled successfully!"),
                              ),
                            );
                            Get.back(result: true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response['message'] ??
                                      "An error occurred. Please try again.",
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.my_library_books_rounded, color: Colors.white),
                    label: const Text(
                      'Schedule Appointment',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
