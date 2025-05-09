// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ta_c14210052/constant/api_url.dart';

class AuthService {
  static const String baseUrl = "$responseUrl/api"; // Ganti sesuai API Anda

  static Future<bool> sendResetEmail(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/forgot-password"),
      body: {"email": email},
    );
    return response.statusCode == 200;
  }

  static Future<bool> verifyOtp(String email, String code) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/verify-code"),
      body: {"email": email, "code": code},
    );
    return response.statusCode == 200;
  }

  static Future<bool> resetPassword(
      String email, String newPassword, String confirmPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/reset-password"),
      body: {
        "email": email,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> resendOtp(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/forgot-password"),
      body: {"email": email},
    );
    return response.statusCode == 200;
  }
}
