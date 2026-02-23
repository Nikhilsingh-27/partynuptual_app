import 'package:flutter/material.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/video_card.dart';

class OurVideoScreen extends StatefulWidget {
  const OurVideoScreen({super.key});

  @override
  State<OurVideoScreen> createState() => _OurVideoScreenState();
}

class _OurVideoScreenState extends State<OurVideoScreen> {
  List<String> allvideo = [];
  bool isLoading = true;

  Future<void> getvideo() async {
    try {
      final response = await HomeService().getvideos();
      setState(() {
        allvideo = List<String>.from(response["data"] ?? []);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getvideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hot & Trending Videos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                /// 🔹 Top Text
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      "Watch the latest trending videos across all categories.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                /// 🔹 Grid (Lazy Loaded = Smooth)
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return VideoCard(
                        key: ValueKey(allvideo[index]),
                        videoId: allvideo[index],
                      );
                    }, childCount: allvideo.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 4 / 3,
                        ),
                  ),
                ),

                /// 🔹 Bottom Section
                const SliverToBoxAdapter(child: BottomSection()),
              ],
            ),
    );
  }
}
