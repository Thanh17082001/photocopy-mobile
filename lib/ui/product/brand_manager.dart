import 'package:flutter/foundation.dart';
import 'package:photocopy/model/brand_model.dart';
import '../../service/brand_service.dart';

class BrandManager with ChangeNotifier {
  final BrandService brandService = BrandService();
  List<BrandModel> _items = [];

  List<BrandModel> get brands {
    return [..._items];
  }

  Future fetchBrands() async {
    _items = (await brandService.fetchAll())!;
    notifyListeners();
  }

  int get itemAcount {
    return _items.length;
  }

  BrandModel findById(String id) {
    try {
      fetchBrands();
      print(id);
      return _items.firstWhere((brand) => brand.id == id);
    } catch (err) {
      return BrandModel();
    }
  }
}
