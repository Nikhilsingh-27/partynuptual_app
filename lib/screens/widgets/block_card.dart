import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/blogcomplete_screen.dart';

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

String htmlToPreviewText(String html) {
  return html
      // remove tables completely
      .replaceAll(RegExp(r'<table[\s\S]*?</table>', caseSensitive: false), '')
      // remove all HTML tags
      .replaceAll(RegExp(r'<[^>]+>'), '')
      // decode common HTML entities
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&rsquo;', "'")
      .replaceAll('&lsquo;', "'")
      .replaceAll('&rdquo;', '"')
      .replaceAll('&ldquo;', '"')
      .replaceAll('&mdash;', '-')
      .replaceAll('&ndash;', '-')
      .replaceAll('&hellip;', '...')
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&')
      // remove extra whitespace & newlines
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

Widget buildBlogCard({
  required String image,
  required String title,
  required String description,
  required String date,
  required String tag,
  required String author,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Image.network(
            fixBlogImageUrl(image),
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        /// CONTENT
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE (responsive)
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              /// DESCRIPTION
              SizedBox(
                height: 65,
                child: Text(
                  htmlToPreviewText(description),
                  maxLines: 4, // 🔥 exact control
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// BUTTON (auto-fit text)
              SizedBox(
                width: 120,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => BlogcompleteScreen(),
                      arguments: {
                        'image': image,
                        'title': title,
                        'description': description,
                        'date': date,
                        'author': author,
                        'tag': tag,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(250, 232, 235, 1),
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                    ), // ✅ remove default padding
                    minimumSize: Size.zero, // ✅ remove minimum size
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // ✅ remove extra tap space
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Continue Reading',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// DATE + TAG (responsive row)
              Row(
                children: [
                  /// DATE
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// TAG
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            tag,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
