import 'package:flutter/material.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/block_card.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/pagination.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({super.key});

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  final List<dynamic> listingList = []; // Store fetched listings
  int currentPage = 1;
  int limit = 10;
  bool isLoading = false; // Show loading indicator
  bool hasMore = true; // Track if more pages are available
  bool check = true;
  bool isPageChanging = false;
  int totalpage = 0;

  Future<void> fetchblogs({bool reset = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (reset) {
        listingList.clear();
        hasMore = true;
      }
    });
    try {
      final data = await HomeService().blogsfun(
        page: currentPage,
        limit: limit,
      );

      final newListings = data['data'] as List<dynamic>;

      setState(() {
        totalpage = data['pagination']['total_pages'];
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

  @override
  void initState() {
    super.initState();
    fetchblogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Latest Blogs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: check
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// BLOG GRID
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      // 🔥 reserve space
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // GRID
                          Opacity(
                            opacity: isPageChanging ? 0.2 : 1,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: 380,
                                  ),
                              itemCount: listingList.length,
                              itemBuilder: (context, index) {
                                final blog = listingList[index];
                                return buildBlogCard(
                                  image: blog["image"] ?? "",
                                  title: blog["heading"] ?? "",
                                  description: blog["description"] ?? "",
                                  date: blog["back_date"] ?? "",
                                  tag: blog["category"] ?? "",
                                  author: "",
                                );
                              },
                            ),
                          ),

                          // LOADER
                          if (isPageChanging)
                            Container(
                              height: 1950, // existing overlay height
                              width: double.infinity,
                              alignment: Alignment.bottomCenter,
                              color: Colors.white.withOpacity(0.8),
                              child: SizedBox(
                                height: 60, // 👈 spinner height
                                width: 60, // 👈 spinner width
                                child: CircularProgressIndicator(
                                  strokeWidth: 6, // 👈 thicker spinner line
                                  color: Colors.red, // optional: change color
                                ),
                              ),
                            ),
                        ],
                      ),
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

                      fetchblogs(reset: true);
                    },
                  ),

                  const SizedBox(height: 30),

                  /// BOTTOM SECTION
                  BottomSection(),
                ],
              ),
            ),
    );
  }
}
