import 'package:flutter/material.dart';

import '../models/app_currency.dart';
import '../models/bank_account.dart';
import '../models/transaction_item.dart';

// ============================================================
// CURRENCIES
// ============================================================

const List<AppCurrency> currencies = [
  AppCurrency(
    code: 'INR',
    name: 'Indian Rupee',
    symbol: '₹',
    flag: '🇮🇳',
    rateFromINR: 1.0,
  ),

  AppCurrency(
    code: 'USD',
    name: 'US Dollar',
    symbol: '\$',
    flag: '🇺🇸',

    // Demo exchange rate: 1 USD = 83 INR.
    rateFromINR: 1 / 83,
  ),
];

// ============================================================
// BANK ACCOUNTS
// ============================================================

const List<BankAccount> accounts = [
  BankAccount(
    bankName: 'State Bank of India',
    accountType: 'SBI Account',

    balanceINR: 12450.80,

    lastFour: '4582',

    primary: Color(0xFF0B5ED7),
    secondary: Color(0xFF123D9B),

    logoPath: 'assets/bank_logos/sbi.png',
  ),

  BankAccount(
    bankName: 'Bank of Baroda',
    accountType: 'BOB Account',

    balanceINR: 8920.40,

    lastFour: '7314',

    primary: Color(0xFFF58220),
    secondary: Color(0xFFD94B12),

    logoPath: 'assets/bank_logos/BankOfBaroda.png',
  ),
];

// ============================================================
// TRANSACTIONS
// ============================================================

const List<TransactionItem> transactions = [
  TransactionItem(
    name: 'Salary',
    date: 'Today, 10:30 AM',

    amountINR: 35850.00,
    received: true,

    icon: Icons.arrow_downward_rounded,

    background: Color(0xFFDDF8EB),
    iconColor: Color(0xFF0A9F68),
  ),

  TransactionItem(
    name: 'Amazon',
    date: 'Yesterday, 6:14 PM',

    amountINR: 89.99,
    received: false,

    icon: Icons.shopping_bag_outlined,

    background: Color(0xFFFFE7D5),
    iconColor: Color(0xFFF47B20),
  ),

  TransactionItem(
    name: 'Netflix',
    date: '28 Sep 2024',

    amountINR: 15.99,
    received: false,

    icon: Icons.movie_rounded,

    background: Color(0xFFE7EAF4),
    iconColor: Color(0xFF6A789A),
  ),

  TransactionItem(
    name: 'Sophia Miller',
    date: '27 Sep 2024',

    amountINR: 125.00,
    received: true,

    icon: Icons.person_rounded,

    background: Color(0xFFE9E1FF),
    iconColor: Color(0xFF7046D9),
  ),

  TransactionItem(
    name: 'Starbucks',
    date: '26 Sep 2024',

    amountINR: 8.50,
    received: false,

    icon: Icons.local_cafe_rounded,

    background: Color(0xFFE5F4E7),
    iconColor: Color(0xFF16874D),
  ),

  TransactionItem(
    name: 'Electricity Bill',
    date: '25 Sep 2024',

    amountINR: 65.00,
    received: false,

    icon: Icons.bolt_rounded,

    background: Color(0xFFFFF0BD),
    iconColor: Color(0xFFF4B400),
  ),
];
