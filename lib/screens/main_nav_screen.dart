import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'admin_dashboard.dart';
import 'gateman_screen.dart';
import 'gateman_history_screen.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainContent();
  }
}

class _MainContent extends StatefulWidget {
  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().role;
    List<Widget> screens = [];
    List<BottomNavigationBarItem> items = [];

    if (role == 'admin') {
      // Admin View
      screens = [const AdminDashboard()];
      items = []; // No bottom bar for Admin (single screen)
    } else if (role == 'gateman') {
      // Gateman View
      screens = [const GatemanScreen(), const GatemanHistoryScreen()];
      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Scanner'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      ];
    } else {
      // Fallback / Student (Restricted)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text("Access Restricted", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.read<AuthProvider>().logout(),
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: screens.isNotEmpty ? screens[_idx] : const SizedBox(),
      bottomNavigationBar: items.isNotEmpty
          ? BottomNavigationBar(
              currentIndex: _idx,
              onTap: (i) => setState(() => _idx = i),
              selectedItemColor: AppColors.primaryRed,
              items: items,
            )
          : null,
    );
  }
}
