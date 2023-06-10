import 'package:http/http.dart' as http;

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
}
