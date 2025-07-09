import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:hive/hive.dart';
import 'package:myshop/helper/SnackBarHelper.dart';
import 'package:myshop/httpServices/httpService.dart';
import 'package:myshop/model/productsHiveAdapter.dart';
import 'package:myshop/model/productsList.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';


class AllDataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  // **** Hive Box
  final Box<ProductsHive> _productsBox;

  // **** Variables
  bool _isOnline = true;
  bool _showOfflineBanner = false;

  bool get isOnline => _isOnline;
  bool get showOfflineBanner => _showOfflineBanner;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Products> _allProduct = [];
  List<Products> _filteredProducts = [];
  List<Products> get products => _filteredProducts;

  AllDataProvider(this._productsBox) {
     init();
  }


Future<void> init() async {

    // ******** for check connectivity
   await _checkConnectivity();
    
    // ***** Load cached data firstly
    await _loadCachedProducts();
    // ***********Then we will try to fetch fresh data
    await fetchProducts();
  }


  Future<void> _checkConnectivity() async {

    //***** */ Initial connectivity check
    
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = !connectivityResult.contains(ConnectivityResult.none);
    _showOfflineBanner = !_isOnline;
    notifyListeners();
      Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      bool wasOnline = _isOnline;
      _isOnline = !result.contains(ConnectivityResult.none);
      _showOfflineBanner = !_isOnline;
      notifyListeners();

      if (_isOnline && !wasOnline) {
        await fetchProducts(showSnack: true); // fetch fresh and store in Hive
      }
    });
  }

  Future<void> _loadCachedProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final cachedProducts = _productsBox.values.toList();
      if (cachedProducts.isNotEmpty) {
        _allProduct = cachedProducts.map((e) => e.toProducts()).toList();
        _filteredProducts = List.from(_allProduct);
      }
    } catch (e) {
      debugPrint("Error loading cached products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cacheProducts(List<Products> products) async {
    try {
      await _productsBox.clear();
      
      for (final product in products) {
        await _productsBox.add(ProductsHive.fromProducts(product));
      }
    } catch (e) {
      debugPrint("Error caching products: $e");
    }
  }


  Future<List<Products>> fetchProducts({bool showSnack = false}) async {

    if (_isOnline == false) {
    _showOfflineBanner = true;
    await _loadCachedProducts();
    notifyListeners();
    return _filteredProducts;
  }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Response response = await service.getItems(endpointUrl: 'products');

      if (response.isOk) {
        _allProduct = (response.body as List)
            .map((json) => Products.fromJson(json))
            .toList();
        _filteredProducts = List.from(_allProduct);
        // ********** Caching fresh data
         await _cacheProducts(_allProduct);
        _showOfflineBanner = false;

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar("Products fetched successfully");
        }
      } else {
        _errorMessage = "Failed to fetch products: ${response.statusText}";
        if (showSnack) {
          SnackBarHelper.showErrorSnackBar(_errorMessage!);
        }
      }
    } catch (e) {
      _errorMessage = "Error fetching products: ${e.toString()}";
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(_errorMessage!);
      }
      debugPrint("Error in fetchProducts: $e");

      if (_allProduct.isNotEmpty) {
        _showOfflineBanner = true;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  


   

    return _filteredProducts;
  }



  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_allProduct);
    } else {
      _filteredProducts = _allProduct.where((product) {
        return product.title?.toLowerCase().contains(query.toLowerCase()) == true ||
              product.category?.toLowerCase().contains(query.toLowerCase()) == true;
      }).toList();
    }
    notifyListeners();
  }



Future<Products?> fetchSingleProduct({
  required String productId,
  bool showSnack = false,
}) async {
  if (!_isOnline) {
    _showOfflineBanner = true;

    try {
     final localProduct = _productsBox.values.firstWhereOrNull(
        (item) => item.id.toString() == productId,
      );

      if (localProduct != null) {
        return localProduct.toProducts();
      } else {
        _errorMessage = "Product not found in offline cache";
        debugPrint(_errorMessage);
        return null;
      }
    } catch (e) {
      _errorMessage = "Error loading product from cache: ${e.toString()}";
      debugPrint(_errorMessage);
      return null;
    }
  }

  _isLoading = true;
  _errorMessage = null;

  try {
    Response response = await service.getItems(endpointUrl: 'products/$productId');

    if (response.isOk) {
      final product = Products.fromJson(response.body as Map<String, dynamic>);
      
      _showOfflineBanner = false;

      if (showSnack) {
        SnackBarHelper.showSuccessSnackBar( "Product fetched successfully");
      }
      return product;
    } else {
      _errorMessage = "Failed to fetch product: ${response.statusText}";
      
        SnackBarHelper.showErrorSnackBar(_errorMessage!);
      
    }
  } catch (e) {
    _errorMessage = "Error fetching product: ${e.toString()}";
    
      SnackBarHelper.showErrorSnackBar(_errorMessage!);
    
  } finally {
    _isLoading = false;
    notifyListeners();
  }

  return null;
}


}
