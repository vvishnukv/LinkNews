import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'NewsCard.dart';
import 'NewsController.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            Image.asset(
              'assets/default.png', // Replace with your app icon path
              height: 45, // Adjust the height as needed
              width: 45, // Adjust the width as needed
            ),
            SizedBox(width: 8), // Add some space between the icon and text
            // App name
            Text(
              'LinkNews',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20, // Adjust the font size as needed
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Add sorting buttons
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Toggle the sorting order
              NewsController controller = Get.find<NewsController>();
              controller.toggleSortOrder();
            },
          ),
        ],
      ),
      body: GetBuilder<NewsController>(
        builder: (controller) => Obx(
              () => controller.articles.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              return NewsCard(controller.articles[index]);
            },
          ),
        ),
      ),
    );
  }
}

