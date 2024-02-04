import 'package:flutter/material.dart';
import 'NewsModel.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as parser;

class NewsDetailsPage extends StatelessWidget {
  final NewsModel article;

  NewsDetailsPage(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Image.network(
              article.urlToImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              'Published At: ${_formatDate(article.publishedAt)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
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
              article.content,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Author: ${article.author}',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      String formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(parsedDate);
      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return date;
    }
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
}
