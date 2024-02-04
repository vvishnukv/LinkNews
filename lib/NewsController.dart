import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;  // Import the http package
import 'NewsModel.dart';

class NewsController extends GetxController {
  RxList<NewsModel> articles = <NewsModel>[].obs;
  bool ascendingOrder = true;
  late http.Client httpClient;  // Declare an instance of http.Client

  @override
  void onInit() {
    super.onInit();
    httpClient = http.Client();  // Initialize the http.Client in onInit
    fetchData();
  }

  @override
  void onClose() {
    httpClient.close();  // Close the http.Client in onClose to avoid leaks
    super.onClose();
  }

  Future<void> fetchData() async {
    try {
      final response = await httpClient.get(Uri.parse(
          'https://candidate-test-data-moengage.s3.amazonaws.com/Android/news-api-feed/staticResponse.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articlesData = data['articles'];
        articles.assignAll(
          articlesData.map((article) => NewsModel.fromJson(article)).toList(),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void sortByDate({required bool ascending}) {
    articles.sort((a, b) {
      DateTime dateA = DateTime.parse(a.publishedAt);
      DateTime dateB = DateTime.parse(b.publishedAt);
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
  }

  void toggleSortOrder() {
    ascendingOrder = !ascendingOrder;
    sortByDate(ascending: ascendingOrder);
  }
}
