import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/convertimgtobase64.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';


class EditListingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditListingScreen({super.key, required this.data});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {

  String getLogoImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    const String defaultImage =
        "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) {
      return defaultImage;
    }


    final String imageName = logoPath.split('/').last;

    if (imageName.isEmpty) {
      return defaultImage;
    }

    return "${baseUrl}/public/uploads/logo/$imageName";
  }

  @override
  void initState() {
    super.initState();

    final data = widget.data;

    companyNameCtrl.text = data["company_name"] ?? "";
    emailCtrl.text = data["email"] ?? "";
    phoneCtrl.text = data["phone_number"] ?? "";
    addressCtrl.text = data["office_address"] ?? "";
    tagLineCtrl.text = data["tag_line"] ?? "";
    descriptionCtrl.text = data["about"] ?? "";

    selectedCategoryId = data["category"]?.toString();
    selectedCountryId = data["country_id"]?.toString();
    selectedStateId = data["state"]?.toString();

    if (selectedCountryId != null) {
      fetchStates(int.parse(selectedCountryId!));  // ✅ IMPORTANT
    }

    if (data["latitude"] != null && data["longitude"] != null) {
      mapCenter = LatLng(
        double.parse(data["latitude"].toString()),
        double.parse(data["longitude"].toString()),
      );

      markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: mapCenter,
        ),
      );
    }
    if (data["logo_image"] != null && data["logo_image"].toString().isNotEmpty) {
      bannerImage = XFile(getLogoImageUrl(data["logo_image"]));
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
        CameraPosition(
          target: newLocation,
          zoom: 16,
        ),
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
  final AuthenticationController auth = Get.find<AuthenticationController>();

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
              Text("Edit Business Listing"),
            ],
          ),
          backgroundColor: Colors.redAccent,
        ),
        body: Obx((){

          final homeData = controller.homeData.value;



          if (homeData == null) {
            return const SizedBox();
          }
          if (selectedCountryId != null && stateList.isEmpty && !isStateLoading) {
            fetchStates(int.parse(selectedCountryId!));
          }

          // ✅ API countries (List<Map>)
          final List countries = homeData.data["data"]["countries"] as List;

          final List allcategory = homeData.data["data"]["categories_all"] as List;


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Listing Category
                const Text("Listing Category"),
                const SizedBox(height: 8),
                _buildDropdown<String>(
                  hint: 'Category',
                  value: selectedCategoryId,
                  items: allcategory.map<DropdownMenuItem<String>>((category) {
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
                  onPressed: getCurrentLocation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Get Address On Map"),
                ),
                const SizedBox(height: 16),

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
                      selectedState = null; // reset state when country changes
                      stateList.clear();
                    });

                    fetchStates(int.parse(value));
                  },
                ),
                const SizedBox(height: 16),

                // State
                const Text("Select State"),
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
                const Text("Facebook"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: facebookCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Facebook",
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Instagram"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: instagramCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Instagram",
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Twitter"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: twitterCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Twitter",
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Pinterest"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: pinterestCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Pinterest",
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Video Link"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: videoLinkCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Video Link",
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

                GestureDetector(
                  onTap: pickGalleryImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Gallery Images",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 12),

                        if (galleryImages.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: galleryImages.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(galleryImages[index].path),
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        galleryImages.removeAt(index);
                                      });
                                    },
                                    child: const Text(
                                      "Remove file",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              );
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
                SizedBox(height: 15,),
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
                          selectedStateId == null ||
                          bannerImage == null) {
                        Get.snackbar("Error", "Please fill all required fields");
                        return;
                      }

                      // 🔹 Convert image to base64
                      final String? base64Image = await convertImageToBase64(bannerImage);

                      if (base64Image == null) {
                        Get.snackbar("Error", "Image conversion failed");
                        return;
                      }

                      try {
                        final response = await ProfileService().addlistingfun(
                          userId: auth.userId.toString(),
                          categoryId: selectedCategoryId!,
                          companyName: companyNameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          phoneNumber: phoneCtrl.text.trim(),
                          officeAddress: addressCtrl.text.trim(),
                          tagLine: tagLineCtrl.text.trim(),
                          countryId: selectedCountryId!,
                          state: selectedstate["name"]??"",
                          aboutCompany: descriptionCtrl.text.trim(),
                          image: base64Image,
                          latitude: mapCenter.latitude.toString(),
                          longitude: mapCenter.longitude.toString(),
                        );

                        print("API Response: $response");

                        Get.snackbar("Success", "Listing added successfully");

                      } catch (e) {
                        Get.snackbar("Error", e.toString());
                      }



                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text("Update Listing",style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        })

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
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(hint, style: const TextStyle(fontSize: 12)),
          value: value,
          isExpanded: true,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
