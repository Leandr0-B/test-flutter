import 'package:http/http.dart' as http;

class APIService {
  static Future<String> fetchUsers() async {
    const test = 'patatitas';
    print(test);
    final response = await http
        .get(Uri.parse('https://residencialapi.azurewebsites.net/users'));
    print(response);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch users');
    }
  }
}
