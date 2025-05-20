import 'package:flutter/material.dart';
import 'package:notific/noti_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController _hourController = TextEditingController();

  final TextEditingController _minController = TextEditingController();

  // void _scheduleNotification(){
  //   int inputHours = int.tryParse(_hourController.text) ?? 0;
  //   int inputMinutes = int.tryParse(_minController.text) ?? 0;
  //   if (inputMinutes >= 60) {
  //     return;
  //   }
  //   if(inputMinutes > 0){
  //     inputHours++;
  //   }
  //   Duration fullDuration = Duration(hours: inputHours);
  //   DateTime completeTime = DateTime.now().add(fullDuration);
  //   DateTime notificationTime = completeTime.subtract(const Duration(minutes: 20));
  //   NotiService().scheduleNotification(
  //     title: 'Scheduled Notification',
  //     body: 'Step 2 Done',
  //     hour: notificationTime.hour,
  //     min: notificationTime.minute,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              NotiService().showNotification(
                title: 'Instant Notification',
                body: 'Step 1 Done',
              );
            },
            child: const Text("Instant Notification"),
          ),
          TextField(
            controller: _hourController,
            decoration: const InputDecoration(labelText: 'Hour'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _minController,
            decoration: const InputDecoration(labelText: 'Minute'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed:()=> NotiService().scheduleNotificationBefore20Min(_hourController,_minController),
            child: const Text('OK'),
          ),
          // ElevatedButton(onPressed:(){ NotiService().scheduleNotification(
          //   title: 'Scheduled Notification',
          //   body: 'Step 2 Done',
          //   hour: 12,
          //   min: 50,
          // );}, child: const Text('Schedule Notification'))
        ],
      ),
    );
  }
}
