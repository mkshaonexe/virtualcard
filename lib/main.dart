import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neobank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F5F5),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

// Data Models
class CardModel {
  final String id;
  final String cardNumber;
  final String cardType;
  final Color backgroundColor;
  final String textPattern;

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardType,
    required this.backgroundColor,
    required this.textPattern,
  });
}

class TransactionModel {
  final String id;
  final String merchant;
  final String date;
  final double amount;
  final String? cashback;
  final IconData icon;

  TransactionModel({
    required this.id,
    required this.merchant,
    required this.date,
    required this.amount,
    this.cashback,
    required this.icon,
  });
}

// Main shell with bottom navigation
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  double _balance = 3200.00;
  bool _isBalanceVisible = true;
  int _selectedCardIndex = 0;

  // Static list of cards
  final List<CardModel> _cards = [
    CardModel(
      id: '1',
      cardNumber: '4568',
      cardType: 'Debit Card',
      backgroundColor: const Color(0xFFC9F158),
      textPattern: 'NEO',
    ),
    CardModel(
      id: '2',
      cardNumber: '2478',
      cardType: 'Credit card',
      backgroundColor: const Color(0xFF202020),
      textPattern: 'CREDIT',
    ),
    CardModel(
      id: '3',
      cardNumber: '9012',
      cardType: 'Bank Account',
      backgroundColor: const Color(0xFFE2E4E8),
      textPattern: 'BANK',
    ),
  ];

  // Static list of transactions
  late final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 't1',
      merchant: 'Starbucks Coffee',
      date: 'October 17, 09:00 PM',
      amount: -44.80,
      cashback: r'+$1.65',
      icon: Icons.local_cafe_rounded,
    ),
    TransactionModel(
      id: 't2',
      merchant: 'Direct Deposit',
      date: 'October 15, 08:30 AM',
      amount: 1500.00,
      icon: Icons.account_balance_wallet_rounded,
    ),
    TransactionModel(
      id: 't3',
      merchant: 'Apple Store',
      date: 'October 12, 02:15 PM',
      amount: -999.00,
      cashback: r'+$30.00',
      icon: Icons.laptop_mac_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Switch between Home Dashboard and Coming Soon for other tabs
          _currentIndex == 0 ? _buildDashboard() : _buildComingSoonView(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  // Dashboard / Home View
  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBalanceCard(),
            const SizedBox(height: 32),
            _buildCardsHeader(),
            const SizedBox(height: 16),
            _buildCardsCarousel(),
            const SizedBox(height: 32),
            _buildTransactionsHeader(),
            const SizedBox(height: 16),
            _buildTransactionsList(),
            const SizedBox(height: 100), // Padding to avoid overlap with bottom navigation
          ],
        ),
      ),
    );
  }

  // Header section
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good morning, Terry',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF202020),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Welcome to Neobank',
              style: TextStyle(
                color: const Color(0xFF202020).withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        // Notification bell with active indicator
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E4E8), width: 1.5),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF202020),
                size: 24,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9F158),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Balance Card
  Widget _buildBalanceCard() {
    final formattedBalance = '\$${_balance.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your balance',
                style: TextStyle(
                  color: const Color(0xFF202020).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF7A7C80),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _isBalanceVisible ? formattedBalance : '\$ ••••••',
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
              color: Color(0xFF202020),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showAddMoneyBottomSheet(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Add money',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cards list header
  Widget _buildCardsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your cards',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202020),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Row(
            children: [
              Icon(Icons.add, size: 16, color: Color(0xFF202020)),
              SizedBox(width: 4),
              Text(
                'New card',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202020),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Cards Carousel (PageView with slightly visible next card)
  Widget _buildCardsCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          final isNeon = card.backgroundColor == const Color(0xFFC9F158);
          final isDark = card.backgroundColor == const Color(0xFF202020);
          final textColor = isNeon ? const Color(0xFF202020) : Colors.white;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: card.backgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Pattern for Neon/Lime Card
                  if (isNeon)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.08,
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.15,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(12, (index) {
                                return Text(
                                  card.textPattern,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF202020),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Pattern for Dark Card
                  if (isDark)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CardLinesPainter(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'N.',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            _buildMastercardLogo(),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.cardType,
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '•••• ${card.cardNumber}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                if (isNeon)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 14,
                                          color: Color(0xFF202020),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Details',
                                          style: TextStyle(
                                            color: Color(0xFF202020),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Mini MasterCard logo
  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 30,
      height: 20,
      child: Stack(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFEB001B),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withOpacity(0.85),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Transactions list header
  Widget _buildTransactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202020),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'See all',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF202020),
            ),
          ),
        ),
      ],
    );
  }

  // Transactions List
  Widget _buildTransactionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        final isNegative = tx.amount < 0;
        final amountText =
            '${isNegative ? '-' : '+'}\$${tx.amount.abs().toStringAsFixed(2)}';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(tx.icon, color: const Color(0xFF202020), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.merchant,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF202020),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tx.date,
                      style: TextStyle(
                        color: const Color(0xFF202020).withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amountText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF202020),
                    ),
                  ),
                  if (tx.cashback != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9F158).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tx.cashback!,
                        style: const TextStyle(
                          color: Color(0xFF7CA018),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Floating/Rounded Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF202020).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E4E8), width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_filled, Icons.home_outlined, 'Home'),
          _buildNavItem(1, Icons.map, Icons.map_outlined, 'Map'),
          _buildNavItem(2, Icons.swap_horizontal_circle, Icons.swap_horizontal_circle_outlined, 'Transfer'),
          _buildNavItem(3, Icons.settings, Icons.settings_outlined, 'Settings'),
          _buildProfileNavItem(4),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF202020) : const Color(0xFF7A7C80);
    final icon = isSelected ? activeIcon : inactiveIcon;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileNavItem(int index) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFC9F158) : Colors.transparent,
                  width: 2.0,
                ),
              ),
              child: const SizedBox(
                width: 22,
                height: 22,
                child: ClipOval(
                  child: Icon(
                    Icons.person_rounded,
                    size: 18,
                    color: Color(0xFF202020),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Profile',
              style: TextStyle(
                color: isSelected ? const Color(0xFF202020) : const Color(0xFF7A7C80),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // View for Coming Soon screens
  Widget _buildComingSoonView() {
    final titles = {
      1: 'Map View',
      2: 'Transfer Funds',
      3: 'Settings',
      4: 'User Profile',
    };

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF202020).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC9F158).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_empty_rounded,
                color: Color(0xFF202020),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              titles[_currentIndex] ?? 'Feature',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202020),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(
                color: const Color(0xFF202020).withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Interactive Bottom Sheet to Add Money
  void _showAddMoneyBottomSheet() {
    final amountController = TextEditingController(text: '50');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Money',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202020),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Source Card:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Horizontal card selector in sheet
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        final isSelected = _selectedCardIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedCardIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: card.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: const Color(0xFF202020),
                                      width: 2.5,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${card.cardType} (•••• ${card.cardNumber})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: card.backgroundColor ==
                                          const Color(0xFFC9F158)
                                      ? const Color(0xFF202020)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202020),
                      ),
                      hintText: '0.00',
                      labelText: 'Amount to deposit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF202020),
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quick select buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [20, 50, 100, 200].map((amt) {
                      return GestureDetector(
                        onTap: () {
                          amountController.text = amt.toString();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '\$$amt',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF202020),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      final amount = double.tryParse(amountController.text) ?? 0.0;
                      if (amount > 0) {
                        setState(() {
                          _balance += amount;
                          _transactions.insert(
                            0,
                            TransactionModel(
                              id: DateTime.now().toString(),
                              merchant:
                                  'Deposit via ${_cards[_selectedCardIndex].cardType}',
                              date: 'Just now',
                              amount: amount,
                              icon: Icons.add_circle_outline_rounded,
                            ),
                          );
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Successfully deposited \$${amount.toStringAsFixed(2)}!',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: const Color(0xFF202020),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF202020),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Confirm Deposit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Background stripes painter for Credit Card
class CardLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double i = -50; i < size.width + 50; i += 45) {
      path.moveTo(i, -20);
      path.lineTo(i + 80, size.height + 20);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
