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
      isLoading = false;
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
      appBar: AppBar(title: const Text("Hot & Trending Videos")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Watch the latest trending videos across all categories.",
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 16 / 9, // 🔥 correct for video
                          ),
                      itemCount: allvideo.length,
                      itemBuilder: (context, index) {
                        return VideoCard(
                          key: ValueKey(allvideo[index]),
                          videoId: allvideo[index],
                        );
                      },
                    ),
            ),

            const BottomSection(),
          ],
        ),
      ),
    );
  }
}
