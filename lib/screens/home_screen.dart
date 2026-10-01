import 'dart:async';

import 'package:flutter/material.dart';

import '../models/app_currency.dart';
import '../models/bank_account.dart';
import '../models/transaction_item.dart';
import '../data/dummy_data.dart';

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ============================================================
// HOME SCREEN STATE
// ============================================================

class _HomeScreenState extends State<HomeScreen> {
  // ==========================================================
  // BALANCE CARD CONTROLLER
  // ==========================================================

  final PageController _accountController = PageController();

  Timer? _accountAutoScrollTimer;

  int _accountIndex = 0;

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  int _selectedNav = 0;

  // ==========================================================
  // BALANCE VISIBILITY
  // ==========================================================

  // Keep balances hidden by default.
  bool _showBalance = false;

  // ==========================================================
  // CURRENT CURRENCY
  // ==========================================================

  AppCurrency _selectedCurrency = currencies[0];

  // ==========================================================
  // INIT STATE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    // Start in the middle of a large page range.
    // This allows the customer to keep swiping.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_accountController.hasClients) {
        _accountController.jumpToPage(accounts.length * 1000);
      }
    });

    // Automatically change the balance card
    // every 3 seconds.

    _accountAutoScrollTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) {
      if (!_accountController.hasClients) return;

      _accountController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _accountAutoScrollTimer?.cancel();

    _accountController.dispose();

    super.dispose();
  }

  // ==========================================================
  // CURRENCY CONVERSION
  // ==========================================================

  double _convertFromINR(double amountINR) {
    return amountINR * _selectedCurrency.rateFromINR;
  }

  // ==========================================================
  // FORMAT CURRENCY
  // ==========================================================

  String _formatCurrency(double amountINR) {
    final convertedAmount = _convertFromINR(amountINR);

    return '${_selectedCurrency.symbol} '
        '${convertedAmount.toStringAsFixed(2)}';
  }

  // ==========================================================
  // MAIN SCREEN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // FIXED TOP CONTENT
            // ==================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // TOP BAR
                  _topBar(),

                  const SizedBox(height: 14),

                  // BALANCE CARDS
                  _accountCarousel(),

                  const SizedBox(height: 10),

                  // CAROUSEL DOTS
                  _accountDots(),

                  const SizedBox(height: 25),

                  // QUICK ACTIONS
                  _quickActions(),

                  const SizedBox(height: 25),

                  // RECENT TRANSACTIONS HEADER
                  Row(
                    children: [
                      const Text(
                        'Recent transactions',

                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF101844),
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const Spacer(),

                      const Text(
                        'See all',

                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1745F5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // CURRENCY SELECTOR
                  _currencySelector(),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ==================================================
            // ONLY TRANSACTIONS SCROLL
            // ==================================================
            Expanded(child: _transactionList()),

            // ==================================================
            // FIXED BOTTOM NAVIGATION
            // ==================================================
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _topBar() {
    return SizedBox(
      height: 58,

      child: Row(
        children: [
          // PROFILE IMAGE
          Container(
            width: 50,
            height: 50,

            decoration: const BoxDecoration(
              shape: BoxShape.circle,

              image: DecorationImage(
                image: AssetImage('assets/profile_boy.png'),

                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 13),

          // GREETING
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Good morning,',

                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF71809E),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  'Anna',

                  style: TextStyle(
                    fontSize: 20,
                    height: 1,
                    color: Color(0xFF101844),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          // NOTIFICATION
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.07),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: 27,
                    color: Color(0xFF101B50),
                  ),
                ),

                Positioned(
                  top: 7,
                  right: 7,

                  child: Container(
                    width: 8,
                    height: 8,

                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3044),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BALANCE CARD CAROUSEL
  // ==========================================================

  Widget _accountCarousel() {
    const int totalPages = 10000;

    return SizedBox(
      height: 150,

      child: PageView.builder(
        controller: _accountController,

        itemCount: totalPages,

        onPageChanged: (index) {
          setState(() {
            _accountIndex = index % accounts.length;
          });
        },

        itemBuilder: (context, index) {
          final accountIndex = index % accounts.length;

          return _accountCard(accounts[accountIndex]);
        },
      ),
    );
  }

  // ==========================================================
  // BALANCE CARD
  // ==========================================================

  Widget _accountCard(BankAccount account) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),

      clipBehavior: Clip.antiAlias,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [account.primary, account.secondary],
        ),

        boxShadow: [
          BoxShadow(
            color: account.primary.withOpacity(.25),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Stack(
        children: [
          // ==================================================
          // DECORATIVE CIRCLE 1
          // ==================================================

          Positioned(
            right: -45,
            top: -75,

            child: Container(
              width: 220,
              height: 220,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: Colors.white.withOpacity(.10),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // ==================================================
          // DECORATIVE CIRCLE 2
          // ==================================================
          Positioned(
            right: -20,
            top: -35,

            child: Container(
              width: 180,
              height: 180,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: Colors.white.withOpacity(.08),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // ==================================================
          // TOP ROW
          // ==================================================
          Positioned(
            left: 17,
            top: 13,
            right: 17,

            child: Row(
              children: [
                // BANK LOGO
                Container(
                  width: 31,
                  height: 31,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.95),

                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(3),

                    child: Image.asset(
                      account.logoPath,

                      fit: BoxFit.contain,

                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_balance,
                          size: 18,
                          color: account.primary,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                // ACCOUNT NAME
                Expanded(
                  child: Text(
                    account.accountType,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // EYE BUTTON
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showBalance = !_showBalance;
                    });
                  },

                  child: Icon(
                    _showBalance
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,

                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // TOTAL BALANCE LABEL
          // ==================================================
          const Positioned(
            left: 18,
            top: 62,

            child: Text(
              'Total balance',

              style: TextStyle(
                color: Color(0xD9FFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ==================================================
          // BALANCE
          // ==================================================
          Positioned(
            left: 18,
            top: 83,

            child: Text(
              _showBalance
                  ? _formatCurrency(account.balanceINR)
                  : '${_selectedCurrency.symbol} ••••••••',

              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // ==================================================
          // ACCOUNT NUMBER
          // ==================================================
          Positioned(
            left: 18,
            bottom: 13,

            child: Text(
              '****  ****  ****  ${account.lastFour}',

              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: .7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ==================================================
          // CARD NETWORK DECORATION
          // ==================================================
          Positioned(
            right: 17,
            bottom: 10,

            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,

                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2D18),
                    shape: BoxShape.circle,
                  ),
                ),

                Transform.translate(
                  offset: const Offset(-8, 0),

                  child: Container(
                    width: 25,
                    height: 25,

                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB700),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ACCOUNT DOTS
  // ==========================================================

  Widget _accountDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(
        accounts.length,

        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          margin: const EdgeInsets.symmetric(horizontal: 4),

          width: index == _accountIndex ? 8 : 7,

          height: index == _accountIndex ? 8 : 7,

          decoration: BoxDecoration(
            color: index == _accountIndex
                ? const Color(0xFF2F50F5)
                : const Color(0xFFD0D7E6),

            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // QUICK ACTIONS
  // ==========================================================

  Widget _quickActions() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Quick actions',

              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF101844),
                fontWeight: FontWeight.w800,
              ),
            ),

            const Spacer(),

            const Text(
              'See all',

              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1745F5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            _action(
              Icons.send_rounded,
              'Send',
              const Color(0xFFE2F0FF),
              const Color(0xFF1551E8),
            ),

            _action(
              Icons.qr_code_scanner_rounded,
              'Pay',
              const Color(0xFFF0E7FF),
              const Color(0xFF6933E9),
            ),

            _action(
              Icons.account_balance_rounded,
              'Loan',
              const Color(0xFFDDF7EA),
              const Color(0xFF078B59),
            ),

            _action(
              Icons.more_horiz_rounded,
              'More',
              const Color(0xFFFFE8D6),
              const Color(0xFF17275B),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // QUICK ACTION ITEM
  // ==========================================================

  Widget _action(
    IconData icon,
    String label,
    Color background,
    Color iconColor,
  ) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,

          decoration: BoxDecoration(color: background, shape: BoxShape.circle),

          child: Icon(icon, size: 25, color: iconColor),
        ),

        const SizedBox(height: 7),

        Text(
          label,

          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF18244B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CURRENCY SELECTOR
  // ==========================================================

  Widget _currencySelector() {
    return Container(
      height: 50,

      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE3E8F2), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // CURRENCY ICON
          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),

              borderRadius: BorderRadius.circular(8),
            ),

            child: const Icon(
              Icons.currency_exchange_rounded,
              size: 18,
              color: Color(0xFF2450E8),
            ),
          ),

          const SizedBox(width: 10),

          // LABEL
          const Text(
            'Currency',

            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF66738D),
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          // DROPDOWN
          DropdownButtonHideUnderline(
            child: DropdownButton<AppCurrency>(
              value: _selectedCurrency,

              isDense: true,

              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF53617C),
              ),

              borderRadius: BorderRadius.circular(14),

              items: currencies.map((currency) {
                return DropdownMenuItem<AppCurrency>(
                  value: currency,

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(currency.flag, style: const TextStyle(fontSize: 18)),

                      const SizedBox(width: 7),

                      Text(
                        '${currency.name} '
                        '(${currency.symbol})',

                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF18244B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              onChanged: (currency) {
                if (currency == null) return;

                setState(() {
                  _selectedCurrency = currency;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TRANSACTION LIST
  // ==========================================================

  Widget _transactionList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),

      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: ListView.builder(
        physics: const BouncingScrollPhysics(),

        itemCount: transactions.length,

        itemBuilder: (context, index) {
          return _transactionRow(
            transactions[index],

            index == transactions.length - 1,
          );
        },
      ),
    );
  }

  // ==========================================================
  // TRANSACTION ROW
  // ==========================================================

  Widget _transactionRow(TransactionItem item, bool last) {
    return SizedBox(
      height: 66,

      child: Container(
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFE7EAF1), width: 1),
                ),
        ),

        child: Row(
          children: [
            // TRANSACTION ICON
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: item.background,
                shape: BoxShape.circle,
              ),

              child: Icon(item.icon, size: 21, color: item.iconColor),
            ),

            const SizedBox(width: 12),

            // NAME AND DATE
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    item.name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF18244B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    item.date,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8390AC),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // AMOUNT
            Text(
              '${item.received ? '+' : '−'} '
              '${_formatCurrency(item.amountINR)}',

              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,

                color: item.received
                    ? const Color(0xFF079D65)
                    : const Color(0xFFFF3039),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _bottomNavigation() {
    return Container(
      height: 74,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          _nav(Icons.home_rounded, 'Home', 0),

          _nav(Icons.credit_card_outlined, 'Cards', 1),

          _nav(Icons.monetization_on_outlined, 'Loans', 2),

          _nav(Icons.person_outline_rounded, 'Profile', 3),
        ],
      ),
    );
  }

  // ==========================================================
  // NAVIGATION ITEM
  // ==========================================================

  Widget _nav(IconData icon, String label, int index) {
    final selected = _selectedNav == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        setState(() {
          _selectedNav = index;
        });
      },

      child: SizedBox(
        width: 70,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,

              size: 26,

              color: selected
                  ? const Color(0xFF2048F5)
                  : const Color(0xFF69748F),
            ),

            const SizedBox(height: 3),

            Text(
              label,

              style: TextStyle(
                fontSize: 12,

                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,

                color: selected
                    ? const Color(0xFF2048F5)
                    : const Color(0xFF69748F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
