import 'package:flutter/material.dart';

class BankAccount {
  final String bankName;
  final String accountType;

  // Original balance stored in INR.
  final double balanceINR;

  final String lastFour;

  final Color primary;
  final Color secondary;

  final String logoPath;

  const BankAccount({
    required this.bankName,
    required this.accountType,
    required this.balanceINR,
    required this.lastFour,
    required this.primary,
    required this.secondary,
    required this.logoPath,
  });
}
