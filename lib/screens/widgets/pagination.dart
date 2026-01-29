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
        _navButton(
          icon: Icons.chevron_left,
          onTap: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),

        ...List.generate(totalPages, (index) {
          final page = index + 1;
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
        }),

        _navButton(
          icon: Icons.chevron_right,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
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
        child: Icon(icon, size: 22),
      ),
    );
  }
}
