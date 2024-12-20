import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jaket_mobile/app_module/data/model/user_check.dart';
import 'dart:convert';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  final CookieRequest request;
  List<ProductEntry> _favoriteProducts = [];

  AuthController({required this.request}) {
    initialize();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  List<ProductEntry> get favoriteProducts => _favoriteProducts;

  Future<void> initialize() async {
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final response = await request.get('http://10.0.2.2:8000/authenticate/check_login/');
    if (response['status'] == true && response['username'] != null) {
      _isLoggedIn = true;
      _username = response['username'];

      final url = "http://10.0.2.2:8000/wishlist/wish_json/";
      final responseFav = await request.get(url);
      if (responseFav is Map && responseFav.containsKey('data')) {
        final data = responseFav['data'] as List;
        _favoriteProducts = data.map((item) => ProductEntry.fromJson(item)).toList();
      } else if (responseFav is List) {
        _favoriteProducts = responseFav.map((item) => ProductEntry.fromJson(item)).toList();
      } else {
        _favoriteProducts = [];
      }
    } else {
      _isLoggedIn = false;
      _username = '';
      _favoriteProducts = [];
    }
    notifyListeners();
  }

  Future<void> register(String inputUsername, String password1, String password2) async {
    final url = "http://10.0.2.2:8000/authenticate/register_app/";
    final data = {
      'username': inputUsername,
      'password1': password1,
      'password2': password2,
    };

    final response = await request.postJson(url, jsonEncode(data));

    if (response['status'] == true) {
      _isLoggedIn = true;
      _username = response['username'];
      await checkLoginStatus();
    } else {
      _isLoggedIn = false;
      _username = '';
      _favoriteProducts = [];
    }
    notifyListeners();
  }

  Future<UserResponse> login(String inputUsername, String password) async {
    final url = "http://10.0.2.2:8000/authenticate/login_app/";
    final data = {
      'username': inputUsername,
      'password': password,
    };

    final response = await request.login(url, data);

    if (request.loggedIn) {
      _isLoggedIn = true;
      _username = response['username'] ?? inputUsername;
      await checkLoginStatus(); 
    } else {
      _isLoggedIn = false;
      _username = '';
      _favoriteProducts = [];
    }

    notifyListeners();
    return UserResponse.fromJson(response);
  }

  Future<UserResponse> logout() async {
    final url = "http://10.0.2.2:8000/authenticate/logout_app/";
    final response = await request.logout(url);

    if (response['status'] == true) {
      _isLoggedIn = false;
      _username = '';
      _favoriteProducts = [];
    }

    notifyListeners();
    return UserResponse.fromJson(response);
  }

  Future<bool> addToFavorites(String phoneId) async {
    if (!_isLoggedIn) {
      return false;
    }

    final url = "http://10.0.2.2:8000/wishlist/add_to_favorite_flutter/";
    final data = {
      'phone_id': phoneId,
    };

    final response = await request.postJson(url, jsonEncode(data));

    if (response['status'] == "success" || response['status'] == "info") {
      await checkLoginStatus(); 
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeFromFavorites(String phoneId) async {
    if (!_isLoggedIn) {
      return false;
    }

    final url = "http://10.0.2.2:8000/wishlist/remove_from_favorite_flutter/";
    final data = {
      'phone_id': phoneId,
    };

    final response = await request.postJson(url, jsonEncode(data));

    if (response['status'] == "success" || response['status'] == "info") {
      await checkLoginStatus();
      return true;
    } else {
      return false;
    }
  }

  bool isProductFavorite(String phoneId) {
    return _favoriteProducts.any((product) => product.pk == phoneId);
  }

  Future<List<Review>> fetchReviews(String productId) async {
    if (!_isLoggedIn) {
      throw Exception('Anda harus login untuk melihat ulasan.');
    }

    final url = "http://10.0.2.2:8000/detail/list_review/$productId/";
    final response = await request.get(url);

    if (response['status'] == 'success') {
      List<dynamic> reviewsJson = response['reviews'];
      return reviewsJson.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat ulasan.');
    }
  }

  Future<bool> addReview(String productId, String content, int rating) async {
    final url = "http://10.0.2.2:8000/detail/create_review_flutter/";
    final data = {
      'product_id': productId,
      'content': content,
      'rating': rating.toString(),
    };


    final jsonData = jsonEncode(data);

    final response = await request.postJson(url, jsonData);

    if (response['status'] == 'success') {
      return true;
    } else {
      throw Exception(response['message'] ?? 'Gagal menambahkan ulasan.');
    }
  }

  Future<bool> editReview(int reviewId, {String? content, int? rating}) async {
    final url = "http://10.0.2.2:8000/detail/edit_review_flutter/$reviewId/";
    Map<String, dynamic> data = {};

    if (content != null) {
      data['content'] = content;
    }
    if (rating != null) {
      data['rating'] = rating.toString();
    }

    if (data.isEmpty) {
      throw Exception('Tidak ada data yang diubah.');
    }

    final jsonData = jsonEncode(data);

    final response = await request.postJson(url, jsonData);

    if (response['status'] == 'success') {
      return true;
    } else {
      throw Exception(response['message'] ?? 'Gagal mengedit ulasan.');
    }
  }

  Future<bool> deleteReview(int reviewId) async {
    if (!_isLoggedIn) {
      throw Exception('Anda harus login untuk menghapus ulasan.');
    }

    final url = "http://10.0.2.2:8000/detail/delete_review_flutter/$reviewId/";
    final response = await request.postJson(url, jsonEncode({}));

    if (response['status'] == 'success') {
      return true;
    } else {
      throw Exception(response['message'] ?? 'Gagal menghapus ulasan.');
    }
  }
}
