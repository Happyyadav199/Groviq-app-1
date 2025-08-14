class Product {
  final int id; final String name; final String? image; final String price;
  Product({required this.id, required this.name, this.image, required this.price});
  factory Product.fromJson(Map<String,dynamic> j) => Product(
    id: j['id'], name: j['name'] ?? '', image: (j['images'] is List && j['images'].isNotEmpty)? j['images'][0]['src'] : null, price: j['price']?.toString() ?? '0'
  );
}
