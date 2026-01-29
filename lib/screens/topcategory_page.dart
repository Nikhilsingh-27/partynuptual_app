import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/widgets/bottom.dart';

import 'package:new_app/screens/widgets/category_card.dart';
import 'package:new_app/screens/listings_page.dart';
import '../../controllers/home_controller.dart';
class TopCategoryScreen extends StatefulWidget {
  const TopCategoryScreen({super.key});

  @override
  State<TopCategoryScreen> createState() => _TopCategoryScreenState();
}

class _TopCategoryScreenState extends State<TopCategoryScreen> {
  final HomeController controller = Get.find();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Art Work', 'icon': Icons.brush},
    {'name': 'Photographer', 'icon': Icons.camera_alt},
    {'name': 'Decorator', 'icon': Icons.palette},
    {'name': 'Singer', 'icon': Icons.mic},
    {'name': 'Party Entertainer', 'icon': Icons.celebration},
    {'name': 'Make Up Artist', 'icon': Icons.face},
    {'name': 'DJs', 'icon': Icons.headphones},
    {'name': 'Hair Stylist', 'icon': Icons.content_cut},
    {'name': 'Pet Store', 'icon': Icons.pets},
    {'name': 'Bakers', 'icon': Icons.cake},
    {'name': 'Musician/Band', 'icon': Icons.music_note},
    {'name': 'Night Club', 'icon': Icons.nightlife},
    {'name': 'Tailor', 'icon': Icons.design_services},
    {'name': 'Costume Designer', 'icon': Icons.checkroom},
    {'name': 'Barbers', 'icon': Icons.content_cut}, // ✅ FIX
    {'name': 'Party Bus', 'icon': Icons.directions_bus},
    {'name': 'Dress Maker', 'icon': Icons.local_mall},
    {'name': 'Fashion Designer', 'icon': Icons.style},
    {'name': 'Restaurant', 'icon': Icons.restaurant},
    {'name': 'Limousine', 'icon': Icons.directions_car},
    {'name': 'Models', 'icon': Icons.person},
    {'name': 'Bartender', 'icon': Icons.local_bar},
    {'name': 'Event Space', 'icon': Icons.location_city},
    {'name': 'Party Boat Rides', 'icon': Icons.directions_boat},
    {'name': 'Bar & Lounge', 'icon': Icons.wine_bar},
    {'name': 'Party Supplies', 'icon': Icons.shopping_bag},
    {'name': 'Event Planner', 'icon': Icons.event},
    {'name': 'Culinary Arts', 'icon': Icons.restaurant_menu},
    {'name': 'Marriage Counselor', 'icon': Icons.favorite},
    {'name': 'Party Security', 'icon': Icons.security},
    {'name': 'Cleaning Service', 'icon': Icons.cleaning_services},
    {'name': 'Dancer', 'icon': Icons.directions_run},
    {'name': 'Dog Walker', 'icon': Icons.pets_outlined},
    {'name': 'Dating', 'icon': Icons.favorite_border},
    {'name': 'Jewelry', 'icon': Icons.auto_awesome}, // ✅ FIX
    {'name': 'Street Vendor', 'icon': Icons.storefront},
    {'name': 'Painter', 'icon': Icons.format_paint},
    {'name': 'Events', 'icon': Icons.event_available},
    {'name': 'Balloon Saloon', 'icon': Icons.bubble_chart},
    {'name': 'Nails Technician', 'icon': Icons.spa},
    {'name': 'Party Friends', 'icon': Icons.group},
    {'name': 'Party Host', 'icon': Icons.record_voice_over},
    {'name': 'Child Care', 'icon': Icons.child_friendly},
    {'name': 'Ministry', 'icon': Icons.church},
  ];

  final Map<String, IconData> iconMap = {
    'Icons.brush': Icons.brush,
    'Icons.camera_alt': Icons.camera_alt,
    'Icons.palette': Icons.palette,
    'Icons.mic': Icons.mic,
    'Icons.celebration': Icons.celebration,
    'Icons.face': Icons.face,
    'Icons.headphones': Icons.headphones,
    'Icons.content_cut': Icons.content_cut,
    'Icons.pets': Icons.pets,
    'Icons.cake': Icons.cake,
    'Icons.music_note': Icons.music_note,
    'Icons.nightlife': Icons.nightlife,
    'Icons.design_services': Icons.design_services,
    'Icons.checkroom': Icons.checkroom,
    'Icons.directions_bus': Icons.directions_bus,
    'Icons.local_mall': Icons.local_mall,
    'Icons.style': Icons.style,
    'Icons.restaurant': Icons.restaurant,
    'Icons.directions_car': Icons.directions_car,
    'Icons.person': Icons.person,
    'Icons.local_bar': Icons.local_bar,
    'Icons.location_city': Icons.location_city,
    'Icons.directions_boat': Icons.directions_boat,
    'Icons.wine_bar': Icons.wine_bar,
    'Icons.shopping_bag': Icons.shopping_bag,
    'Icons.event': Icons.event,
    'Icons.restaurant_menu': Icons.restaurant_menu,
    'Icons.favorite': Icons.favorite,
    'Icons.security': Icons.security,
    'Icons.cleaning_services': Icons.cleaning_services,
    'Icons.directions_run': Icons.directions_run,
    'Icons.pets_outlined': Icons.pets_outlined,
    'Icons.favorite_border': Icons.favorite_border,
    'Icons.auto_awesome': Icons.auto_awesome,
    'Icons.storefront': Icons.storefront,
    'Icons.format_paint': Icons.format_paint,
    'Icons.event_available': Icons.event_available,
    'Icons.bubble_chart': Icons.bubble_chart,
    'Icons.spa': Icons.spa,
    'Icons.group': Icons.group,
    'Icons.record_voice_over': Icons.record_voice_over,
    'Icons.child_friendly': Icons.child_friendly,
    'Icons.church': Icons.church,
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hot & Trending Categories"),),
      body:SingleChildScrollView(
        child: Obx(() {
          final data = controller.homeData.value!.data;
          final allcategory=data["data"]["categories_all"];
          print(allcategory);
          return Column(
            children: [
              Padding(padding: EdgeInsets.only(left: 15,right: 15),
                  child:GridView.builder(
                    shrinkWrap: true, // ✅ MUST
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allcategory.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final category = allcategory[index];

                      return CategoryCard(
                        icon: iconMap[category['app_icon']] ?? Icons.help_outline,
                        name: category['category_name'],
                        categoryId:int.parse(category['category_id']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListingsPage(
                                categoryId: int.parse(category['category_id']), // ✅ pass id
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
              ),
              SizedBox(height: 20,),
              BottomSection(),
            ],
          );
        })
      )
    );
  }
}
