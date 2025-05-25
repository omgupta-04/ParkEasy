import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartpark0/screens/edit_slot_screen.dart';
import 'add_parking_screen.dart';
import 'slot_analytics_screen.dart';
import 'package:smartpark0/providers/slot_provider.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final GlobalKey _profileAvatarKey = GlobalKey();
  final GlobalKey _reviewKey = GlobalKey();
  final GlobalKey _editKey = GlobalKey();

  Widget showcaseWrapper({
    required GlobalKey key,
    required Widget child,
    required String description,
  }) {
    return Showcase(
      key: key,
      description: description,
      descTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      tooltipBackgroundColor: Colors.blueAccent,
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
    _checkAndShowShowcase();
  }

  Future<void> _checkAndShowShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenShowcase = prefs.getBool('hasSeenShowcase') ?? false;

    // For now, changed to always show showcase. Change to !hasSeenShowcase to show once.
    if (!hasSeenShowcase || hasSeenShowcase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _profileAvatarKey,
          _reviewKey,
          _editKey
        ]);
      });
      await prefs.setBool('hasSeenShowcase', true);
    }
  }

  Future<bool> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available')),
        );
        return false;
      }
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication error: $e')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        endDrawer: _buildEndDrawer(context),
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.manage_accounts, color: Colors.blue, size: 30),
          ),
          title: const Text(
            'Owner Dashboard',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
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
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile_default.jpg'),
                  ),)
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ...List.generate(2, (index) {
                final String lotName = 'Lot ${index + 1}';
                final int totalSpots = 12;
                final int occupied = index * 5 + 7;
                final bool isFull = occupied >= totalSpots;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image placeholder
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/dummylot.jpg',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lotName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Price: ₹40/hr'),
                        const Text('Security: CCTV + Guard'),
                        const Text('Rating: ⭐ 4.3'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: isFull ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$occupied/$totalSpots spots',
                              style: TextStyle(
                                color: isFull ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (_) => SlotProvider(),
                                  child: const SlotAnalyticsScreen(),
                                ),
                              ),
                            );
                          },
                          child: index == 0
                              ? showcaseWrapper(
                            key: _reviewKey,
                            description: 'Tap to view reviews and details of this slot',
                            child: Row(
                              children: const [
                                Icon(Icons.reviews, size: 18, color: Colors.grey),
                                SizedBox(width: 6),
                                Text(
                                  '4 Reviews',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Row(
                            children: const [
                              Icon(Icons.reviews, size: 18, color: Colors.grey),
                              SizedBox(width: 6),
                              Text(
                                '4 Reviews',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            index == 0
                                ? showcaseWrapper(
                              key: _editKey,
                              description: 'Tap to edit details of this parking slot.',
                              child: _actionButton(context, 'Edit', Colors.lightBlueAccent),
                            )
                                : _actionButton(context, 'Edit', Colors.lightBlueAccent),

                            const SizedBox(width: 10),
                            _actionButton(context, 'Delete', Colors.redAccent),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
              // Add New Slot Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddParkingScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Add New Slot',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, Color color) {
    return GestureDetector(
      onTap: () async {
        bool authenticated = await _authenticate();
        if (authenticated) {
          if (label == 'Edit') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditSlotScreen()),
            );
          } else if (label == 'Delete') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to delete this slot?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: Add delete logic here (provider or DB)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Slot deleted')),
                        );
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication failed or cancelled')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      width: 270,
      child: Column(
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/profile_default.jpg'),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Owner Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.grey, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'owner@email.com',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
