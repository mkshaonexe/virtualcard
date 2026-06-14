import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  double _balance = 3200.00;
  bool _isBalanceVisible = true;

  // Simple card data represented as Maps to keep code clean and lightweight
  final List<Map<String, dynamic>> _cards = [
    {
      'number': '4568',
      'type': 'Debit Card',
      'color': const Color(0xFFC9F158),
      'isNeon': true,
    },
    {
      'number': '2478',
      'type': 'Credit card',
      'color': const Color(0xFF202020),
      'isNeon': false,
    },
    {
      'number': '9012',
      'type': 'Bank Account',
      'color': const Color(0xFFE2E4E8),
      'isNeon': false,
    },
  ];

  // Transaction list represented as Maps
  final List<Map<String, dynamic>> _transactions = [
    {
      'merchant': 'Starbucks Coffee',
      'date': 'October 17, 09:00 PM',
      'amount': -44.80,
      'cashback': r'+$1.65',
      'icon': Icons.local_cafe_rounded,
    },
    {
      'merchant': 'Direct Deposit',
      'date': 'October 15, 08:30 AM',
      'amount': 1500.00,
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'merchant': 'Apple Store',
      'date': 'October 12, 02:15 PM',
      'amount': -999.00,
      'icon': Icons.laptop_mac_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Switch between Dashboard and Coming Soon view
          _currentIndex == 0 ? _buildDashboard() : _buildComingSoon(),
          // Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  // Dashboard / Home Tab
  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Greeting and Notification Bell
            Row(
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
                _buildNotificationBell(),
              ],
            ),
            const SizedBox(height: 24),

            // Balance Card with show/hide functionality
            Container(
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
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF7A7C80),
                        ),
                        onPressed: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                      ),
                    ],
                  ),
                  Text(
                    _isBalanceVisible
                        ? '\$${_balance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                        : '\$ ••••••',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showAddMoneySheet,
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
            ),
            const SizedBox(height: 32),

            // Your Cards Section
            Row(
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
            ),
            const SizedBox(height: 16),

            // Swipable Cards Carousel
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  final isNeon = card['isNeon'] as bool;
                  final textColor = isNeon ? const Color(0xFF202020) : Colors.white;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: card['color'] as Color,
                      borderRadius: BorderRadius.circular(24),
                    ),
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
                              card['type'] as String,
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '•••• ${card['number']}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Transactions Section
            Row(
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
            ),
            const SizedBox(height: 16),

            // Transactions list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                final isNegative = (tx['amount'] as double) < 0;
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
                        child: Icon(
                          tx['icon'] as IconData,
                          color: const Color(0xFF202020),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx['merchant'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF202020),
                              ),
                            ),
                            Text(
                              tx['date'] as String,
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
                            '${isNegative ? '-' : '+'}\$${(tx['amount'] as double).abs().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF202020),
                            ),
                          ),
                          if (tx['cashback'] != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC9F158).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tx['cashback'] as String,
                                style: const TextStyle(
                                  color: Color(0xFF7CA018),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Floating Custom Navigation Bar
  Widget _buildBottomNav() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF202020).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_filled, 'Home'),
          _buildNavItem(1, Icons.map_outlined, 'Map'),
          _buildNavItem(2, Icons.swap_horizontal_circle_outlined, 'Transfer'),
          _buildNavItem(3, Icons.settings_outlined, 'Settings'),
          _buildNavItem(4, Icons.person_outline_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF202020) : const Color(0xFF7A7C80);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generic Coming Soon Screen
  Widget _buildComingSoon() {
    final names = {1: 'Map View', 2: 'Transfer', 3: 'Settings', 4: 'Profile'};
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
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
            const Icon(Icons.hourglass_empty_rounded, color: Color(0xFF202020), size: 48),
            const SizedBox(height: 16),
            Text(
              names[_currentIndex] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Coming Soon', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _currentIndex = 0),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF202020),
                foregroundColor: Colors.white,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  // Simple Add Money Modal Sheet
  void _showAddMoneySheet() {
    final controller = TextEditingController(text: '50');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Money',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '\$ ',
                labelText: 'Amount to add',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text) ?? 0;
                if (val > 0) {
                  setState(() {
                    _balance += val;
                    _transactions.insert(0, {
                      'merchant': 'Deposit',
                      'date': 'Just now',
                      'amount': val,
                      'icon': Icons.add_circle_outline_rounded,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF202020),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  // Custom UI elements
  Widget _buildNotificationBell() {
    return Stack(
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
    );
  }

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
}
