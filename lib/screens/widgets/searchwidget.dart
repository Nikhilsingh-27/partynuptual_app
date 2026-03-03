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

      final List countries =
      homeData.data["data"]["countries"] as List;
      final List categories =
      homeData.data["data"]["categories_all"] as List;

      return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CATEGORY
            Expanded(
              flex: 3,
              child: _buildDropdown<String>(
                hint: 'Select Category',
                value: selectedCategoryId,
                items: categories
                    .map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['category_id'].toString(),
                    child: _dropdownText(
                        category['category_name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
              ),
            ),

            const SizedBox(width: 6),

            /// COUNTRY
            Expanded(
              flex: 3,
              child: _buildDropdown<String>(
                hint: 'Select Country',
                value: selectedCountryId,
                items: countries
                    .map<DropdownMenuItem<String>>((country) {
                  return DropdownMenuItem<String>(
                    value: country['country_id'].toString(),
                    child: _dropdownText(country['name']),
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

            const SizedBox(width: 6),

            /// STATE
            Expanded(
              flex: 3,
              child: _buildDropdown<String>(
                hint:
                isStateLoading ? 'Loading...' : 'Select State',
                value:
                stateList.isEmpty ? null : selectedStateId,
                items: stateList
                    .map<DropdownMenuItem<String>>((state) {
                  return DropdownMenuItem<String>(
                    value: state['state_id'].toString(),
                    child: _dropdownText(state['name']),
                  );
                }).toList(),
                onChanged: (selectedCountryId == null ||
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

            const SizedBox(width: 6),

            /// SEARCH BUTTON
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFC71F37),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search,
                      color: Colors.white, size: 20),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (selectedCategoryId == null) {
                      debugPrint(
                          "Please select category");
                      return;
                    }

                    try {
                      final response =
                      await ProfileService()
                          .searchfun(
                        category: selectedCategoryId!,
                        page: "1",
                        country_id:
                        selectedCountryId,
                        state: selectedStateId,
                      );

                      Get.to(
                            () => SearchListingsPage(
                          categoryId:
                          selectedCategoryId!,
                          countryId:
                          selectedCountryId,
                          stateId:
                          selectedStateId,
                          totalPagesFromPrevious:
                          response["total_pages"]
                          is int
                              ? response[
                          "total_pages"]
                              : int.parse(response[
                          "total_pages"]
                              .toString()),
                        ),
                      );
                    } catch (e) {
                      debugPrint(
                          "Search Error: $e");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 🔹 Text that wraps to 2 lines (no shrink, no ellipsis)
  Widget _dropdownText(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.visible,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  /// 🔹 Reusable Dropdown (height auto grows)
  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    ValueChanged<T?>? onChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 50,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border:
        Border.all(color: Colors.black54),
        borderRadius:
        BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          hint: _dropdownText(hint),
          items: items,
        ),
      ),
    );
  }
}