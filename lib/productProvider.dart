import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testapp/product.dart';

class ProductProvider with ChangeNotifier {
  List<String>? _categoryList;
  List<Product>? _productList;

  List<Product>? get getProducts => _productList;

  List<String>? get getCategories => _categoryList;

  //load from the asset and parse it into product type
  Future<void> loadAndParse(BuildContext context) async {
    try {
      final loadedInfo =
          await DefaultAssetBundle.of(context).loadString("assets/sample.json");
      //decode
      List data = json.decode(loadedInfo);
      List<Product> result = [];
      List<String> catList = [];
      data.forEach((info) {
        var product = Product.fromJson(info);
        result.add(product);
      });

      //get the category
      result.forEach((pr) {
        if (!catList.contains(pr.category)) {
          catList.add(pr.category);
        }
      });

      print(result);
      print(catList);

      _categoryList = catList;
      _productList = result;
      notifyListeners();

      // print(data);
    } catch (error) {
      throw error;
    }
  }
}
