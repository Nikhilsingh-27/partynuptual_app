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
  final List<Map<String, dynamic>> cardList = [
    {
      "title": "Birthday",
      "location": "Kansas",
      "description": "My Birthday cake",
      "image": "assets/b.jpg",
      "date": "21 Jan 2026",
      "likes": 0,
      "dislikes": 0,
    },
    {
      "title": "Birthday",
      "location": "Grand Hall",
      "description": "Fun birthday theme decoration",
      "image": "assets/maria.jpg",
      "date": "20 Jan 2026",
      "likes": 1,
      "dislikes": 0,
    },
    {
      "title": "Birthday",
      "location": "City Banquet",
      "description": "Surprise birthday party setup",
      "image": "assets/lela.jpg",
      "date": "18 Jan 2026",
      "likes": 5,
      "dislikes": 1,
    },
    {
      "title": "Birthday",
      "location": "City Banquet",
      "description": "Surprise birthday party setup",
      "image": "assets/p2.jpg",
      "date": "18 Jan 2026",
      "likes": 5,
      "dislikes": 1,
    },
  ];

  final List<dynamic> listingList = []; // Store fetched listings
  int currentPage = 1;
  int limit = 10;
  bool isLoading = false; // Show loading indicator
  bool hasMore = true; // Track if more pages are available
  bool check = true;
  bool isPageChanging = false;
  int totalpage=0;
  Future<void> fetchideas({bool reset = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (reset) {
        listingList.clear();
        hasMore = true;
      }
    });

    try {
      final data = await HomeService().shareideasfun(page: currentPage, limit: limit);

      final newListings = data['data'] as List<dynamic>;

      //print(newListings);
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

  @override
  void initState() {
    super.initState();
    fetchideas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Let Us Know How You Did Your Party"),),
      body: check
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
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
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 290,
                        ),
                        itemCount: listingList.length,
                        itemBuilder: (context, index) {
                          final card = listingList[index];
                          return buildPartyCard(
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

                    // LOADER
                    if (isPageChanging)
                      Container(
                        height: 1500, // existing overlay height
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
            ),

            const SizedBox(height: 14),

            Pagination(
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
            const SizedBox(height: 8,),
            BottomSection(),
          ],
        ),
      ),

    );
  }
}
