import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


String fixBlogImageUrl(String? apiUrl) {
  if (apiUrl == null || apiUrl.isEmpty) {
    // fallback image
    return "https://via.placeholder.com/300x160.png?text=No+Image";
  }

  // Extract only the filename (last part after '/')
  final filename = apiUrl.split('/').last;

  // Combine with correct base URL
  return "https://partynuptual.com/public/uploads/blogs/$filename";
}
class BlogcompleteScreen extends StatelessWidget {
  const BlogcompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments ?? {};

    final String image = args['image'] ?? '';
    final String title = args['title'] ?? '';
    final String description = args['description'] ?? '';
    final String date = args['date'] ?? '';
    final String author = args['author'] ?? '';
    final String tag = args['tag'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  if (image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        fixBlogImageUrl(image),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const SizedBox(height: 200),
                      ),
                    ),

                  const SizedBox(height: 12),

                  /// TAG
                  if (tag.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// AUTHOR + DATE
                  Row(
                    children: [
                      if (author.isNotEmpty)
                        Text(
                          "By ${author}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (author.isNotEmpty && date.isNotEmpty)
                        const SizedBox(width: 8),
                      if (date.isNotEmpty)
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// 🔥 HTML DESCRIPTION (CMS SAFE)
                  HtmlWidget(
                    description,
                    textStyle: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                    onTapUrl: (url) {
                      // You can open URL with url_launcher here
                      return true;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// FOOTER
            BottomSection(),
          ],
        ),
      ),
    );
  }
}
