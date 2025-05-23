import 'package:flutter/material.dart';
import 'auth_screen.dart';

class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({super.key});

  @override
  State<AddParkingScreen> createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  String? selectedSecurityOption;

  final _slotsController = TextEditingController();
  final _priceController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<String> securityOptions = ['CCTV', 'Guard', 'None', 'Other'];

  bool showSecurityOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Parking Slot',
          style: TextStyle(color: Colors.white,fontSize: 25,
            fontWeight: FontWeight.bold,),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slot Photos
            const Text("Slot Photos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // To Do: logic here of image picking
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),),
                child: const Icon(Icons.camera_alt, size: 40),
              ),
            ),

             SizedBox(height: 30),

            // Slot Location
            const Text("Slot Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Auto location logic
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text("Auto"),
                  ),
                ),
                 SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // To Do: Pin location logic
                    },
                    icon: const Icon(Icons.location_pin),
                    label: const Text("Pin"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Total Slots
            const Text("Total Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _slotsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 12',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Price per Hour
            const Text("Price per Hour", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 40',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Password for verification
            const Text("Password for Verification", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),


            // Security Settings
            // Security Settings
            const Text("Security Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  selectedSecurityOption = value;
                });
              },
              itemBuilder: (context) => securityOptions
                  .map((option) => PopupMenuItem<String>(
                value: option,
                child: Text(option),
              ))
                  .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedSecurityOption ?? "Tap to select",
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedSecurityOption == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_up),
                  ],
                ),
              ),
            ),



            if (showSecurityOptions)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: securityOptions.map((option) {
                  return ListTile(
                    title: Text(option),
                    leading: Radio<String>(
                      value: option,
                      groupValue: selectedSecurityOption,
                      onChanged: (value) {
                        setState(() {
                          selectedSecurityOption = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

            // Save Slot
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  final totalSlots = _slotsController.text.trim();
                  final price = _priceController.text.trim();
                  final password = _passwordController.text.trim();

                  if (totalSlots.isEmpty ||
                      price.isEmpty ||
                      password.isEmpty ||
                      selectedSecurityOption == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fill all details correctly to save"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // TODO: saving the slot logic
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.purple,
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Save Slot",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
