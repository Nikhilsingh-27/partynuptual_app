import 'package:flutter/material.dart';

Widget buildPartyCard({
  required String image,
  required String title,
  required String location,
  required String description,
  required String date,
  required int likes,
  required int dislikes,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 IMAGE (same proportion as listing card)
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            "https://partynuptual.com/public/uploads/ideas/${image}",
            height: 160, // ✅ IMPORTANT: matches listing card feel
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        /// 🔹 CONTENT
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                /// LOCATION
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
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

                const SizedBox(height: 8),

                /// DESCRIPTION
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),

                const Spacer(),

                /// DATE + LIKES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_outlined,
                            size: 15, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.thumb_down_outlined,
                            size: 15, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          dislikes.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
