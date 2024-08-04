import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateString(String dateStr) {
  // Assuming your date string is in the format 'yyyy-MM-dd'
  DateTime parsedDate = DateTime.parse(dateStr);
  // Format the date to 'MMMM d, yyyy'
  return DateFormat('MMMM d, yyyy').format(parsedDate);
}

Color getStatusColor(String status) {
  switch (status) {
    case 'waiting':
      return Colors.red;
    case 'inProgress':
      return Colors.blue;
    case 'finished':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getPriorityColor(String priority) {
  switch (priority) {
    case 'low':
      return Colors.blueAccent;
    case 'medium':
      return Colors.indigo;
    case 'high':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
