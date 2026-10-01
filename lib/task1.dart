import 'package:flutter/material.dart';

void main() {
  runApp(const BankAccountsApp());
}

// ------------------------------------------------------------
// APP THEME
// ------------------------------------------------------------

class AppColors {
  static const background = Color(0xFFF7F8FA);
  static const surface = Colors.white;
  static const text = Color(0xFF202631);
  static const secondary = Color(0xFF77808D);
  static const border = Color(0xFFE9ECF0);

  static const primary = Color(0xFF356AE6);
  static const primarySoft = Color(0xFFEEF3FF);

  static const success = Color(0xFF16865B);
  static const successSoft = Color(0xFFEAF7F0);

  static const warning = Color(0xFFB7791F);
  static const warningSoft = Color(0xFFFFF6E5);

  static const danger = Color(0xFFD84B4B);
  static const dangerSoft = Color(0xFFFFEEEE);
}

class BankAccountsApp extends StatelessWidget {
  const BankAccountsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank Accounts',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.surface,
        ),
      ),
      home: const BankAccountsPage(),
    );
  }
}

// ------------------------------------------------------------
// MODEL
// ------------------------------------------------------------

class BankAccount {
  String bankName;
  String accountNumber;
  String ifsc;
  String branch;
  String accountType;
  bool isVerified;
  bool isPrimary;

  BankAccount({
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.branch,
    required this.accountType,
    this.isVerified = false,
    this.isPrimary = false,
  });

  String get maskedNumber {
    final lastFour = accountNumber.length >= 4
        ? accountNumber.substring(accountNumber.length - 4)
        : accountNumber;

    return '******** $lastFour';
  }
}

// ------------------------------------------------------------
// MAIN SCREEN
// ------------------------------------------------------------

class BankAccountsPage extends StatefulWidget {
  const BankAccountsPage({super.key});

  @override
  State<BankAccountsPage> createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
  final List<BankAccount> accounts = [
    BankAccount(
      bankName: 'State Bank of India',
      accountNumber: '123456788876',
      ifsc: 'SBIN0021233',
      branch: 'RGUKT NUZVID',
      accountType: 'Savings Account',
      isVerified: true,
      isPrimary: true,
    ),
    BankAccount(
      bankName: 'HDFC Bank',
      accountNumber: '9876544521',
      ifsc: 'HDFC0001234',
      branch: 'VIJAYAWADA MAIN',
      accountType: 'Savings Account',
      isVerified: false,
    ),
    BankAccount(
      bankName: 'ICICI Bank',
      accountNumber: '456789012',
      ifsc: 'ICIC0000987',
      branch: 'GUNTUR',
      accountType: 'Current Account',
      isVerified: true,
    ),
  ];

  int get verifiedCount =>
      accounts.where((account) => account.isVerified).length;

  BankAccount? get primaryAccount {
    for (final account in accounts) {
      if (account.isPrimary) return account;
    }
    return null;
  }

  void makePrimary(BankAccount selected) {
    setState(() {
      for (final account in accounts) {
        account.isPrimary = identical(account, selected);
      }
      accounts.remove(selected);
      accounts.insert(0, selected);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selected.bankName} is now your primary account'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void verifyAccount(BankAccount account, {VoidCallback? onChanged}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 26),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.warningSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.warning,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Verify bank account',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Verify your ${account.bankName} account ending in ${account.maskedNumber.split(' ').last} to enable all account features.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.secondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      account.isVerified = true;
                    });
                    onChanged?.call();
                    Navigator.pop(context);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Account verified successfully'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text(
                    'Confirm verification',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showAccountOptions(BankAccount account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  account.bankName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  account.maskedNumber,
                  style: const TextStyle(color: AppColors.secondary),
                ),
                const SizedBox(height: 18),
                _optionTile(
                  icon: Icons.visibility_outlined,
                  title: 'View account details',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openDetails(account);
                  },
                ),
                if (!account.isPrimary)
                  _optionTile(
                    icon: Icons.star_outline_rounded,
                    title: 'Make primary account',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      makePrimary(account);
                    },
                  ),
                if (!account.isVerified)
                  _optionTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Verify account',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      verifyAccount(account);
                    },
                  ),
                if (accounts.length > 1)
                  _optionTile(
                    icon: Icons.delete_outline,
                    title: 'Remove account',
                    color: AppColors.danger,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      confirmRemove(account);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.text),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.text,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void confirmRemove(BankAccount account) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove account?'),
          content: Text(
            'Are you sure you want to remove ${account.bankName} ending in ${account.maskedNumber.split(' ').last}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  accounts.remove(account);
                  if (account.isPrimary && accounts.isNotEmpty) {
                    accounts.first.isPrimary = true;
                  }
                });
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  void openDetails(BankAccount account) {
    final detailsKey = GlobalKey<_AccountDetailsPageState>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountDetailsPage(
          key: detailsKey,
          account: account,
          onMakePrimary: () {
            makePrimary(account);
            detailsKey.currentState?.refresh();
          },
          onVerify: () => verifyAccount(
            account,
            onChanged: () => detailsKey.currentState?.refresh(),
          ),
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Bank Accounts',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddAccountPage()),
              ).then((result) {
                if (result is BankAccount && mounted) {
                  setState(() {
                    if (accounts.isNotEmpty) {
                      result.isPrimary = false;
                    }
                    accounts.add(result);
                  });
                }
              });
            },
            icon: const Icon(Icons.add, color: AppColors.primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 4),
          ...accounts.map(_buildAccountCard),
          const SizedBox(height: 18),
          _buildAddAccountButton(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account overview',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  icon: Icons.account_balance_outlined,
                  label: 'Total accounts',
                  value: '${accounts.length}',
                  color: AppColors.primary,
                  background: AppColors.primarySoft,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryItem(
                  icon: Icons.verified_user_outlined,
                  label: 'Verified',
                  value: '$verifiedCount',
                  color: AppColors.success,
                  background: AppColors.successSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: AppColors.secondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // Compact account tile: account number, IFSC and branch share one row.
  Widget _buildAccountCard(BankAccount account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => openDetails(account),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _bankLogo(
                      account.bankName,
                      _bankShortName(account.bankName),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.bankName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            account.accountType,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (account.isPrimary)
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: _compactField(
                          'ACCOUNT',
                          '•••• ${account.accountNumber.length >= 4 ? account.accountNumber.substring(account.accountNumber.length - 4) : account.accountNumber}',
                        ),
                      ),
                      Container(height: 27, width: 1, color: AppColors.border),
                      const SizedBox(width: 7),
                      Expanded(
                        flex: 11,
                        child: _compactField('IFSC', account.ifsc),
                      ),
                      Container(height: 27, width: 1, color: AppColors.border),
                      const SizedBox(width: 7),
                      Expanded(
                        flex: 10,
                        child: _compactField('BRANCH', account.branch),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _statusPill(
                      label: account.isVerified ? 'Verified' : 'Pending',
                      icon: account.isVerified
                          ? Icons.verified_rounded
                          : Icons.schedule,
                      color: account.isVerified
                          ? AppColors.success
                          : AppColors.warning,
                      background: account.isVerified
                          ? AppColors.successSoft
                          : AppColors.warningSoft,
                    ),
                    if (account.isPrimary) ...[
                      const SizedBox(width: 7),
                      _statusPill(
                        label: 'Primary account',
                        icon: Icons.star_rounded,
                        color: AppColors.primary,
                        background: AppColors.primarySoft,
                      ),
                    ],
                    const Spacer(),
                    if (!account.isVerified)
                      TextButton(
                        onPressed: () => verifyAccount(account),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _compactField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _accountDetailLine(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.secondary, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showAtmCardPreview(BankAccount account) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.58),
      builder: (dialogContext) {
        final screenWidth = MediaQuery.of(dialogContext).size.width;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 440 : 440,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAtmCard(account),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Account information',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Close preview',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _previewInfoRow('IFSC code', account.ifsc),
                      _previewInfoRow('Branch', account.branch),
                      _previewInfoRow('Account type', account.accountType),
                      _previewInfoRow(
                        'Verification',
                        account.isVerified ? 'Verified' : 'Pending',
                        valueColor: account.isVerified
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                      _previewInfoRow(
                        'Primary account',
                        account.isPrimary ? 'Yes' : 'No',
                        valueColor: account.isPrimary
                            ? AppColors.primary
                            : null,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            openDetails(account);
                          },
                          child: const Text('View full details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAtmCard(BankAccount account) {
    final colors = _atmCardColors(account.bankName);
    final shortName = _bankShortName(account.bankName);

    return AspectRatio(
      aspectRatio: 1.62,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.32),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -44,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 22,
              bottom: -75,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _bankLogo(account.bankName, shortName),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        account.bankName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.contactless,
                      color: Colors.white.withOpacity(0.9),
                      size: 25,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.maskedNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.accountType.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.86),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        if (account.isPrimary)
                          _atmBadge('PRIMARY', Icons.star_rounded),
                        const SizedBox(width: 6),
                        _atmBadge(
                          account.isVerified ? 'VERIFIED' : 'PENDING',
                          account.isVerified
                              ? Icons.verified_rounded
                              : Icons.schedule,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _atmCardColors(String bankName) {
    final name = bankName.toLowerCase();
    if (name.contains('state bank') || name.contains('sbi')) {
      return const [Color(0xFF1767A8), Color(0xFF073B70)];
    }
    if (name.contains('hdfc')) {
      return const [Color(0xFF174A91), Color(0xFF092B60)];
    }
    if (name.contains('icici')) {
      return const [Color(0xFFB84A25), Color(0xFF7E241D)];
    }
    if (name.contains('axis')) {
      return const [Color(0xFF8C1D40), Color(0xFF4D1536)];
    }
    if (name.contains('kotak')) {
      return const [Color(0xFFB32635), Color(0xFF741B2B)];
    }
    return const [Color(0xFF315D9B), Color(0xFF203C69)];
  }

  Widget _atmBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 11),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor ?? AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankLogo(String bankName, String shortName) {
    final name = bankName.toLowerCase();
    String? imagePath;

    if (name.contains('state bank') || name.contains('sbi')) {
      imagePath = 'assets/bank_logos/sbi.png';
    } else if (name.contains('hdfc')) {
      imagePath = 'assets/bank_logos/hdfc.png';
    } else if (name.contains('icici')) {
      imagePath = 'assets/bank_logos/icici.png';
    } else if (name.contains('axis')) {
      imagePath = 'assets/bank_logos/axis.png';
    } else if (name.contains('kotak')) {
      imagePath = 'assets/bank_logos/kotak.png';
    }

    Widget fallbackLogo() {
      return Center(
        child: Text(
          shortName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _bankColor(bankName),
            fontSize: shortName.length > 3 ? 11 : 14,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE9ECF0)),
      ),
      child: imagePath == null
          ? fallbackLogo()
          : Image.asset(
              imagePath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => fallbackLogo(),
            ),
    );
  }

  Widget _cardField(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor ?? AppColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ],
    );
  }

  Color _bankColor(String bankName) {
    final name = bankName.toLowerCase();
    if (name.contains('state bank') || name.contains('sbi')) {
      return const Color(0xFF1767A8);
    }
    if (name.contains('hdfc')) return const Color(0xFF8B2D79);
    if (name.contains('icici')) return const Color(0xFF9D3C2F);
    if (name.contains('axis')) return const Color(0xFF8D2635);
    if (name.contains('kotak')) return const Color(0xFFB32635);
    return const Color(0xFF315D9B);
  }

  String _bankShortName(String bankName) {
    final name = bankName.toLowerCase();
    if (name.contains('state bank') || name.contains('sbi')) return 'SBI';
    if (name.contains('hdfc')) return 'HDFC';
    if (name.contains('icici')) return 'ICICI';
    if (name.contains('axis')) return 'AXIS';
    if (name.contains('kotak')) return 'K';
    final words = bankName.trim().split(RegExp(r'\s+'));
    if (words.length == 1)
      return words.first
          .substring(0, words.first.length.clamp(1, 4))
          .toUpperCase();
    return words.take(3).map((word) => word[0]).join().toUpperCase();
  }

  Widget _statusPill({
    required String label,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAccountPage()),
        ).then((result) {
          if (result is BankAccount && mounted) {
            setState(() {
              if (accounts.isNotEmpty) {
                result.isPrimary = false;
              }
              accounts.add(result);
            });
          }
        });
      },
      icon: const Icon(Icons.add),
      label: const Text('Add another account'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8F7B45).withOpacity(0.75)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.5, size.height)
      ..moveTo(0, size.height * 0.34)
      ..lineTo(size.width, size.height * 0.34)
      ..moveTo(0, size.height * 0.68)
      ..lineTo(size.width, size.height * 0.68)
      ..moveTo(size.width * 0.24, 0)
      ..lineTo(size.width * 0.24, size.height * 0.34)
      ..moveTo(size.width * 0.76, size.height * 0.68)
      ..lineTo(size.width * 0.76, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ------------------------------------------------------------
// ACCOUNT DETAILS SCREEN
// ------------------------------------------------------------

class AccountDetailsPage extends StatefulWidget {
  final BankAccount account;
  final VoidCallback onMakePrimary;
  final VoidCallback onVerify;

  const AccountDetailsPage({
    super.key,
    required this.account,
    required this.onMakePrimary,
    required this.onVerify,
  });

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  void refresh() {
    if (mounted) setState(() {});
  }

  BankAccount get account => widget.account;
  VoidCallback get onMakePrimary => widget.onMakePrimary;
  VoidCallback get onVerify => widget.onVerify;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Account details',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _buildBankCard(),
              const SizedBox(height: 14),
              _buildInformationSection(),
              const SizedBox(height: 14),
              _buildStatusSection(),
              const SizedBox(height: 16),
              _buildActions(context),
              const SizedBox(height: 12),
              _buildSecurityNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankCard() {
    final colors = _detailAtmColors(account.bankName);
    final bankName = account.bankName.toLowerCase();
    final shortName =
        bankName.contains('state bank') || bankName.contains('sbi')
        ? 'SBI'
        : bankName.contains('hdfc')
        ? 'HDFC'
        : bankName.contains('icici')
        ? 'ICICI'
        : bankName.contains('axis')
        ? 'AXIS'
        : bankName.contains('kotak')
        ? 'KOTAK'
        : account.bankName
              .substring(0, account.bankName.length.clamp(1, 4))
              .toUpperCase();

    return SizedBox(
      height: 165,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.28),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -25,
              top: -45,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 22,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _detailBankLogo(account.bankName, shortName, colors.last),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        account.bankName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.contactless_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 24,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.maskedNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.accountType.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        if (account.isPrimary)
                          _detailCardBadge('PRIMARY', Icons.star_rounded),
                        const SizedBox(width: 6),
                        _detailCardBadge(
                          account.isVerified ? 'VERIFIED' : 'PENDING',
                          account.isVerified
                              ? Icons.verified_rounded
                              : Icons.schedule_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailBankLogo(
    String bankName,
    String shortName,
    Color fallbackColor,
  ) {
    final name = bankName.toLowerCase();
    String? imagePath;

    if (name.contains('state bank') || name.contains('sbi')) {
      imagePath = 'assets/bank_logos/sbi.png';
    } else if (name.contains('hdfc')) {
      imagePath = 'assets/bank_logos/hdfc.png';
    } else if (name.contains('icici')) {
      imagePath = 'assets/bank_logos/icici.png';
    } else if (name.contains('axis')) {
      imagePath = 'assets/bank_logos/axis.png';
    } else if (name.contains('kotak')) {
      imagePath = 'assets/bank_logos/kotak.png';
    }

    Widget fallbackLogo() => Center(
      child: Text(
        shortName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: fallbackColor,
          fontWeight: FontWeight.w900,
          fontSize: shortName.length > 4 ? 10 : 13,
        ),
      ),
    );

    return Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: imagePath == null
          ? fallbackLogo()
          : Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => fallbackLogo(),
            ),
    );
  }

  List<Color> _detailAtmColors(String bankName) {
    final name = bankName.toLowerCase();
    if (name.contains('state bank') || name.contains('sbi')) {
      return const [Color(0xFF1685C5), Color(0xFF073B70)];
    }
    if (name.contains('hdfc')) {
      return const [Color(0xFF315FAD), Color(0xFF092B60)];
    }
    if (name.contains('icici')) {
      return const [Color(0xFFE97835), Color(0xFF8C2E25)];
    }
    if (name.contains('axis')) {
      return const [Color(0xFF9D284A), Color(0xFF4D1536)];
    }
    if (name.contains('kotak')) {
      return const [Color(0xFFD23A4A), Color(0xFF741B2B)];
    }
    return const [Color(0xFF4779B8), Color(0xFF203C69)];
  }

  Widget _detailCardBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 11),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return _sectionCard(
      title: 'Bank information',
      children: [
        _infoRow('Bank name', account.bankName),
        _infoRow('Account number', account.maskedNumber),
        _infoRow('IFSC Code', account.ifsc),
        _infoRow('Branch', account.branch),
        _infoRow('Account Type', account.accountType, last: true),
      ],
    );
  }

  Widget _buildStatusSection() {
    return _sectionCard(
      title: 'Account status',
      children: [
        _statusRow(
          icon: Icons.verified_user_outlined,
          title: 'Verification status',
          value: account.isVerified ? 'Verified' : 'Pending verification',
          color: account.isVerified ? AppColors.success : AppColors.warning,
        ),
        _statusRow(
          icon: Icons.star_outline_rounded,
          title: 'Primary account',
          value: account.isPrimary ? 'Yes' : 'No',
          color: account.isPrimary ? AppColors.primary : AppColors.secondary,
          last: true,
        ),
      ],
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool last = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailPill({
    required String label,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        if (!account.isVerified)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onVerify,
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text('Verify account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        if (!account.isVerified && !account.isPrimary)
          const SizedBox(height: 12),
        if (!account.isPrimary)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onMakePrimary,
              icon: const Icon(Icons.star_outline_rounded),
              label: const Text('Make primary account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 19),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your bank account information is protected. For your security, only the last four digits of your account number are displayed.',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// ADD ACCOUNT SCREEN
// ------------------------------------------------------------

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _confirmAccountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _branchController = TextEditingController();

  String _accountType = 'Savings Account';

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _confirmAccountController.dispose();
    _ifscController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    String label, {
    String? hint,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Add bank account',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Enter your bank account details carefully. Make sure the account number and IFSC code are correct.',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bank details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bankNameController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(
                'Bank name',
                hint: 'Enter bank name',
                prefixIcon: const Icon(Icons.account_balance_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter bank name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                'Account number',
                hint: 'Enter account number',
                prefixIcon: const Icon(Icons.credit_card_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter account number';
                }
                if (!RegExp(r'^[0-9]{6,18}$').hasMatch(value.trim())) {
                  return 'Enter a valid account number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmAccountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                'Confirm account number',
                hint: 'Re-enter account number',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please confirm account number';
                }
                if (value.trim() != _accountNumberController.text.trim()) {
                  return 'Account numbers do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ifscController,
              textCapitalization: TextCapitalization.characters,
              decoration: _inputDecoration(
                'IFSC code',
                hint: 'Enter IFSC code',
                prefixIcon: const Icon(Icons.tag_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter IFSC code';
                }
                if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                    .hasMatch(value.trim().toUpperCase())) {
                  return 'Enter a valid IFSC code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _branchController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(
                'Branch',
                hint: 'Enter branch name',
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter branch name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _accountType,
              decoration: _inputDecoration(
                'Account type',
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Savings Account',
                  child: Text('Savings Account'),
                ),
                DropdownMenuItem(
                  value: 'Current Account',
                  child: Text('Current Account'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _accountType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final account = BankAccount(
                      bankName: _bankNameController.text.trim(),
                      accountNumber: _accountNumberController.text.trim(),
                      ifsc: _ifscController.text.trim().toUpperCase(),
                      branch: _branchController.text.trim(),
                      accountType: _accountType,
                    );

                    final added = await Navigator.push<BankAccount>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewAccountPage(account: account),
                      ),
                    );
                    if (added != null && mounted) {
                      Navigator.pop(context, added);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Review details',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// REVIEW SCREEN
// ------------------------------------------------------------

class ReviewAccountPage extends StatelessWidget {
  final BankAccount account;

  const ReviewAccountPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Review account',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.fact_check_outlined,
                  color: AppColors.primary,
                  size: 36,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Confirm your bank details',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Please check the information before adding this account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                _reviewRow('Bank name', account.bankName),
                _reviewRow('Account number', account.maskedNumber),
                _reviewRow('IFSC code', account.ifsc),
                _reviewRow('Branch', account.branch),
                _reviewRow('Account type', account.accountType, last: true),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.warningSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.warning,
                  size: 19,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'The account will be added as unverified. You can complete verification after linking it.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.text,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<BankAccount>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountAddedPage(account: account),
                  ),
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Confirm and add account',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(String label, String value, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// SUCCESS SCREEN
// ------------------------------------------------------------

class AccountAddedPage extends StatelessWidget {
  final BankAccount account;

  const AccountAddedPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 45,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Account added!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your bank account has been added successfully. Complete verification to use all account features.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondary, height: 1.6),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(
                      account.bankName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      account.maskedNumber,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Pending verification',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, account);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to bank accounts',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
