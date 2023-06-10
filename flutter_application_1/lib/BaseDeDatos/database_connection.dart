import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  static Future<String> fetchUsers() async {
    final url =
        Uri.parse('https://residencialapi.azurewebsites.net/usuario/list');

    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGVjayI6dHJ1ZSwiaWF0IjoxNjg2MzY0MTg3LCJleHAiOjE2ODY0MDczODd9.vxrvcp4iNmD4-Y46cGRZNIMkGJAST_W77M9B6VcZlrk'
      },
    );

    print(response);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<String> fetchAuthToken(String ci, String password) async {
    final url = Uri.parse('https://residencialapi.azurewebsites.net/login');

    final response = await http.post(
      url,
      body: jsonEncode({'ci': ci, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'] as String;
      return token;
    } else {
      throw Exception('Failed to fetch authorization token');
    }
  }

  static Future<String> fetchUserInfo(String token) async {
    final url =
        Uri.parse('https://residencialapi.azurewebsites.net/usuario/info');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch user info');
    }
  }
}
