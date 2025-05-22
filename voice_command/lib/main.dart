// import 'package:flutter/material.dart';
// import 'package:porcupine_flutter/porcupine_manager.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:voice_command/book.dart';
// import 'package:voice_command/cancel.dart';
// import 'package:voice_command/parking.dart';
//
// void main() {
//   runApp(MaterialApp(home: VoiceWakeScreen()));
// }
//
// class VoiceWakeScreen extends StatefulWidget {
//   @override
//   _VoiceWakeScreenState createState() => _VoiceWakeScreenState();
// }
//
// class _VoiceWakeScreenState extends State<VoiceWakeScreen> {
//   PorcupineManager? _porcupineManager;
//   String recognizedText = "Hey!!";
//   bool isListening = false;
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   double _soundLevel = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//     _initWakeWord();
//   }
//
//   Future<void> _initSpeech() async {
//     await _speechToText.initialize(onError: print, onStatus: print);
//   }
//
//   Future<void> _initWakeWord() async {
//     // Ask for microphone permission
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       debugPrint("Microphone permission not granted");
//       return;
//     }
//
//     final accessKey =
//         "kT6e7AoFQGKX0SxpntSrTkAr0/kfpbw8yQuPwIhf8uH4CgnFPSIiDQ=="; // Replace with your actual key
//     final keywordPath = 'assets/hey_park_easy.ppn';
//
//     try {
//       _porcupineManager = await PorcupineManager.fromKeywordPaths(
//         accessKey,
//         [keywordPath],
//         _onWakeWordDetected,
//         sensitivities: [0.7], // Optional: adjust sensitivity between 0 and 1
//         errorCallback: (err) {
//           debugPrint("Porcupine error: $err");
//         },
//       );
//
//       await _porcupineManager?.start();
//       debugPrint("Wake word engine started.");
//     } catch (e) {
//       debugPrint("Failed to start PorcupineManager: $e");
//     }
//   }
//
//   void _onWakeWordDetected(int keywordIndex) async {
//     debugPrint('Wake word detected!');
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("Hey Park Easy detected!")));
//     await _porcupineManager?.stop();
//     Future.delayed(Duration(milliseconds: 300), () {
//       _capture();
//     });
//   }
//
//   Future<void> startWakeWord() async {
//     try {
//       await _porcupineManager?.start();
//       debugPrint("Wake word engine restarted.");
//     } catch (e) {
//       debugPrint("Failed to restart Porcupine: $e");
//     }
//   }
//
//   void _capture() async {
//     print(isListening);
//     if (!isListening) {
//       _speechToText.statusListener = (status) async {
//         debugPrint("Speech status: $status");
//         if (status == "notListening" || status == "done") {
//           setState(() => isListening = false);
//           _speechToText.stop();
//           print("🙏");
//           await startWakeWord();
//           _processCommand(recognizedText);
//         }
//       };
//       bool listen = await _speechToText.initialize();
//       if (listen) {
//         setState(() => isListening = true);
//         _speechToText.listen(
//           onResult:
//               (result) => setState(() {
//                 recognizedText = result.recognizedWords;
//               }),
//           onSoundLevelChange:
//               (level) => setState(() {
//                 _soundLevel = level;
//               }),
//         );
//       }
//     }
//   }
//
//   void _processCommand(String command) {
//     debugPrint("Processing command: $command");
//     if (command.contains("parking near me")) {
//       debugPrint("Navigating to ShowNearParking");
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ShowNearParking()),
//       );
//     } else if (command.contains("book a spot")) {
//       debugPrint("Navigating to Book");
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const Book()),
//       );
//     } else if (command.contains("cancel reservation")) {
//       debugPrint("Navigating to Cancel");
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const Cancel()),
//       );
//     } else {
//       debugPrint("Command not understood.");
//       if (mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Sorry, I didn't understand. $command")),
//           );
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _porcupineManager?.stop();
//     _porcupineManager?.delete();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Voice Wake Detection")),
//       body: Column(
//         children: [
//           Center(
//             child: Text("Say: Hey Park Easy", style: TextStyle(fontSize: 20)),
//           ),
//           SizedBox(height: 20),
//           Text(
//             "Recognized: $recognizedText",
//             style: TextStyle(fontSize: 16, color: Colors.blue),
//           ),
//           SizedBox(height: 20),
//           Text("Mic Level: $_soundLevel"),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_command/voice_wake_screen.dart';
import 'package:voice_command/speech_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpeechProvider()),
      ],
      child: MaterialApp(home: VoiceWakeScreen()),
    ),
  );
}
