import 'package:flutter/material.dart';

class TransactionItem {
  final String name;
  final String date;

  // Original transaction amount in INR.
  final double amountINR;

  final bool received;

  final IconData icon;
  final Color background;
  final Color iconColor;

  const TransactionItem({
    required this.name,
    required this.date,
    required this.amountINR,
    required this.received,
    required this.icon,
    required this.background,
    required this.iconColor,
  });
}
