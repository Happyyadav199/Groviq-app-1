import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class WooApi {
  String get _base => '${AppConfig.baseUrl}/wp-json/wc/v3';
  Map<String, String> get _authQ => {'consumer_key': AppConfig.key, 'consumer_secret': AppConfig.secret};

  Future<List<dynamic>> _get(String path, [Map<String,String>? q]) async {
    final uri = Uri.parse('$_base$path').replace(queryParameters: {..._authQ, ...(q ?? {})});
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<List<dynamic>> categories() => _get('/products/categories', {'per_page':'50','hide_empty':'true'});
  Future<List<dynamic>> products({int perPage=20, int page=1, String? category}) => _get('/products', {'per_page':'$perPage','page':'$page', if(category!=null)'category':category});
  Future<Map<String,dynamic>> createOrder(Map body) async {
    final uri = Uri.parse('$_base/orders').replace(queryParameters: _authQ);
    final res = await http.post(uri, headers: {'Content-Type':'application/json'}, body: jsonEncode(body));
    if (res.statusCode != 201) throw Exception('Order failed: ${res.statusCode} ${res.body}');
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
}
