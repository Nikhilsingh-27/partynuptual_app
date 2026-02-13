import 'package:flutter/material.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/business_listing_card.dart';
import 'package:get/get.dart';
class MyListingScreen extends StatefulWidget {

  const MyListingScreen({super.key});

  @override
  State<MyListingScreen> createState() => _MyListingScreenState();
}

class _MyListingScreenState extends State<MyListingScreen> {

  final AuthenticationController auth = Get.find<AuthenticationController>();

  List<dynamic> listinglist = [];

  Future<void> fetchlisting() async {
    try {
      final response = await ProfileService()
          .getmylistingfun(id: auth.userId.toString());

      print(response);

      if (!mounted) return;

      setState(() {
        listinglist = response["data"] ?? [];
      });
    } catch (e) {
      print("Fetch listing error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchlisting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Listings"),),
      body: ListView.builder(
      itemCount: listinglist.length,
      itemBuilder: (context, index) {
        final item = listinglist[index];
        return BusinessListingCard(item: item,onDeleteSuccess: fetchlisting);
      },
    ),
    );
  }
}
