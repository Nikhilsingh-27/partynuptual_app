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
      onTap: onTap ??
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (_) => ListingsPage(
              categoryId: categoryId,
            ),

                ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'View',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
