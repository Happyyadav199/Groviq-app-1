import 'package:flutter/material.dart';
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Order Placed', style: TextStyle(color: Colors.black))), body: Center(child: Column(mainAxisSize: MainAxisSize.min, children:[
    const Icon(Icons.check_circle, size: 88), const SizedBox(height:12),
    Text('Thank you! Order #$orderId'),
    const SizedBox(height:12),
    ElevatedButton(onPressed: ()=> Navigator.popUntil(c, (route)=> route.isFirst), child: const Text('Back to Home'))
  ])));
}
