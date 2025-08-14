import 'package:flutter/material.dart';
import '../api/woocommerce_api.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductListScreen extends StatefulWidget { const ProductListScreen({super.key}); @override State<ProductListScreen> createState()=> _ProductListScreenState(); }
class _ProductListScreenState extends State<ProductListScreen>{
  final api = WooApi(); List<Product> items=[]; bool loading=true;
  @override void initState(){ super.initState(); _load(); }
  Future<void> _load() async { final res = await api.products(perPage:50); items = res.map((e)=> Product.fromJson(e)).toList().cast<Product>(); setState(()=> loading=false); }
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Products', style: TextStyle(color: Colors.black))), body: loading? const Center(child:CircularProgressIndicator()) : ListView.builder(itemCount: items.length, itemBuilder: (_,i){ final p=items[i]; return ListTile(leading: p.image!=null? Image.network(p.image!,width:56,height:56,fit:BoxFit.cover):null,title: Text(p.name),subtitle: Text('₹${p.price}'), trailing: ElevatedButton(onPressed: ()=> context.read<CartProvider>().add(p), child: const Text('Add'))); }));
