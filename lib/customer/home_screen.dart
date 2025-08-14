import 'package:flutter/material.dart';
import '../api/woocommerce_api.dart';
import '../models/product.dart';
import 'product_list_screen.dart';
import '../cart/cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=> _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen>{
  final api = WooApi(); List<Product> popular=[]; bool loading=true;
  @override void initState(){ super.initState(); _load(); }
  Future<void> _load() async { try { final p = await api.products(perPage:12); popular = p.map((e)=> Product.fromJson(e)).toList().cast<Product>(); } catch(e){} setState(()=> loading=false); }
  @override Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: const Text('Groviq', style: TextStyle(color: Colors.black))),
    body: loading? const Center(child:CircularProgressIndicator()) : GridView.builder(
      padding: const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, childAspectRatio:.72, mainAxisSpacing:10, crossAxisSpacing:10),
      itemCount: popular.length,
      itemBuilder: (_,i){ final p=popular[i]; return Card(child: Column(children:[ Expanded(child: p.image!=null? Image.network(p.image!,fit:BoxFit.cover):const SizedBox()), Padding(padding:const EdgeInsets.all(8), child: Column(children:[ Text(p.name,maxLines:2,overflow:TextOverflow.ellipsis), Text('₹${p.price}'), ElevatedButton(onPressed: ()=> context.read<CartProvider>().add(p), child: const Text('Add'))]))])); }
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.shopping_cart),
      onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
    ),
  );
}
