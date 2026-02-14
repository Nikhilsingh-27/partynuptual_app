import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        _navButton(
          icon: Icons.chevron_left,
          onTap: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),

        ..._buildPageNumbers(),

        // Next Button
        _navButton(
          icon: Icons.chevron_right,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }

  // 🔥 Sliding window logic (max 3 pages)
  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];
    int maxVisible = 3;

    if (totalPages <= maxVisible) {
      // Show all if total pages <= 3
      for (int i = 1; i <= totalPages; i++) {
        pages.add(_pageButton(i));
      }
    } else {
      int startPage = currentPage - 1;
      int endPage = currentPage + 1;

      // If near start
      if (currentPage <= 2) {
        startPage = 1;
        endPage = 3;
      }

      // If near end
      if (currentPage >= totalPages - 1) {
        startPage = totalPages - 2;
        endPage = totalPages;
      }

      for (int i = startPage; i <= endPage; i++) {
        pages.add(_pageButton(i));
      }
    }

    return pages;
  }

  Widget _pageButton(int page) {
    final isActive = page == currentPage;

    return GestureDetector(
      onTap: () => onPageChanged(page),
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          size: 22,
          color: onTap == null ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
