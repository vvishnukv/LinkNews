import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NewsModel.dart';
import 'package:linknews/NewsDetails.dart';

class NewsCard extends StatelessWidget {
  final NewsModel article;

  NewsCard(this.article);

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatDate(article.publishedAt);

    return InkWell(
      onTap: () => _navigateToDetailsPage(context),
      onLongPress: () => _navigateToDetailsPage(context),
      onDoubleTap: () => _navigateToDetailsPage(context),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Published At and course name
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${article.source.name}', // Replace with the actual property name
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Image and content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  article.urlToImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/default.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _launchUrl(article.url),
                        onLongPress: () => _launchUrl(article.url),
                        onDoubleTap: () => _launchUrl(article.url),
                        child: Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationThickness: 0.9, // Set the underline thickness
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        article.description,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black, // Change to the desired text color
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Author: ${article.author}',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue, // Change to the desired text color for the author
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Published At: $formattedDate',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Try to launch using the html package as a fallback
      _launchUrlWithHtmlFallback(url);
    }
  }

  _launchUrlWithHtmlFallback(String url) async {
    try {
      final html = await launch(url, forceWebView: false, enableJavaScript: false);
      final document = parser.parse(html);
      final link = document.querySelector('a');
      final href = link?.attributes['href'];
      if (href != null) {
        await launch(href);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  String _formatDate(String date) {
    try {
      // Parse the date string into a DateTime object
      DateTime parsedDate = DateTime.parse(date);

      // Format the DateTime object into the desired pattern
      String formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle the case where the date string is not in the expected format
      print('Error formatting date: $e');
      return date;
    }
  }
  _navigateToDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsPage(article),
      ),
    );
  }
}
