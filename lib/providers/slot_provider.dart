import 'package:flutter/material.dart';

class SlotProvider with ChangeNotifier {
  final double averageRating = 4.7;
  final int bookingFrequency = 19;

  final List<String> userFeedbacks = [
    "Great experience!",
    "Easy booking process.",
    "Would love more slots.",
    "Amazing",
    "Loved it",
    "Great",
    "Satisfactory",
    "Wow",
    "Cat",
  ];
}
