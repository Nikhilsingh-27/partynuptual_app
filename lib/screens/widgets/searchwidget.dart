import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/home_service.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final HomeController controller = Get.find();

  // Dummy categories (can be API later)

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
      selectedStateId = null;
    });

    final response = await HomeService().getstates(id: id);

    setState(() {
      stateList = response['data'] ?? [];
      isStateLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final homeData = controller.homeData.value;

      if (homeData == null) {
        return const SizedBox();
      }

      // ✅ API countries (List<Map>)
      final List countries = homeData.data["data"]["countries"] as List;

      final List allcategory = homeData.data["data"]["categories_all"] as List;
      return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            /// CATEGORY DROPDOWN
            Expanded(
              child: _buildDropdown<String>(
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
            ),

            const SizedBox(width: 8),

            /// COUNTRY DROPDOWN (API BASED)
            Expanded(
              child: _buildDropdown<String>(
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
            ),

            const SizedBox(width: 8),

            /// STATE DROPDOWN
            Expanded(
              child: _buildDropdown<String>(
                hint: isStateLoading
                    ? 'Loading...'
                    : selectedCountryId == null
                    ? 'State'
                    : 'State',
                value: stateList.isEmpty ? null : selectedStateId,
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
            ),

            const SizedBox(width: 8),

            /// SEARCH BUTTON
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  final selectedCountry = countries.firstWhere(
                    (c) => c['country_id'].toString() == selectedCountryId,
                    orElse: () => null,
                  );
                  final selectedcategory = allcategory.firstWhere(
                    (c) => c['category_id'].toString() == selectedCategoryId,
                    orElse: () => null,
                  );
                  final selectedstate = stateList.firstWhere(
                    (c) => c['state_id'].toString() == selectedStateId,
                    orElse: () => null,
                  );

                  debugPrint('''
                    Category: ${selectedcategory?['category_name']}
                    Country: ${selectedCountry?['name']}
                    State : ${selectedstate?['name']}
                    ''');
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 🔹 REUSABLE DROPDOWN WIDGET
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
