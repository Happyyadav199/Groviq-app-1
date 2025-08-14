import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
class DeliveryApi {
  String get base => AppConfig.baseUrl;
  String get key => AppConfig.key;
  String get secret => AppConfig.secret;
  Future<List<dynamic>> fetchAssignedOrders(String riderId) async {
    final uri = Uri.parse('\$base/wp-json/wc/v3/orders').replace(queryParameters: {
      'consumer_key': key, 'consumer_secret': secret, 'status':'processing,on-hold', 'per_page':'50'
    });
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Orders fetch failed: ${res.statusCode}');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.where((o)=> (o['meta_data'] as List).any((m)=> m['key']=='rider_assigned' && m['value']==riderId)).toList();
  }
}
