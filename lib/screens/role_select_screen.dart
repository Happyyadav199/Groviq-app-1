import 'package:flutter/material.dart';
import 'customer/home_screen.dart';
import 'rider/rider_home.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});
  @override State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _goCustomer() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _goRider() {
    final id = _idController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter Rider ID (phone/email)')));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => RiderHome(riderId: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groviq — Choose Role', style: TextStyle(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ElevatedButton.icon(onPressed: _goCustomer, icon: const Icon(Icons.shopping_bag), label: const Text('Continue as Customer')),
          const SizedBox(height: 24),
          const Text('Delivery Rider? Enter your Rider ID (phone/email)'),
          TextField(controller: _idController, decoration: const InputDecoration(labelText: 'Rider ID')),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: _goRider, icon: const Icon(Icons.motorcycle), label: const Text('Continue as Rider')),
        ]),
      ),
    );
  }
}
