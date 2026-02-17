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
  final List<dynamic> listingList = [];
  int currentPage = 1;
  int limit = 10;
  bool isLoading = false;
  bool hasMore = true;
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
        listingList.addAll(newListings);
        hasMore = newListings.length >= limit;
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// BLOG LIST
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: isPageChanging ? 0.2 : 1,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listingList.length,
                            itemBuilder: (context, index) {
                              final blog = listingList[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: buildBlogCard(
                                  image: blog["image"] ?? "",
                                  title: blog["heading"] ?? "",
                                  description: blog["description"] ?? "",
                                  date: blog["back_date"] ?? "",
                                  tag: blog["category"] ?? "",
                                  author: "",
                                ),
                              );
                            },
                          ),
                        ),

                        /// LOADER OVERLAY
                        if (isPageChanging)
                          Positioned.fill(
                            child: Container(
                              color: Colors.white.withOpacity(0.8),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                height: 60,
                                width: 60,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
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

                      fetchblogs(reset: true);
                    },
                  ),

                  const SizedBox(height: 30),

                  /// BOTTOM
                  const BottomSection(),
                ],
              ),
            ),
    );
  }
}
