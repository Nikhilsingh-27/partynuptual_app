import 'package:flutter/material.dart';

/// FAQ Item class
class FAQItem {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});
}

/// Reusable FAQ Widget
class FAQWidget extends StatelessWidget {
  final String title;
  final List<FAQItem> items;

  const FAQWidget({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        const SizedBox(height: 6),

        /// FAQ Items
        Column(
          children: items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              /// REMOVE DEFAULT DIVIDER + SPLASH EFFECT
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent, // 🔥 removes black line
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    item.question,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.answer,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
