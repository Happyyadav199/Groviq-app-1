import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/woocommerce_api.dart';
import '../providers/cart_provider.dart';
import '../screens/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget { const CheckoutScreen({super.key}); @override State<CheckoutScreen> createState()=> _CheckoutScreenState(); }
class _CheckoutScreenState extends State<CheckoutScreen>{
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final api = WooApi();
  bool loading=false;
  @override void dispose(){ _name.dispose(); _phone.dispose(); _address.dispose(); super.dispose(); }
  Future<void> _placeOrder() async {
    if(!_form.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    setState(()=> loading=true);
    try {
      final billing = {'first_name': _name.text.trim(), 'email':'', 'phone': _phone.text.trim(), 'address_1': _address.text.trim(), 'city':'', 'country':'IN'};
      final shipping = Map<String,dynamic>.from(billing);
      final body = {'payment_method':'cod','payment_method_title':'Cash on delivery','set_paid':false,'billing': billing,'shipping': shipping,'line_items': cart.toOrderLineItems()};
      final order = await api.createOrder(body);
      cart.clear();
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: order['id'].toString())));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order failed: $e')));
    } finally { if(mounted) setState(()=> loading=false); }
  }
  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: const Text('Checkout', style: TextStyle(color: Colors.black))), body: Padding(padding: const EdgeInsets.all(16), child: Form(key: _form, child: ListView(children: [
    TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v)=> v==null||v.trim().isEmpty? 'Enter name':null),
    TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'), validator: (v)=> v==null||v.trim().length<6? 'Enter phone':null),
    TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address'), validator: (v)=> v==null||v.trim().isEmpty? 'Enter address':null),
    const SizedBox(height:12),
    loading? const Center(child:CircularProgressIndicator()) : ElevatedButton(onPressed: _placeOrder, child: const Text('Place Order (COD)'))
  ]))));
}
