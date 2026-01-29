import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/business_listing_card.dart';
class MyListingScreen extends StatefulWidget {
  const MyListingScreen({super.key});

  @override
  State<MyListingScreen> createState() => _MyListingScreenState();
}

class _MyListingScreenState extends State<MyListingScreen> {
  final List<Map<String, String>> dummyList = [
    {
      "banner_img": "https://picsum.photos/800/400?1",
      "company_name": "Royal Wedding Photography",
      "business_tag_line": "Capturing your forever moments",
    },
    {
      "banner_img": "https://picsum.photos/800/400?2",
      "company_name": "Elite Event Decorators",
      "business_tag_line": "Turning dreams into grand celebrations",
    },
    {
      "banner_img": "https://picsum.photos/800/400?3",
      "company_name": "Star DJ & Entertainment",
      "business_tag_line": "Music that moves your celebration",
    },
    {
      "banner_img": "https://picsum.photos/800/400?4",
      "company_name": "Golden Caterers",
      "business_tag_line": "Serving happiness on every plate",
    },
    {
      "banner_img": "https://picsum.photos/800/400?5",
      "company_name": "Perfect Planners",
      "business_tag_line": "You celebrate, we organize",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Listings"),),
      body: ListView.builder(
      itemCount: dummyList.length,
      itemBuilder: (context, index) {
        final item = dummyList[index];
        return BusinessListingCard(item: item);
      },
    ),
    );
  }
}
