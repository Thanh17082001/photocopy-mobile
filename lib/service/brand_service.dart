import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/brand_model.dart';

class BrandService {
  Future<List<BrandModel>?> fetchAll() async {
    final List<BrandModel> brands = [];
    const String ipDevice = "10.0.2.2";
    try {
      final url = Uri.parse("http://$ipDevice:3000/brand/");
      final response = await http.get(url);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        return [];
      } else {
        result.forEach((brand) {
          brands.add(BrandModel.fromJson(brand));
        });
      }

      return brands;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
