import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whackiest/model/product.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://10.200.76.53:8080/api/";

  static addProduct(Map data) async {
    print("Sending data: $data");
    var url = Uri.parse("${baseUrl}add");
    try {
      final res = await http.post(url, body: data);
      print("Response status: ${res.statusCode}");
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body.toString());
        print(responseData);
      } else {
        print("Failed with status: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static getProducts() async {
    List<Product> products = [];
    var url = Uri.parse("${baseUrl}get");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        data['products'].forEach((element) {
          products.add(Product(
              name: element['name'],
              price: element['price'],
              image: element['image']));
        });

        return products;
      } else {
        print(res.statusCode);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  
}
