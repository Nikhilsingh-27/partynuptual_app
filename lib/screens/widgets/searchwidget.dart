import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/search_listing_screen.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final HomeController controller = Get.find();

  String? selectedCountryId;
  String? selectedCategoryId;
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

      final List countries = homeData.data["data"]["countries"] as List;
      final List categories = homeData.data["data"]["categories_all"] as List;

      return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            /// CATEGORY
            Expanded(
              child: _buildDropdown<String>(
                hint: 'Select Category',
                value: selectedCategoryId,
                items: categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['category_id'].toString(),
                    child: _singleLineText(category['category_name']),
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

            /// COUNTRY
            Expanded(
              child: _buildDropdown<String>(
                hint: 'Select Country',
                value: selectedCountryId,
                items: countries.map<DropdownMenuItem<String>>((country) {
                  return DropdownMenuItem<String>(
                    value: country['country_id'].toString(),
                    child: _singleLineText(country['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedCountryId = value;
                    selectedStateId = null;
                    stateList.clear();
                  });

                  fetchStates(int.parse(value));
                },
              ),
            ),

            const SizedBox(width: 8),

            /// STATE
            Expanded(
              child: _buildDropdown<String>(
                hint: isStateLoading ? 'Loading...' : 'Select State',
                value: stateList.isEmpty ? null : selectedStateId,
                items: stateList.map<DropdownMenuItem<String>>((state) {
                  return DropdownMenuItem<String>(
                    value: state['state_id'].toString(),
                    child: _singleLineText(state['name']),
                  );
                }).toList(),
                onChanged:
                    (selectedCountryId == null ||
                        isStateLoading ||
                        stateList.isEmpty)
                    ? null
                    : (value) {
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
                color: const Color(0xFFC71F37),
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  if (selectedCountryId == null ||
                      selectedStateId == null ||
                      selectedCategoryId == null) {
                    debugPrint("Please select all fields");
                    return;
                  }

                  try {
                    final response = await ProfileService().searchfun(
                      country_id: selectedCountryId!,
                      state: selectedStateId!,
                      category: selectedCategoryId!,
                      page: "1",
                    );

                    Get.to(
                      () => SearchListingsPage(
                        categoryId: selectedCategoryId!,
                        countryId: selectedCountryId!,
                        stateId: selectedStateId!,
                        totalPagesFromPrevious: response["total_pages"] is int
                            ? response["total_pages"]
                            : int.parse(response["total_pages"].toString()),
                      ),
                    );
                  } catch (e) {
                    debugPrint("Search Error: $e");
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 🔹 SINGLE LINE RESPONSIVE TEXT
  Widget _singleLineText(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }

  /// 🔹 REUSABLE DROPDOWN
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
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          hint: _singleLineText(hint),
          items: items,
        ),
      ),
    );
  }
}
