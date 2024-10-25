import 'package:get/get.dart';
import 'dart:convert';
import '../model/list_category.dart';
import '../service/api_service.dart';


class BestSellerListController extends GetxController {
  var bestSellerLists = <ListCategory>[].obs;
  var isLoading = false.obs;
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchBestSellerCategories();
  }

  Future<void> fetchBestSellerCategories() async {
    try {
      isLoading.value = true;
      final response = await apiService.getBestSellerListNames();
      if (response.statusCode == 200) {
        bestSellerLists.value = parseCategories(response.bodyString!);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ListCategory> parseCategories(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return (parsed['results'] as List)
        .map((data) => ListCategory.fromJson(data))
        .toList();
  }
}
