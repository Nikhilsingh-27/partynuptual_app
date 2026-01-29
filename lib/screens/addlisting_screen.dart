import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  // Controllers
  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController tagLineCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  String? selectedCategory;
  String selectedCountry = "India";
  String? selectedState;

  XFile? bannerImage;

  final List<String> categories = [
    "Photography",
    "Catering",
    "Event Management",
    "Design"
  ];
  final List<String> states = [
    "Delhi",
    "Maharashtra",
    "Karnataka",
    "Tamil Nadu"
  ];

  GoogleMapController? mapController;
  LatLng mapCenter = const LatLng(28.6139, 77.2090); // default Delhi

  // Marker for showing selected location
  final Set<Marker> markers = {};

  void pickBannerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        bannerImage = image;
      });
    }
  }

  void getAddressFromMap() {
    setState(() {
      // Add/update a marker at the current map center
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: mapCenter,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Selected location: ${mapCenter.latitude}, ${mapCenter.longitude}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.note),
            SizedBox(width: 8),
            Text("Business Listing"),
          ],
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listing Category
            const Text("Listing Category"),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              ))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select categories",
              ),
            ),
            const SizedBox(height: 16),

            // Company Name
            const Text("Company Name / Freelancer"),
            const SizedBox(height: 8),
            TextFormField(
              controller: companyNameCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Company Name / Freelancer",
              ),
            ),
            const SizedBox(height: 16),

            // Email
            const Text("Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
            ),
            const SizedBox(height: 16),

            // Phone
            const Text("Phone"),
            const SizedBox(height: 8),
            TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Phone",
              ),
            ),
            const SizedBox(height: 16),

            // Banner Image
            const Text("Banner Image"),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: pickBannerImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Choose file"),
                ),
                const SizedBox(width: 8),
                Text(bannerImage?.name ?? "No file chosen"),
              ],
            ),
            const SizedBox(height: 16),

            // Registered Office Address
            const Text("Registered Office Address"),
            const SizedBox(height: 8),
            TextFormField(
              controller: addressCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Registered Office Address",
              ),
            ),
            const SizedBox(height: 16),

            // Google Map
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: mapCenter, zoom: 14),
                onMapCreated: (controller) => mapController = controller,
                onCameraMove: (position) => mapCenter = position.target,
                markers: markers,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: getAddressFromMap,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Get Address On Map"),
            ),
            const SizedBox(height: 16),

            // Country
            const Text("Select Country"),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: selectedCountry,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // State
            const Text("Select State"),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedState,
              items: states
                  .map((st) => DropdownMenuItem(
                value: st,
                child: Text(st),
              ))
                  .toList(),
              onChanged: (val) => setState(() => selectedState = val),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select State",
              ),
            ),
            const SizedBox(height: 16),

            // Business Tag Line
            const Text("Business Tag Line"),
            const SizedBox(height: 8),
            TextFormField(
              controller: tagLineCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Business Tag Line",
              ),
            ),
            const SizedBox(height: 16),

            // About Company
            const Text("About Your Company"),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Description",
              ),
            ),
            const SizedBox(height: 24),

            // Save & Next
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Print all data to console
                  print("Category: $selectedCategory");
                  print("Company: ${companyNameCtrl.text}");
                  print("Email: ${emailCtrl.text}");
                  print("Phone: ${phoneCtrl.text}");
                  print("Address: ${addressCtrl.text}");
                  print("State: $selectedState");
                  print("Tag Line: ${tagLineCtrl.text}");
                  print("Description: ${descriptionCtrl.text}");
                  print("Banner Image: ${bannerImage?.path}");
                  print("Map Location: ${mapCenter.latitude}, ${mapCenter.longitude}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text("Save & Next",style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
