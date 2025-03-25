import 'dart:convert';
import 'package:bridgecare/features/auth/domain/models/auth_model.dart';
import 'package:bridgecare/features/user_management/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      "http://localhost:8080/api/auth"; // Temporary backend URL

  /// Logs in the user and stores the JWT token locally
  Future<String?> login(LoginRequest request) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);

        // Save token locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", loginResponse.token);

        return loginResponse.token;
      } else {
        debugPrint("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  /// Logs out the user by removing the stored token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  /// Checks if the user is logged in by verifying if a token exists
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  /// Fetches the logged-in user's details from the backend
  Future<Usuario?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/getUser"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Usuario.fromJson(data);
      } else {
        debugPrint("Failed to fetch user: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    }
  }
}
