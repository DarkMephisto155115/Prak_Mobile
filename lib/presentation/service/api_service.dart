import 'package:get/get.dart';

class ApiService extends GetConnect {
  Future<Response> getBestSellerListNames() async {
    final apiKey = 'ba2JAYrIZmG54KxxBiMvK57oVWtrNGBu';
    final url =
        'https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=$apiKey';
    return get(url);
  }
}
