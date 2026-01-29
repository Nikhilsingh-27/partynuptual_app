import 'package:flutter/material.dart';

/// FAQ Item class
class FAQItem {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
  });
}

/// Reusable FAQ Widget
class FAQWidget extends StatelessWidget {
  final String title;
  final List<FAQItem> items;

  const FAQWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        ExpansionPanelList.radio(
          animationDuration: const Duration(milliseconds: 300),
          children: items.map((item) {
            return ExpansionPanelRadio(
              value: item.question, // must be unique
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    item.question,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  item.answer,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
