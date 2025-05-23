import 'package:flutter/material.dart';

class ParkingHistory {
  final String name;
  final bool isBooked;
  final double? pricePaid;
  final String address;

  ParkingHistory({
    required this.name,
    required this.isBooked,
    this.pricePaid,
    required this.address,
  });
}

final List<ParkingHistory> historyList = [
  ParkingHistory(
    name: "City Center Parking",
    isBooked: true,
    pricePaid: 15.0,
    address: "123 Main Street, Downtown",
  ),
  ParkingHistory(
    name: "Green Park Garage",
    isBooked: false,
    pricePaid: null,
    address: "456 Green Avenue, Uptown",
  ),
  ParkingHistory(
    name: "Downtown Lot",
    isBooked: true,
    pricePaid: 10.0,
    address: "789 River Road, Riverside",
  ),
];

class HistoryUserScreen extends StatefulWidget {
  const HistoryUserScreen({Key? key}) : super(key: key);

  @override
  State<HistoryUserScreen> createState() => _HistoryUserScreenState();
}

class _HistoryUserScreenState extends State<HistoryUserScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCustomHeader() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: Text(
              "Parking History",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // subtle outer background
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(

          icon: Icon(Icons.arrow_back,color: Colors.blueAccent),
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomHeader(),  // The new rectangular header below top
            Center(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: historyList.map((history) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: Icon(
                          history.isBooked ? Icons.check_circle : Icons.cancel,
                          color: history.isBooked ? Colors.green : Colors.red,
                          size: 28,
                        ),
                        title: Text(
                          history.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(history.address),
                            if (history.isBooked && history.pricePaid != null) ...[
                              SizedBox(height: 4),
                              Text("Price Paid: ₹${history.pricePaid!.toStringAsFixed(2)}"),
                            ],
                          ],
                        ),
                        trailing: Text(
                          history.isBooked ? "Booked" : "Cancelled",
                          style: TextStyle(
                            color: history.isBooked ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
