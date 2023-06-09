import 'package:http/http.dart' as http;

class APIService {
  static Future<String> fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://residencialapi.azurewebsites.net/users/list'));
    print(response);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch users');
    }
  }
}
