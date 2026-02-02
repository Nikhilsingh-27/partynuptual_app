import 'dart:async';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // 👇 this runs when user stops typing
      print("User stopped typing: $value");
      searchApi(value);
    });
  }

  void searchApi(String query) {
    // API call or heavy logic
    print("Calling API with: $query");
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onSearchChanged,
      decoration: const InputDecoration(
        hintText: "Search...",
        border: OutlineInputBorder(),
      ),
    );
  }
}
