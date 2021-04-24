import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_shop/models/http_exceptions.dart';
import 'dart:convert';

import 'package:max_shop/providers/product_provider.dart';

class Products with ChangeNotifier {
  final String authToken;

  List<Product> _items = [];

  Products(this.authToken, this._items) : super() {
    // _fetchAndSetProducts();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<Product> loadedProducts = [];

      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavourite: productData['isFavourite'],
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> addProduct(Product p) async {
    final url = Uri.parse(
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
          'isFavourite': p.isFavourite,
        }),
      );

      final addedProduct = json.decode(response.body);

      final newProduct = Product(
        title: p.title,
        description: p.description,
        price: p.price,
        imageUrl: p.imageUrl,
        id: addedProduct['name'],
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; // throw error to handle at the
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final url = Uri.parse(
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');

    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );

      final prodIndex = _items.indexWhere((product) => product.id == productId);
      _items[prodIndex] = newProduct;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');

    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // reload the deleted product if any server error
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException('Could not delete product!');
    }

    // release memory
    existingProduct = null;
  }
}
