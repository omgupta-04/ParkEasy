import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_command/book.dart';
import 'package:voice_command/cancel.dart';
import 'package:voice_command/parking.dart';
import 'package:voice_command/recognized_text_display.dart';
import 'package:voice_command/speech_provider.dart';

class VoiceWakeScreen extends StatelessWidget {
  const VoiceWakeScreen({super.key});

  void _processCommand(BuildContext context, String intent) {
    print('🙏 $intent');
    switch (intent) {
      case "ShowParkingByPrice":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowNearParking()));
        break;

      case "ShowParkingByReview":
      // Add corresponding navigation
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowNearParking()));
        break;

      case "ShowBookingHistory":
      // Add navigation to history page
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Book()));
        break;

      case "AddNewSlot":
      // Navigate to admin or add-slot screen
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Cancel()));
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry, I didn't understand the command.")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Wake Detection")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Say: Hey Park Easy", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Consumer<SpeechProvider>(
              builder: (context, provider, child) {
                // Detect intent change here
                if (provider.getIntent.isNotEmpty) {
                  // Defer navigation until after this frame
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _processCommand(context, provider.getIntent);
                    provider.clearIntent(); // Clear after processing
                  });
                }
                return Column(
                  children: [
                    RecognizedTextDisplay(text: provider.recognizedText),
                    const SizedBox(height: 20),
                    Text("Mic Level: ${provider.soundLevel.toStringAsFixed(2)}"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
