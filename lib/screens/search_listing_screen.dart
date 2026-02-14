import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/pagination.dart';
import 'business_detail_page.dart';

class SearchListingsPage extends StatefulWidget {
  final String categoryId;
  final String countryId;
  final String stateId;
  final int totalPagesFromPrevious; // ✅ total pages passed from previous API call

  const SearchListingsPage({
    super.key,
    required this.categoryId,
    required this.countryId,
    required this.stateId,
    required this.totalPagesFromPrevious,
  });

  @override
  State<SearchListingsPage> createState() => _SearchListingsPageState();
}

class _SearchListingsPageState extends State<SearchListingsPage> {
  final List<dynamic> listingList = [];

  int currentPage = 1;
  int totalpage = 0;

  bool isLoading = false;
  bool isPageChanging = false;
  bool check = true;

  @override
  void initState() {
    super.initState();
    totalpage = widget.totalPagesFromPrevious; // initialize total pages from previous API call
    fetchListings();
  }

  Future<void> fetchListings({bool reset = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (reset) listingList.clear();
    });

    try {
      final response = await ProfileService().searchfun(
        country_id: widget.countryId,
        state: widget.stateId,
        category: widget.categoryId,
        page: currentPage.toString(), // send current page
      );

      final newListings = response['data'] as List<dynamic>;
      final totalPagesFromApi = response['pagination']?['total_pages'] ?? widget.totalPagesFromPrevious;

      setState(() {
        totalpage = totalPagesFromApi;
        listingList.addAll(newListings);
        check = false;
      });
    } catch (e) {
      debugPrint("Search fetch error: $e");
    } finally {
      setState(() {
        isLoading = false;
        isPageChanging = false;
      });
    }
  }

  String getLogoImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    const String defaultImage =
        "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) return defaultImage;

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
              /// LISTINGS SECTION
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: listingList.map((listing) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildListingCard(
                        context: context,
                        listingid: listing["listing_id"].toString(),
                        image: getLogoImageUrl(listing['logo_image'] ?? ''),
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

              /// PAGINATION
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

              /// BOTTOM SECTION
              BottomSection(),
            ],
          ),

          /// PAGE CHANGE LOADER
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
              fit: BoxFit.cover,
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      phone,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(fontSize: 12),
                    ),
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
