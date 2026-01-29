import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/video_card.dart';
class OurVideoScreen extends StatefulWidget {
  const OurVideoScreen({super.key});

  @override
  State<OurVideoScreen> createState() => _OurVideoScreenState();
}

class _OurVideoScreenState extends State<OurVideoScreen> {
  List<String> dummyVideoUrls = [
    "https://www.youtube.com/watch?v=EYz0D-QD0z8",
    "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
    "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hot & Trending Videos"),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Text("Watch the latest trending videos across all categories."),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: dummyVideoUrls.length,
                  itemBuilder: (context,index){
                    final video=dummyVideoUrls[index];
                    return VideoCard(videoUrl: video);
                  }),
            ),
            BottomSection()
          ],
        ),
      ),
    );
  }
}
