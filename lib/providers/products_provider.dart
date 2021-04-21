import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_shop/models/http_exceptions.dart';
import 'dart:convert';

import 'package:max_shop/providers/product_provider.dart';

class Products with ChangeNotifier {
  Uri _url = Uri.parse(
      'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products.json');

  List<Product> _items = [];

  Products() : super() {
    // _fetchAndSetProducts();
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(_url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
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
    try {
      final response = await http.post(
        _url,
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
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json');

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

  void deleteProduct(String productId) {
    final url = Uri.parse(
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json');

    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProductIndex];

    // "optimistic updating" i.e. not waiting for the action to complete
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        // throwing exception here calls the catchError and skips next code here in this block
        throw HttpException('Could not delete product!');
      }

      // release memory
      existingProduct = null;
    }).catchError((_) {
      // reload the deleted product if any server error
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });

    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}
