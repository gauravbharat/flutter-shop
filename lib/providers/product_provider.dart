import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:max_shop/models/http_exceptions.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _rollbackFavouriteUpdate(bool existingFavouriteStatus) {
    isFavourite = existingFavouriteStatus;
    notifyListeners();
    throw HttpException('Error updating favourite status!');
  }

  Future<void> toggleFavouriteStatus(
    String productId,
    String token,
    String userId,
  ) async {
    final url = Uri.parse(
        'https://garyd-max-shop-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$userId/$productId.json?auth=$token');

    var existingFavouriteStatus = isFavourite;

    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );

      if (response.statusCode >= 400) {
        //rollback
        _rollbackFavouriteUpdate(existingFavouriteStatus);
      }
    } catch (error) {
      _rollbackFavouriteUpdate(existingFavouriteStatus);
    }

    existingFavouriteStatus = null;
  }
}
