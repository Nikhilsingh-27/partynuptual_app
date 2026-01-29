import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_app/screens/widgets/video_card.dart';


class ListingDetailsDropdown extends StatefulWidget {
  const ListingDetailsDropdown({super.key});

  @override
  State<ListingDetailsDropdown> createState() => _ListingDetailsDropdownState();
}

class _ListingDetailsDropdownState extends State<ListingDetailsDropdown> {
  GoogleMapController? mapController;
  LatLng mapCenter = const LatLng(28.6139, 77.2090); // default Delhi

  // Marker for showing selected location
  final Set<Marker> markers = {};

  final List<bool> _expanded = [false, false, false, false];

  // Dummy data (later replace with API)
  final List<String> galleryImages = [
    'assets/b.jpeg',
    'assets/b.jpg',
    'assets/b1.jpg',
  ];

  final List<String> videoThumbs = [
    'https://www.pexels.com/download/video/35174752/',
    'https://www.pexels.com/download/video/35174767/',
    'https://www.pexels.com/download/video/35174755/'
  ];

  final String descriptionText =
      "At New Bay Design, we pride ourselves on delivering exceptional quality "
      "and personalized service that sets us apart in the construction industry. "
      "What makes us unique is our commitment to custom solutions tailored to meet "
      "the specific needs and preferences of our clients.\n\n"
      "We specialize in custom kitchen and bathroom projects, transforming these "
      "essential spaces into functional and aesthetically pleasing areas that reflect "
      "your style. Our team works closely with you from the initial design phase to "
      "the final touches, ensuring your vision is fully realized.\n\n"
      "In addition to kitchen and bath renovations, we also excel in custom "
      "construction projects, including accessory dwelling units (ADUs) and "
      "home additions.";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          index: 0,
          title: "Description",
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              descriptionText,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ),
        _buildDropdown(
          index: 1,
          title: "Gallery",
          child: SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  galleryImages[i],
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: galleryImages.length,
            ),
          ),
        ),
        // -------- VIDEOS DROPDOWN (UPDATED) --------
        _buildDropdown(
          index: 2,
          title: "Videos",
          child: SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: videoThumbs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoCard(
                          videoUrl: videoThumbs[i],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        _buildDropdown(
          index: 3,
          title: "Map",
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
              alignment: Alignment.center,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: mapCenter, zoom: 14),
                onMapCreated: (controller) => mapController = controller,
                onCameraMove: (position) => mapCenter = position.target,
                markers: markers,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required int index,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                _expanded[index] = !_expanded[index];
              });
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red.shade50,
                    child: Icon(
                      _expanded[index]
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: _expanded[index]
                ? SizedBox(
              width: double.infinity, // 🔑 keep width stable
              child: child,
            )
                : const SizedBox.shrink(),
          ),

        ],
      ),
    );
  }
}
