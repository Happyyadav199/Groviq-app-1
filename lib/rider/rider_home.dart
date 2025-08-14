import 'package:flutter/material.dart';
import '../api/delivery_api.dart';

class RiderHome extends StatefulWidget {
  final String riderId;
  const RiderHome({super.key, required this.riderId});
  @override State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  final api = DeliveryApi();
  List orders = [];
  bool loading = false;

  Future<void> load() async {
    setState(()=> loading=true);
    try {
      orders = await api.fetchAssignedOrders(widget.riderId);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally { if (mounted) setState(()=> loading=false); }
  }

  @override
  void initState() { super.initState(); }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: const Text('Groviq Rider', style: TextStyle(color: Colors.black))),
    body: Padding(padding: const EdgeInsets.all(12), child: Column(children:[
      ElevatedButton(onPressed: load, child: const Text('Load Assigned Orders')),
      const SizedBox(height:8),
      Expanded(child: loading? const Center(child:CircularProgressIndicator()) : ListView.builder(itemCount: orders.length, itemBuilder: (_,i){
        final o = orders[i];
        return ListTile(title: Text('Order #${o['id']}'), subtitle: Text('Status: ${o['status']}'), trailing: ElevatedButton(onPressed: (){}, child: const Text('Accept')));
      }))
    ])),
  );
}
