import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Neobank',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF3F5F5),
          textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.light().textTheme),
        ),
        home: const HomeScreen(),
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  double _bal = 3200.0;
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _tab != 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.hourglass_empty, size: 48, color: Color(0xFF202020)),
                      const SizedBox(height: 16),
                      Text(['', 'Map View', 'Transfer', 'Settings', 'Profile'][_tab],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Coming Soon', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => setState(() => _tab = 0),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF202020), foregroundColor: Colors.white),
                        child: const Text('Back to Home'),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Good morning, Terry',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF202020))),
                                Text('Welcome to Neobank',
                                    style: TextStyle(color: const Color(0xFF202020).withOpacity(0.6), fontSize: 14)),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE2E4E8), width: 1.5),
                                  ),
                                  child: const Icon(Icons.notifications_none, color: Color(0xFF202020), size: 24),
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
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Your balance',
                                      style: TextStyle(color: const Color(0xFF202020).withOpacity(0.6), fontSize: 14)),
                                  IconButton(
                                    icon: Icon(_show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                        color: const Color(0xFF7A7C80)),
                                    onPressed: () => setState(() => _show = !_show),
                                  ),
                                ],
                              ),
                              Text(
                                _show
                                    ? '\$${_bal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                                    : '\$ ••••••',
                                style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF202020)),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _bal += 100.0);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(r'Added $100.00 to your balance!'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF202020), borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                      child: Text('Add money',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Your cards',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF202020))),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add, size: 16, color: Color(0xFF202020)),
                              label: const Text('New card',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF202020))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: PageView(
                            controller: PageController(viewportFraction: 0.85),
                            children: [
                              _card(const Color(0xFFC9F158), 'Debit Card', '4568', true),
                              _card(const Color(0xFF202020), 'Credit card', '2478', false),
                              _card(const Color(0xFFE2E4E8), 'Bank Account', '9012', false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Transactions',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF202020))),
                            TextButton(
                                onPressed: () {},
                                child: const Text('See all',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF202020)))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _tx('Starbucks Coffee', 'October 17, 09:00 PM', '-\$44.80', '+\$1.65', Icons.local_cafe),
                        _tx('Direct Deposit', 'October 15, 08:30 AM', '+\$1,500.00', null, Icons.account_balance_wallet),
                        _tx('Apple Store', 'October 12, 02:15 PM', '-\$999.00', null, Icons.laptop_mac),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF202020).withOpacity(0.04), blurRadius: 16, offset: const Offset(0, -4))
                ],
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nav(0, Icons.home, 'Home'),
                  _nav(1, Icons.map, 'Map'),
                  _nav(2, Icons.swap_horiz, 'Transfer'),
                  _nav(3, Icons.settings, 'Settings'),
                  _nav(4, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Color bg, String type, String num, bool neon) {
    final col = neon ? const Color(0xFF202020) : Colors.white;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('N.', style: TextStyle(color: col, fontSize: 24, fontWeight: FontWeight.w900)),
              SizedBox(
                width: 30,
                height: 20,
                child: Stack(
                  children: [
                    Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
                    Positioned(
                      left: 10,
                      child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(color: const Color(0xFFF79E1B).withOpacity(0.85), shape: BoxShape.circle)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: TextStyle(color: col.withOpacity(0.6), fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('•••• $num', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.bold)),
                  if (neon)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined, size: 14, color: Color(0xFF202020)),
                          SizedBox(width: 4),
                          Text('Details', style: TextStyle(color: Color(0xFF202020), fontSize: 11, fontWeight: FontWeight.bold)),
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
  }

  Widget _tx(String title, String date, String amt, String? cb, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: const Color(0xFF202020), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF202020))),
                Text(date, style: TextStyle(color: const Color(0xFF202020).withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amt, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF202020))),
              if (cb != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFC9F158).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(cb, style: const TextStyle(color: Color(0xFF7CA018), fontWeight: FontWeight.bold, fontSize: 10)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nav(int index, IconData icon, String label) {
    final sel = _tab == index;
    final col = sel ? const Color(0xFF202020) : const Color(0xFF7A7C80);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: col, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: col, fontSize: 11, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
