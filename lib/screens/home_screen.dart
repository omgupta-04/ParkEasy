import 'dart:async';
import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'parking_details_screen.dart';
import 'history_user_screen.dart';
import '../services/notifi_handler.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';






class Parking {
  final String imagePath;
  final String name;
  final bool isBooked;
  final double price;
  final double distance; // in km
  final double rating;

  Parking({
    required this.imagePath,
    required this.name,
    required this.isBooked,
    required this.price,
    required this.distance,
    required this.rating,
  });
}

// Sample parking data
final List<Parking> parkingList = [
  Parking(
    imagePath: 'assets/images/dummylot.jpg',
    name: 'City Center Parking',
    isBooked: false,
    price: 15.0,
    distance: 1.2,
    rating: 4.5,
  ),
  Parking(
    imagePath: 'assets/images/parking2.jpg',
    name: 'Green Park Garage',
    isBooked: true,
    price: 12.0,
    distance: 2.5,
    rating: 4.2,
  ),
  Parking(
    imagePath: 'assets/images/dummylot.jpg',
    name: 'Downtown Lot',
    isBooked: false,
    price: 10.0,
    distance: 0.8,
    rating: 4.0,
  ),
];

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _selectedRadius = 1.0;
  int _selectedIndex = 0;
  final GlobalKey _profileAvatarKey = GlobalKey();
  final GlobalKey _searchBoxKey=GlobalKey();
  final GlobalKey _filterKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();

  Widget showcaseWrapper({
    required GlobalKey key,
    required Widget child,
    required String description,
  }) {
    return Showcase(
      key: key,
      description: description,
      descTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      tooltipBackgroundColor: Colors.blueAccent,
      child: child,
    );
  }

  // TODO: Insert map controller and location logic here if needed
  // Example: GoogleMapController? _mapController;
  // LatLng? _currentLocation;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // TODO: Add map/location initialization logic here
  //     // Example: _getUserLocation();
  //   });
  // }

  // Commented out map logic for location and permission
  /*
  Future<void> _getUserLocation() async {
    ...
  }
  */

  // void _showLocationDialog(
  //     {required String title, required String message, bool openSettings = false})
  // {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text(title),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(context);
  //             if (openSettings) {
  //               await Geolocator.openAppSettings();
  //             }
  //           },
  //           child: Text(openSettings ? "Open Settings" : "OK"),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _checkAndShowShowcase();
  }

  Future<void> _checkAndShowShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenShowcase = prefs.getBool('hasSeenShowcase') ?? false;

    if (!hasSeenShowcase || hasSeenShowcase) {//for now change late to ! case only
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _profileAvatarKey,
          _searchBoxKey,
          _filterKey,
          _historyKey
        ]);
      });
      await prefs.setBool('hasSeenShowcase', true); // Mark as shown
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
      endDrawer: _buildProfileDrawer(widget.email),
      endDrawerEnableOpenDragGesture: false,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Row(
        children: [
          Icon(Icons.location_on, color: Colors.blue),
          SizedBox(width: 6),
          Text("Nearby Slots", style: TextStyle(color: Colors.black)),
        ],
      ),
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: showcaseWrapper(
                key: _profileAvatarKey,
                description: 'Tap here to open your profile and settings.',
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_default.jpg',
                      fit: BoxFit.cover,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ),

            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDrawer(String email) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile_default.jpg'),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 10),
            Text("User Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(email, style: TextStyle(color: Colors.grey[800])),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 1, color: Colors.black.withOpacity(0.3)),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: showcaseWrapper(
                    key: _searchBoxKey,
                    description: 'Tap here to search nearby parking locations.',
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search address or area',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotifiHandler()),
                    );
                  },
                ),
              ],
            ),


            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showcaseWrapper(
                  key: _filterKey,
                  description: 'Tap to filter parking locations by distance.',
                  child: _buildFeatureItem(
                    Icons.filter_list,
                    "Filters",
                    onTap: _showDistanceBottomSheet,
                  ),
                ),
                _buildFeatureItem(
                  Icons.attach_money,
                  "Price",
                  iconColor: Colors.green,
                ),
                _buildFeatureItem(
                  Icons.star,
                  "Rating",
                  iconColor: Colors.yellow[700],
                ),
              ],
            ),

            SizedBox(height: 16),

            // Map placeholder container
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Text("Map goes here", style: TextStyle(color: Colors.black54)),
              ),
            ),

            SizedBox(height: 20),

            // List of parking slots
            Column(
              children: parkingList.map((parking) => _buildParkingItem(parking)).toList(),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildParkingItem(Parking parking) {
  return Container(
  margin: EdgeInsets.symmetric(vertical: 8),
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
  ],
  ),
  child: Row(
  children: [
  // Image box
  Container(
  width: 80,
  height: 60,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(8),
  image: DecorationImage(
  image: AssetImage(parking.imagePath),
  fit: BoxFit.cover,
  ),
  ),
  ),

  SizedBox(width: 12),

  // Info Column
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  // Name and status with dot
  Row(
  children: [
  Expanded(
  child: Text(
  parking.name,
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  overflow: TextOverflow.ellipsis,
  ),
  ),
  SizedBox(width: 6),
  // Status dot and text
  Row(
  children: [
  Container(
  width: 10,
  height: 10,
  decoration: BoxDecoration(
  shape: BoxShape.circle,
  color: parking.isBooked ? Colors.red : Colors.green,
  ),
  ),
  SizedBox(width: 4),
  Text(
  parking.isBooked ? "Booked" : "Empty",
  style: TextStyle(
  color: parking.isBooked ? Colors.red : Colors.green,
  fontWeight: FontWeight.w600,
  fontSize: 12,
  ),
  ),
  ],
  ),
  ],
  ),

  SizedBox(height: 6),

  // Price with icon
  Row(
  children: [
  Icon(Icons.attach_money, size: 16, color: Colors.green[700]),
  SizedBox(width: 4),
  Text("\₹${parking.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 14)),
  ],
  ),

  SizedBox(height: 4),

  // Distance with icon
  Row(
  children: [
  Icon(Icons.location_on, size: 16, color: Colors.blueAccent[700]),
  SizedBox(width: 4),
  Text("${parking.distance.toStringAsFixed(1)} km", style: TextStyle(fontSize: 14)),
  ],
  ),

  SizedBox(height: 4),

  // Rating with parking icon
  Row(
  children: [
  Icon(Icons.star, size: 16, color: Colors.yellowAccent[700]),
  SizedBox(width: 4),
  Text(parking.rating.toString(), style: TextStyle(fontSize: 14)),
  ],
  ),
  ],
  ),
  ),

  // Book Button
    ElevatedButton(
      onPressed: () {
        if (!parking.isBooked) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ParkingDetailsScreen(parking: parking)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Parking space not available here, try another place",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

      },
      child: Text("Book"),
      style: ElevatedButton.styleFrom(
        backgroundColor: parking.isBooked ? Colors.grey[600] : Colors.blue[900],
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

  ],
  ),
  );
  }


  Widget _buildFeatureItem(IconData icon, String label, {VoidCallback? onTap, Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: iconColor ?? Colors.blue),
          ),
          SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  void _showDistanceBottomSheet() {
    double _currentRadius = _selectedRadius;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select Radius within you want Park", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Slider(
                    value: _currentRadius,
                    min: 0.1,
                    max: 5.0,
                    divisions: 49,
                    label: "${_currentRadius.toStringAsFixed(1)} km",
                    onChanged: (value) {
                      setModalState(() {
                        _currentRadius = value;
                      });
                    },
                  ),
                  Text("${_currentRadius.toStringAsFixed(1)} km", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedRadius = _currentRadius;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Apply"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        if (index == 1) {
          // Navigate to History screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HistoryUserScreen()),
          ).then((_) {
            // Reset tab back to Home after returning
            setState(() {
              _selectedIndex = 0;
            });
          });
        } else if (index == 2) {
          _scaffoldKey.currentState?.openEndDrawer();
        }
      },
      items:  [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: showcaseWrapper(
            key: _historyKey,
            description: 'Check your past bookings here.',
            child: Icon(Icons.history),
          ),
          label: "History",
        ),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}