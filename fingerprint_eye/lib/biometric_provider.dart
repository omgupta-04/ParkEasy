import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricProvider with ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isSupported = false;
  bool get isSupported => _isSupported;

  List<BiometricType> _availableBiometrics = [];
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  Future<void> checkSupport() async {
    _isSupported = await _auth.isDeviceSupported();
    notifyListeners();
  }

  Future<void> getAvailableBiometrics() async {
    try {
      _availableBiometrics = await _auth.getAvailableBiometrics();
      print(_availableBiometrics);
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint('Error getting biometrics: $e');
    }
  }

  Future<bool> authenticate() async {
    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true, // Change to false if we want to authenticate using pin/pattern as well
          stickyAuth: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      debugPrint("Auth error: $e");
      return false;
    }
  }
}
