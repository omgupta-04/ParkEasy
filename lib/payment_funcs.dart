import 'package:flutter/material.dart';
import 'package:upi_pay/api.dart';
import 'package:upi_pay/types/discovery.dart';
import 'package:upi_pay/types/meta.dart';

UpiPay upiPay = UpiPay();

Future<List<ApplicationMeta>> showOptions() async {
  return upiPay.getInstalledUpiApplications(
    statusType: UpiApplicationDiscoveryAppStatusType.all,
  );
}

Future<void> makePayment(
    {required BuildContext context,
    required ApplicationMeta app,
    required String amount,
    required String name,
    required String upiId,
    required String transactionNote}) async {
  final txnRef = DateTime.now().millisecondsSinceEpoch.toString();
  final result = await upiPay.initiateTransaction(
    amount: amount,
    app: app.upiApplication,
    //app: UpiApplication.googlePay,
    receiverName: name,
    receiverUpiAddress: upiId,
    transactionRef: txnRef,
    transactionNote: transactionNote,
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Transaction Status: ${result.status}')),
  );
}
