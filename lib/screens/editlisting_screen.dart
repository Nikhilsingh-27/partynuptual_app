import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/mylisting_screen.dart';
import 'package:new_app/screens/plan_screen.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class EditListingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditListingScreen({super.key, required this.data});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  bool isLoading = false;
  final AuthenticationController auth = Get.find<AuthenticationController>();
  Future<bool> uploadGalleryImages(String listingId) async {
    if (galleryImages.isEmpty) return true; // nothing to upload

    try {
      const int maxSize = 2 * 1024 * 1024; // 2MB

      // 🔥 Step 1: Validate each image size
      for (XFile image in galleryImages) {
        final File file = File(image.path);
        final int fileSize = await file.length();

        if (fileSize > maxSize) {
          CustomSnackbar.showError("Each image must be less than 2MB.");
          return false;
        }
      }

      // ✅ Step 2: Upload using File (NO BASE64)
      for (XFile image in galleryImages) {
        await ProfileService().uploadGalleryfun(
          ownerId: auth.userId ?? "",
          listingId: listingId,
          imageFile: File(image.path), // ✅ send File
        );
      }

      debugPrint("All gallery images uploaded successfully");
      return true;
    } catch (e) {
      debugPrint("Gallery Upload Error: $e");
      return false;
    }
  }

  bool isImageChanged = false;
  String? existingImageUrl;

  void pickBannerImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        bannerImage = image;
        isImageChanged = true; // ✅ mark changed
      });
    }
  }

  String getLogoImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) {
      return defaultImage;
    }

    final String imageName = logoPath.split('/').last;

    if (imageName.isEmpty) {
      return defaultImage;
    }

    return "${baseUrl}/public/uploads/logo/$imageName";
  }

  String getlisingImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    final userid = auth.userId;
    final listingid = widget.data["listing_id"].toString();
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) {
      return defaultImage;
    }

    final String imageName = logoPath.split('/').last;

    if (imageName.isEmpty) {
      return defaultImage;
    }

    return "${baseUrl}/public/uploads/listing/$userid/$listingid/$imageName";
  }

  List gallerylist = [];
  Future<void> fetchlistingbyid(String id) async {
    final response = await HomeService().getlistingbyid(id: id);
    final gallerydata = await HomeService().gallerybyid(id: id);
    setState(() {
      gallerylist = gallerydata["data"] ?? [];
    });
  }

  String getListingStatus(Map<String, dynamic> response, String listingId) {
    final List<dynamic> listings = response["data"] ?? [];

    final matched = listings.where(
      (item) => item["listing_id"]?.toString() == listingId,
    );

    if (matched.isEmpty) return "";

    return matched.first["status"]?.toString() ?? "";
  }

  String status = "";

  Future<void> fetchlisting() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ProfileService().getmylistingfun(
        id: auth.userId.toString(),
      );

      setState(() {
        status = getListingStatus(
          response,
          widget.data["listing_id"]?.toString() ?? "",
        );
      });
    } catch (e) {
      print("Fetch listing error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchlistingbyid(widget.data["listing_id"].toString());

    final data = widget.data;
    fetchlisting();
    // 🔹 Basic Fields
    companyNameCtrl.text = data["company_name"]?.toString() ?? "";
    emailCtrl.text = data["email"]?.toString() ?? "";
    phoneCtrl.text = data["phone_number"]?.toString() ?? "";
    addressCtrl.text = data["office_address"]?.toString() ?? "";
    tagLineCtrl.text = data["tag_line"]?.toString() ?? "";
    descriptionCtrl.text = data["about"]?.toString() ?? "";

    // 🔹 Social Media
    facebookCtrl.text = data["fb"]?.toString() ?? "";
    instagramCtrl.text = data["insta"]?.toString() ?? "";
    twitterCtrl.text = data["twitter"]?.toString() ?? "";
    pinterestCtrl.text = data["pintrest"]?.toString() ?? "";

    // 🔹 Video (API stores string like "@#@#" or comma separated)
    if (data["videos"] != null && data["videos"].toString().isNotEmpty) {
      videoLinkCtrl.text = data["videos"].toString();
    } else {
      videoLinkCtrl.text = "";
    }

    // 🔹 Dropdown Selections
    selectedCategoryId = data["category"]?.toString();
    selectedCountryId = data["country_id"]?.toString();
    selectedStateId = data["state"]?.toString();
    selectedCategory = data["category"]?.toString();
    selectedState = data["state"]?.toString();

    // 🔹 City (if you later create city controller)
    // cityCtrl.text = data["city"]?.toString() ?? "";

    // 🔹 Fetch States if country exists
    if (selectedCountryId != null && selectedCountryId!.isNotEmpty) {
      fetchStates(int.parse(selectedCountryId!));
    }

    // 🔹 Location (Correct Spelling From API)
    if (data["lattitude"] != null &&
        data["longnitude"] != null &&
        data["lattitude"].toString().isNotEmpty &&
        data["longnitude"].toString().isNotEmpty) {
      double lat = double.tryParse(data["lattitude"].toString()) ?? 28.6139;
      double lng = double.tryParse(data["longnitude"].toString()) ?? 77.2090;

      mapCenter = LatLng(lat, lng);

      markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: mapCenter,
        ),
      );
    }

    // 🔹 Logo Image
    if (data["logo_image"] != null &&
        data["logo_image"].toString().isNotEmpty) {
      final String imageValue = data["logo_image"].toString();

      if (imageValue.startsWith("http")) {
        // 🔹 From API full URL
        existingImageUrl = imageValue;
      } else if (imageValue.startsWith("/")) {
        // 🔹 Local file path
        bannerImage = XFile(imageValue);
      } else {
        // 🔹 From API filename only
        existingImageUrl = getLogoImageUrl(imageValue);
      }
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission permanently denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng newLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      mapCenter = newLocation;

      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: newLocation,
        ),
      );
    });

    // 🔥 Move camera to user location
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newLocation, zoom: 16),
      ),
    );

    debugPrint("Latitude: ${position.latitude}");
    debugPrint("Longitude: ${position.longitude}");
  }

  List<XFile> galleryImages = [];
  final ImagePicker picker = ImagePicker();

  // Controllers
  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController tagLineCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  final TextEditingController facebookCtrl = TextEditingController();
  final TextEditingController instagramCtrl = TextEditingController();
  final TextEditingController twitterCtrl = TextEditingController();
  final TextEditingController pinterestCtrl = TextEditingController();
  final TextEditingController videoLinkCtrl = TextEditingController();

  // String? selectedCategory;
  String selectedCountry = "India";
  // String? selectedState;

  final HomeController controller = Get.find();
  // final AuthenticationController auth = Get.find<AuthenticationController>();

  String? selectedCategory;
  String? selectedCountryId;
  String? selectedCategoryId; // ✅ store country_id
  String? selectedState;
  String? selectedStateId;

  List stateList = [];
  bool isStateLoading = false;

  Future<void> fetchStates(int id) async {
    setState(() {
      isStateLoading = true;
      stateList.clear();
    });

    final response = await HomeService().getstates(id: id);

    setState(() {
      stateList = response['data'] ?? [];
      isStateLoading = false;
    });
  }

  XFile? bannerImage;

  Future<void> pickGalleryImages() async {
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        galleryImages.addAll(images);
      });
    }
  }

  GoogleMapController? mapController;
  LatLng mapCenter = const LatLng(28.6139, 77.2090); // default Delhi

  // Marker for showing selected location
  final Set<Marker> markers = {};

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

    CustomSnackbar.showSuccess(
      "Selected location: ${mapCenter.latitude}, ${mapCenter.longitude}",
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.note, color: Color(0xFFc71f37)),
            SizedBox(width: 8),
            Text(
              "Edit Business Listing",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final homeData = controller.homeData.value;

        if (homeData == null) {
          return const SizedBox();
        }
        if (selectedCountryId != null && stateList.isEmpty && !isStateLoading) {
          fetchStates(int.parse(selectedCountryId!));
        }

        // ✅ API countries (List<Map>)
        final List countries = homeData.data["data"]["countries"] as List;

        final List allcategory =
            homeData.data["data"]["categories_all"] as List;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Listing Category
                  const Text(
                    "Listing Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown<String>(
                    hint: 'Category',
                    value: selectedCategoryId,
                    items: allcategory.map<DropdownMenuItem<String>>((
                      category,
                    ) {
                      return DropdownMenuItem<String>(
                        value: category['category_id'].toString(), // ✅ ID
                        child: Text(
                          category['category_name'], // ✅ Name
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Company Name
                  const Text(
                    "Company Name / Freelancer",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: companyNameCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Company Name / Freelancer",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  const Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  const Text(
                    "Phone",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Phone",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Banner Image
                  const Text(
                    "Banner Image",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: pickBannerImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFc71f37),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Choose file",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔥 IMAGE PREVIEW
                      /// 🔥 IMAGE PREVIEW
                      /// 🔥 IMAGE PREVIEW
                      if (bannerImage != null)
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(bannerImage!.path),
                              fit: BoxFit.cover, // or BoxFit.contain
                            ),
                          ),
                        )
                      else if (existingImageUrl != null)
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              existingImageUrl!,
                              fit: BoxFit.cover, // or BoxFit.contain
                            ),
                          ),
                        )
                      else
                        const Text("No image selected"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Registered Office Address
                  const Text(
                    "Registered Office Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: addressCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Registered Office Address",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Business Tag Line",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tagLineCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Business Tag Line",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Google Map
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: mapCenter,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) => mapController = controller,
                      onCameraMove: (position) => mapCenter = position.target,
                      markers: markers,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFc71f37),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Get Address On Map",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Select Country",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Country
                  _buildDropdown<String>(
                    hint: 'Country',
                    value: selectedCountryId,
                    items: countries.map<DropdownMenuItem<String>>((country) {
                      return DropdownMenuItem<String>(
                        value: country['country_id'].toString(), // ✅ ID
                        child: Text(
                          country['name'], // ✅ Name
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedCountryId = value;
                        selectedStateId =
                            null; // reset state when country changes
                        stateList.clear();
                      });

                      fetchStates(int.parse(value));
                    },
                  ),
                  const SizedBox(height: 16),

                  // State
                  const Text(
                    "Select State",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown<String>(
                    hint: isStateLoading
                        ? 'Loading...'
                        : selectedCountryId == null
                        ? 'State'
                        : 'State',
                    value: selectedStateId,

                    items: stateList.map<DropdownMenuItem<String>>((state) {
                      return DropdownMenuItem<String>(
                        value: state['state_id'].toString(),
                        child: Text(
                          state['name'],
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged:
                        (selectedCountryId == null ||
                            isStateLoading ||
                            stateList.isEmpty)
                        ? null
                        : (String? value) {
                            setState(() {
                              selectedStateId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 16),

                  // Facebook
                  const Text(
                    "Facebook",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: facebookCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Facebook",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Instagram",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: instagramCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Instagram",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Twitter",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: twitterCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Twitter",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Pinterest",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: pinterestCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Pinterest",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Video Link",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: videoLinkCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Video Link",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // About Company
                  const Text(
                    "About Your Company",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionCtrl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: pickGalleryImages,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gallery Images",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (gallerylist.isNotEmpty ||
                              galleryImages.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  gallerylist.length + galleryImages.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.85,
                                  ),
                              itemBuilder: (context, index) {
                                /// 🔹 EXISTING IMAGES
                                if (index < gallerylist.length) {
                                  final image = gallerylist[index];
                                  final imageUrl = getlisingImageUrl(
                                    image["file_name"],
                                  );
                                  final image_id = image["image_id"];
                                  final listing_id = image["listing_id"];
                                  return Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          imageUrl,
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            // 🔥 Show loader
                                            Get.dialog(
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              barrierDismissible: false,
                                            );

                                            final response =
                                                await ProfileService()
                                                    .removegalleryimagefun(
                                                      image_id: image_id
                                                          .toString(),
                                                      listing_id: listing_id
                                                          .toString(),
                                                    );

                                            Get.back(); // close loader

                                            if (response["status"] ==
                                                "success") {
                                              setState(() {
                                                gallerylist.removeAt(index);
                                              });

                                              CustomSnackbar.showSuccess(
                                                "Image removed successfully",
                                              );
                                            } else {
                                              CustomSnackbar.showError(
                                                response["message"] ??
                                                    "Failed to remove image",
                                              );
                                            }
                                          } catch (e) {
                                            Get.back(); // close loader

                                            CustomSnackbar.showError(
                                              e.toString(),
                                            );
                                          }
                                        },

                                        // 🔥 OPTIONAL: call delete API here
                                        // ProfileService().deleteGallery(image["image_id"]);
                                        child: const Text(
                                          "Remove",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                /// 🔹 NEWLY PICKED IMAGES
                                else {
                                  final newIndex = index - gallerylist.length;

                                  return Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(galleryImages[newIndex].path),
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            galleryImages.removeAt(newIndex);
                                          });
                                        },

                                        child: const Text(
                                          "Remove",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),

                          const SizedBox(height: 12),
                          const Text(
                            "Note:- Please Click Inside The Box To Upload More Images.",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Save & Next
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedstate = stateList.firstWhere(
                          (c) => c['state_id'].toString() == selectedStateId,
                          orElse: () => null,
                        );
                        if (selectedCategoryId == null ||
                            selectedCountryId == null ||
                            selectedStateId == null) {
                          CustomSnackbar.showError(
                            "Please fill all required fields",
                          );
                          return;
                        }

                        // 🔹 Convert image to base64

                        try {
                          setState(() {
                            isLoading = true;
                          });
                          // 🔹 Build request body here
                          Map<String, dynamic> body = {
                            "listing_id": widget.data["listing_id"].toString(),
                            "category_id": selectedCategoryId!,
                            "company_name": companyNameCtrl.text.trim(),
                            "email": emailCtrl.text.trim(),
                            "phone_number": phoneCtrl.text.trim(),
                            "office_address": addressCtrl.text.trim(),
                            "tag_line": tagLineCtrl.text.trim(),
                            "country_id": selectedCountryId!,
                            "state": selectedStateId ?? "",
                            "city": selectedstate?["name"] ?? "",
                            "about_company": descriptionCtrl.text.trim(),
                            "lattitude": mapCenter.latitude.toString(),
                            "longnitude": mapCenter.longitude.toString(),
                            "gender": "Male",
                            "fb": facebookCtrl.text.trim(),
                            "insta": instagramCtrl.text.trim(),
                            "twitter": twitterCtrl.text.trim(),
                            "pintrest": pinterestCtrl.text.trim(),
                            "videos": videoLinkCtrl.text.trim().isNotEmpty
                                ? [videoLinkCtrl.text.trim()]
                                : [],
                          };

                          ///  Only add image if changed

                          bool isUploaded = await uploadGalleryImages(
                            widget.data["listing_id"].toString(),
                          );

                          if (isUploaded) {
                            final response = await ProfileService()
                                .updateListing(body);
                            CustomSnackbar.showSuccess(
                              "Listing updated successfully",
                            );
                            // Optional: handle response
                            if (status == "1") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyListingScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PricingScreen(
                                    id:
                                        widget.data["listing_id"]?.toString() ??
                                        "",
                                  ),
                                ),
                              );
                            }
                            debugPrint("Update Listing Response: $response");
                          } else {
                            debugPrint(
                              "Gallery upload failed. Update API not called.",
                            );
                          }

                          //print("API Response: $response");

                          //  Upload gallery images AFTER listing updated

                          setState(() {
                            isLoading = false;
                          });

                          print("nikhil");

                          print(status);
                        } catch (e) {
                          CustomSnackbar.showError(e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        "Update Listing",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            /// Loader
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    ValueChanged<T?>? onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(hint, style: const TextStyle(fontSize: 12)),
          value: value,
          isExpanded: true,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
