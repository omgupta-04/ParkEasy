import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';
import '../services/payment_services.dart';

class PaymentHandler {
  static Future<void> handlePayment(BuildContext context) async {

    final selectedApp = await showModalBottomSheet<ApplicationMeta>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: FutureBuilder<List<ApplicationMeta>>(
            future: PaymentService.getUpiApps(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final upiApps = snapshot.data ?? [];

              if (upiApps.isEmpty) {
                return const Center(child: Text("No UPI apps installed."));
              }

              return ListView.separated(
                itemCount: upiApps.length,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final app = upiApps[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: app.iconImage(40),
                    ),
                    title: Text(app.upiApplication.getAppName()),
                    onTap: () => Navigator.pop(context, app),
                  );
                },
              );
            },
          ),
        );
      },
    );

    if (selectedApp != null) {
      await PaymentService.makePayment(
        context: context,
        app: selectedApp,
        amount: "2.00",
        upiId: "yamanayurveda@okhdfcbank",
        name: "Receiver Name",
        transactionNote: "Dummy payment",
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment cancelled or no app selected.")),
      );
    }
  }
}
