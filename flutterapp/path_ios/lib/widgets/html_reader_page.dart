import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlReaderPage extends StatelessWidget {
  const HtmlReaderPage({super.key, required this.title, required this.html});

  final String title;
  final String html;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Html(data: html),
      ),
    );
  }
}
