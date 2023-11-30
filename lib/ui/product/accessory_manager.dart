import 'package:flutter/foundation.dart';
import 'package:photocopy/model/accessory_model.dart';
import '../../service/accessory_service.dart';

class AccessoryManager with ChangeNotifier {
  final AccessoryService accessoryService = AccessoryService();
  List<AccessoryModel> _items = [] ;

  List<AccessoryModel> get products {
    return [..._items];
  }

  Future fetchproducts() async {
    _items  = (await accessoryService.getAll())!;
    notifyListeners();
  }

  
  int get itemAcount {
    return _items.length;
  }

  AccessoryModel? findById(String id) {
    try {
      return _items.firstWhere((product) => product.id == id);
    } catch (err) {
      return null;
    }
  }

  Future findByIdBrand(String brandId) async {
    try {
      _items = (await accessoryService.getByBrandId(brandId))!;
      notifyListeners();
    } catch (err) {
      return;
    }
  }
}
