import 'package:flutter/material.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/pagination.dart';
import 'package:new_app/screens/widgets/party_card.dart';

class ViewIdeasScreen extends StatefulWidget {
  const ViewIdeasScreen({super.key});

  @override
  State<ViewIdeasScreen> createState() => _ViewIdeasScreenState();
}

class _ViewIdeasScreenState extends State<ViewIdeasScreen> {
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
    fetchideas();
  }

  Future<void> fetchideas({bool reset = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (reset) {
        listingList.clear();
      }
    });

    try {
      final data = await HomeService().shareideasfun(
        page: currentPage,
        limit: limit,
      );

      final newListings = data['data'] as List<dynamic>;

      setState(() {
        totalpage = data['pagination']['total_pages'];
        listingList.addAll(newListings);
        print(newListings);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Let Us Know How You Did Your Party")),
      body: check
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    /// GRID
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: .9,
                            ),
                        itemCount: listingList.length,
                        itemBuilder: (context, index) {
                          final card = listingList[index];

                          return PartyCard(
                            id: card["id"].toString(),
                            image: card["image"],
                            title: card["party_theme"],
                            location: card["venue"],
                            description: card["description"],
                            date: card["date_added"],
                            likes: int.parse(card["like_count"]),
                            dislikes: int.parse(card["dislike_count"]),
                          );
                        },
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
                          fetchideas(reset: true);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// FOOTER
                    const BottomSection(),
                  ],
                ),

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
