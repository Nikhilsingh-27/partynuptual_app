import 'package:flutter/material.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/pagination.dart';
import 'business_detail_page.dart';

class ListingsPage extends StatefulWidget {
  final int categoryId;
  ListingsPage({super.key, required this.categoryId});


  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final List<dynamic> listingList = []; // Store fetched listings
  int currentPage = 1;
  int limit = 10;
  bool isLoading = false; // Show loading indicator
  bool hasMore = true; // Track if more pages are available
  bool check = true;
  bool isPageChanging = false;
  int totalpage=0;

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
        hasMore = true;
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
        totalpage=data['pagination']['total_pages'];
        // print("pp");
        // print(totalpage);
        listingList.addAll(newListings);

        if (newListings.length < limit) {
          hasMore = false;
        }
        isPageChanging = false;
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


  /// Fixes image URL from API to correct "uploads" path
  String fixImageUrl(String url) {
    if (url.isEmpty) return '';
    // Replace "upload/" at the start with "uploads/"
    return url.startsWith('upload/') ? url.replaceFirst('upload/', 'uploads/') : url;
  }


  @override
  Widget build(BuildContext context) {


    print(widget.categoryId);


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
        body: check?const Center(child:CircularProgressIndicator()):SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // GRID (auto height)
                    Opacity(
                      opacity: isPageChanging ? 0.2 : 1,
                      child: GridView.builder(
                        shrinkWrap: true, // 🔥 KEY: auto height
                        physics: const NeverScrollableScrollPhysics(), // let parent scroll
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.6, // adjust if needed
                        ),
                        itemCount: listingList.length,
                        itemBuilder: (context, index) {
                          final listing = listingList[index];
                          return _buildListingCard(
                            context: context,
                            image: fixImageUrl(listing['logo_image'] ?? ''),
                            name: listing['company_name'] ?? '',
                            description: listing['about'] ?? '',
                            phone: listing['phone_number'] ?? '',
                            location: listing['office_address'] ?? '',
                          );
                        },
                      ),
                    ),


                    // LOADER OVERLAY
                    if (isPageChanging)
                      Container(
                        height: 4100, // existing overlay height
                        width: double.infinity,
                        alignment: Alignment.bottomCenter,
                        color: Colors.white.withOpacity(0.8),
                        child: SizedBox(
                          height: 60, // 👈 spinner height
                          width: 60,  // 👈 spinner width
                          child: CircularProgressIndicator(
                            strokeWidth: 6, // 👈 thicker spinner line
                            color: Colors.red, // optional: change color
                          ),
                        ),
                      )

                  ],
                ),
              ),



              const SizedBox(height: 20),

              /// PAGINATION
              Pagination(
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

              const SizedBox(height: 30),

              /// BOTTOM SECTION
              BottomSection(),
            ],
          ),
        )

    );
  }

}

Widget _buildListingCard({
  required BuildContext context,
  required String image,
  required String name,
  required String description,
  required String phone,
  required String location,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IMAGE
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                "https://partynuptual.com/public/$image",
                height: MediaQuery.of(context).size.width-16,
                width: MediaQuery.of(context).size.width-16,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Positioned(
              top: 70,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'OPEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        // CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAME
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.green, size: 14),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // DESCRIPTION (✔ FIXED)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // PHONE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 11, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // FULL WIDTH DIVIDER ✅
              const Divider(thickness: 0.8, height: 1),

              // LOCATION + BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusinessDetailPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        minimumSize: const Size(0, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.visibility, size: 10),
                          SizedBox(width: 8),
                          Text(
                            'View',
                            style: TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
