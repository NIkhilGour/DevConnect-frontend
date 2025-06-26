import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<Map<dynamic, dynamic>?> login(String email, String password) async {
  try {
    final response = await http.post(
        Uri.parse('https://devconnect-backend-2-0c3c.onrender.com/user/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email, "password": password}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    }

    return null;
  } catch (e) {
    throw Error();
  }
}
