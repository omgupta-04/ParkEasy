import 'package:flutter/material.dart';
import 'package:payment/payment_funcs.dart';
import 'package:upi_pay/api.dart';
import 'package:upi_pay/types/meta.dart';

void main() {
  runApp(MaterialApp(home: UpiDemo()));
}

class UpiDemo extends StatelessWidget {
  List<ApplicationMeta> upiApps = [];

  final String upiId = "demo@ok";

  final String name = "Chakshu Jindal";

  final String transactionNote = "Demo Payment";

  final String amount = "100.0";

  UpiPay upiPay = UpiPay();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UPI Demo")),
      body: FutureBuilder<List<ApplicationMeta>>(future: showOptions(), builder: (context,snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }
        final upiApps = snapshot.data!;
        if(upiApps.isEmpty){
          return const Center(child: Text("No UPI apps found"));
        }
        return ListView.builder(itemCount: upiApps.length ,itemBuilder: (context,index){
          final app = upiApps[index];
          return ListTile(
            leading: SizedBox(width: 40, height: 40, child: app.iconImage(20)),
            title: Text(app.upiApplication.getAppName()),
            onTap: () {
              makePayment(
                context: context,
                app: app,
                amount: amount,
                upiId: upiId,
                name: name,
                transactionNote: transactionNote,
              );
            },
          );
        });
      }),
    );
  }
}
