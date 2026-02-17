import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_app/screens/widgets/video_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ListingDetailsDropdown extends StatefulWidget {
  String lat;
  String long;
  String desc;
  List gallery;
  List video;

  ListingDetailsDropdown({
    super.key,
    required this.lat,
    required this.long,
    required this.desc,
    required this.gallery,
    required this.video,
  });
  @override
  State<ListingDetailsDropdown> createState() => _ListingDetailsDropdownState();
}

class _ListingDetailsDropdownState extends State<ListingDetailsDropdown> {
  GoogleMapController? mapController;
  LatLng mapCenter = const LatLng(28.6139, 77.2090); // default Delhi

  static const LatLng defaultLocation = LatLng(28.6139, 77.2090); // Delhi

  // Marker for showing selected location
  final Set<Marker> markers = {};
  late List<String> validVideos;

  late LatLng staticLocation;
  @override
  void initState() {
    super.initState();
    print(widget.video);
    double lat = double.tryParse(widget.lat) ?? 0;
    double lng = double.tryParse(widget.long) ?? 0;

    bool isValidLocation = lat != 0 && lng != 0;

    LatLng finalLocation = isValidLocation ? LatLng(lat, lng) : defaultLocation;

    mapCenter = finalLocation;

    if (isValidLocation) {
      markers.add(
        Marker(
          markerId: const MarkerId('static_marker'),
          position: finalLocation,
          infoWindow: const InfoWindow(title: 'Business Location'),
        ),
      );
    }

    validVideos = widget.video
        .where(
          (video) =>
              video != null &&
              video.toString().trim().isNotEmpty &&
              video != "@#@#" &&
              video.toString().toLowerCase() != "null",
        )
        .map((e) => e.toString())
        .toList();
  }

  final List<bool> _expanded = [true, true, true, false];

  // Dummy data (later replace with API)

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController? _youtubeController;
    String? _selectedVideoId;

    return Column(
      children: [
        _buildDropdown(
          index: 0,
          title: "Description",
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.desc,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ),
        _buildDropdown(
          index: 1,
          title: "Gallery",
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // ❌ NO SCROLL
              itemCount: widget.gallery.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 3 images per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // perfect square
              ),
              itemBuilder: (context, i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://partynuptual.com/public/uploads/listing/"
                    "${widget.gallery[i]['owner_id']}/"
                    "${widget.gallery[i]['listing_id']}/"
                    "${widget.gallery[i]['file_name']}",
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),

        // -------- VIDEOS DROPDOWN (UPDATED) --------
        _buildDropdown(
          index: 2,
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
                initialCameraPosition: CameraPosition(
                  target: mapCenter,
                  zoom: 14,
                ),
                onMapCreated: (controller) => mapController = controller,
                markers: markers,
              ),
            ),
          ),
        ),
        _buildDropdown(
          index: 3,
          title: "Videos",
          child: SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: validVideos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 250,
                  child: VideoCard(
                    key: ValueKey(widget.video[index]),
                    videoId: validVideos[index],
                  ),
                );
              },
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
