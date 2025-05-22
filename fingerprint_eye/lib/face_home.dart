import 'package:fingerprint_eye/second.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'biometric_provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final biometricProvider = Provider.of<BiometricProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Biometric App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              biometricProvider.isSupported
                  ? 'This Device supports biometrics'
                  : "This Device doesn't support biometrics",
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: biometricProvider.getAvailableBiometrics,
              child: const Text('Get Available Biometrics'),
            ),

            const SizedBox(height: 10),

            Text(
              "Available: ${biometricProvider.availableBiometrics.map((e) => e.name).join(', ')}",
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                bool authenticated = await biometricProvider.authenticate();
                if (authenticated && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondRoute(),
                    ),
                  );
                }
              },
              child: const Text('Authenticate Here'),
            ),
          ],
        ),
      ),
    );
  }
}
