import 'package:flutter/material.dart';

import '../listings_page.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final int categoryId;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.name,
    required this.categoryId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListingsPage(categoryId: categoryId),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2), // light grey background
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔴 Circular icon background
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
              child: Icon(icon, color: Colors.red, size: 20),
            ),

            const SizedBox(height: 5),

            // 📝 Category Name
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 5),

            // 🔘 View Button (Pill Style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "View",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
