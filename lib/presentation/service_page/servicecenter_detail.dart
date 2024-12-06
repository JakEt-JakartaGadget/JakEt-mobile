import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/service_page/models/service_entry.dart';

class ServiceCenterDetailPage extends StatelessWidget {
  final Product serviceCenter;

  const ServiceCenterDetailPage({Key? key, required this.serviceCenter}) : super(key: key);

  // Method to render stars
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceCenter.fields.name),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    'http://10.0.2.2:8000/media/${serviceCenter.fields.image}',
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  serviceCenter.fields.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Rating
                Row(
                  children: [
                    renderStars(double.parse(serviceCenter.fields.rating)),
                    const SizedBox(width: 8),
                    Text(
                      '${serviceCenter.fields.rating} (${serviceCenter.fields.totalReviews} reviews)',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        serviceCenter.fields.address,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Contact
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      serviceCenter.fields.contact,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Back and Schedule Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white, 
                      ),
                      label: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white, 
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add logic to schedule an appointment
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 93, 236),
                      ),
                      icon: const Icon(
                        Icons.my_library_books_rounded,
                        color: Colors.white, 
                      ),
                      label: const Text(
                        'Schedule Appointment',
                        style: TextStyle(
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
