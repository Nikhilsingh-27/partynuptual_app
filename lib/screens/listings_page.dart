import 'package:flutter/material.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/pagination.dart';

import 'business_detail_page.dart';

class ListingsPage extends StatefulWidget {
  final int categoryId;
  const ListingsPage({super.key, required this.categoryId});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final List<dynamic> listingList = [];

  int currentPage = 1;
  int limit = 10;
  int totalpage = 0;

  bool isLoading = false;
  bool isPageChanging = false;
  bool check = true;

  @override
  void initState() {
    super.initState();
    fetchListings();
  }

  Future<void> fetchListings({bool reset = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (reset) {
        listingList.clear();
      }
    });

    try {
      final data = await HomeService().categoryShowById(
        categoryId: widget.categoryId,
        page: currentPage,
        limit: limit,
      );

      final newListings = data['data'] as List<dynamic>;

      setState(() {
        totalpage = data['pagination']['total_pages'];
        listingList.addAll(newListings);
        check = false;
      });
    } catch (e) {
      debugPrint("Pagination error: $e");
    } finally {
      setState(() {
        isLoading = false;
        isPageChanging = false;
      });
    }
  }

  String getLogoImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) {
      return defaultImage;
    }

    final String imageName = logoPath.split('/').last;
    if (imageName.isEmpty) return defaultImage;

    return "${baseUrl}public/uploads/logo/$imageName";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[900]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Listings',
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: check
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    /// LISTINGS SECTION (WITH SIDE PADDING)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: listingList.map((listing) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildListingCard(
                              context: context,
                              listingid: listing["listing_id"].toString(),
                              image: getLogoImageUrl(
                                listing['logo_image'] ?? '',
                              ),
                              name: listing['company_name'] ?? '',
                              description: listing['about'] ?? '',
                              phone: listing['phone_number'] ?? '',
                              location: listing['office_address'] ?? '',
                              ownerid: listing['owner_id'].toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PAGINATION (WITH SIDE PADDING)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Pagination(
                        currentPage: currentPage,
                        totalPages: totalpage,
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                            isPageChanging = true;
                          });
                          fetchListings(reset: true);
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// ✅ FULL WIDTH BOTTOM SECTION (NO PADDING)
                    BottomSection(),
                  ],
                ),

                /// TOP LOADER WHEN PAGE CHANGES
                if (isPageChanging)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      color: Colors.red,
                      minHeight: 3,
                    ),
                  ),
              ],
            ),
    );
  }
}

Widget _buildListingCard({
  required BuildContext context,
  required String listingid,
  required String image,
  required String name,
  required String description,
  required String phone,
  required String location,
  required String ownerid,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              image,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.verified, color: Colors.green, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      phone,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BusinessDetailPage(
                            listingid: listingid,
                            ownerid: ownerid,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
