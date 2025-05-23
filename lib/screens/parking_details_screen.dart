import 'package:flutter/material.dart';
import 'package:upi_pay/types/meta.dart';
import 'home_screen.dart';
import '../services/payment_services.dart';
import '../services/payment_handler.dart';

class ParkingDetailsScreen extends StatelessWidget {
  final Parking parking;

  const ParkingDetailsScreen({Key? key, required this.parking}) : super(key: key);

  final List<Map<String, dynamic>> feedbackList = const [
    {
      'name': 'Aditya',
      'avatar': 'A',
      'rating': 4.5,
      'comment': 'Very convenient location!'
    },
    {
      'name': 'Meera',
      'avatar': 'M',
      'rating': 5.0,
      'comment': 'Clean and safe. Highly recommend.'
    },
    {
      'name': 'Ravi',
      'avatar': 'R',
      'rating': 4.0,
      'comment': 'Good service, but a bit tight.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parking.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              parking.imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Availability status with green dot
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 14),
                const SizedBox(width: 8),
                const Text(
                  "Empty",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price, distance, rating info with icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoIcon(icon: Icons.attach_money, label: '${parking.price} Rs/2hr'),
                _InfoIcon(icon: Icons.location_on, label: '${parking.distance} km'),
                _InfoIcon(icon: Icons.star, label: '${parking.rating} ⭐'),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons: Book Now and Navigate
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await PaymentHandler.handlePayment(context);
                    },


                    icon: const Icon(Icons.check_circle),
                    label: const Text("Book Now"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Add navigation logic here
                    },
                    icon: const Icon(Icons.navigation),
                    label: const Text("Navigate"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // User Feedback heading with Report Issue button at top right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "User Feedback",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Hardcoded
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Report issue for ${parking.name}')),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.flag, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        'Report Issue',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Feedback list
            buildUserFeedback(context, feedbackList),
          ],
        ),
      ),
    );
  }

  // Widget function for the feedback list
  Widget buildUserFeedback(BuildContext context, List<Map<String, dynamic>> feedbacks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final feedback = feedbacks[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: CircleAvatar(
            child: Text(feedback['avatar']),
          ),
          title: Text(
            feedback['name'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  feedback['rating'].floor(),
                      (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ),
              const SizedBox(height: 4),
              Text(feedback['comment']),
            ],
          ),
        );
      },
    );
  }
}

// Helper widget for icon + label in info row
class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
