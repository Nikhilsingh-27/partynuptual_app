


import 'package:flutter/material.dart';
import 'package:new_app/screens/blogs_screen.dart';
import 'package:new_app/screens/widgets/autoscrollforideas.dart';
import 'package:new_app/screens/widgets/profile.dart';
import 'package:new_app/screens/widgets/autoscrollrecentlyadded.dart';
import 'package:new_app/screens/widgets/searchwidget.dart';
import 'package:new_app/screens/widgets/vendor_sign_in.dart';

import 'package:new_app/screens/widgets/signin.dart';
import 'package:new_app/screens/widgets/signup.dart';
import 'dart:async';
import 'listings_page.dart';
import 'business_detail_page.dart';
import 'package:new_app/screens/about_screen.dart';
import 'package:new_app/screens/widgets/block_card.dart';
import 'package:new_app/screens/widgets/party_card.dart';
import 'package:new_app/screens/widgets/listing_card.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/widgets/category_card.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final partyurl="https://partynuptual.com/public";

  final HomeController controller = Get.put(HomeController());

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;



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
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

    void _startAutoScroll() {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        final banners = controller.homeData.value?.data["data"]["banners"];

        if (banners == null || banners.isEmpty) return;

        final int length = banners.length; // ✅ int guaranteed

        _currentPage = (_currentPage + 1) % length;

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    final homeCategories = categories.take(6).toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 100,
          toolbarHeight: 90,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/logo.jpg'),
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.grey[900]),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white,

                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ProfileDropdownTile(),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  "Home", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/home");
                }
            ),

            ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text(
                  "About", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/about");
                }
            ),
            ListTile(
                leading: const Icon(Icons.article),
                title: const Text(
                  "Blogs", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/blogs");
                }
            ),
            ListTile(
                leading: const Icon(Icons.apps),
                title: const Text(
                  "Top Categories", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/topcategory");
                }
            ),
            ListTile(
                leading: const Icon(Icons.mail),
                title: const Text(
                  "Contact Us", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/contactus");
                }
            ),
            ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text(
                  "My inquiries", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/inquirie");
                }
            ),
            ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text(
                  "Our Videos", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Get.toNamed("/ourvideo");
                }

            ),

            SignInDropdown(),
            SignUpDropdown(),
            ListTile(
              leading:const Icon(Icons.lock_outline),
              title: const Text(
                "Forgot Password",style: TextStyle(fontWeight: FontWeight.bold)
              ),
              onTap: (){
                Get.toNamed("/forgotpassword");
              },
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.homeData.value == null) {
          return const Center(child: Text("No Data"));
        }

        final data = controller.homeData.value!.data;

        final banners=data["data"]["banners"];
        final listings=data["data"]["listings"];
        final blogs=data["data"]["blogs"];
        final topcategory=data["data"]["categories"];
        // print(topcategory);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section with Auto-changing Banner
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://partynuptual.com/public/uploads/banner/${banners[index]["image"]}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );

                      },
                    ),

                    // Page Indicators
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          banners.length,
                              (index) =>
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SearchWidget(),
              SizedBox(height: 40,),
              // Connect With Your Community Vendors Section
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Connect With Your Community ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const Text(
                          'VENDOR',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                            Icons.auto_awesome, color: Colors.red, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our Top Categories',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Categories Grid
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true, // ⭐ REQUIRED
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeCategories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final category = topcategory[index];
                      // print(category['app_icon']);
                      return CategoryCard(
                        icon: iconMap[category['app_icon']] ?? Icons.help_outline,
                        name: category['category_name'],
                        categoryId: int.parse(category['category_id']),
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
              const SizedBox(height: 20),

              // View All Categories Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/topcategory");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 32,
                    //   vertical: 12,
                    // ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View All Categories'),
                ),
              ),
              const SizedBox(height: 20),

              // Recently Added Listings Section
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Recently Added ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const Text(
                          'Listings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                            Icons.auto_awesome, color: Colors.red, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore Hot & Popular Business Listings.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Business Listings Cards
              AutoScrollCards(),
              const SizedBox(height: 30),

              // Let Us Know How You Did Your Party Section
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Let Us Know How You Did Your ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const Text(
                          'Party',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                            Icons.auto_awesome, color: Colors.red, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Party Cards - 2 columns layout
              AutoScrollPartyCards(),

              // View More Button for Party Section
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/viewideas");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View More'),
                ),
              ),
              const SizedBox(height: 30),

              // Our Latest Blogs Section
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Our Latest ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const Text(
                          'Blogs',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                            Icons.auto_awesome, color: Colors.red, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Blog Cards - 2 columns layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: buildBlogCard(
                        image: "$partyurl/uploads/blogs/${blogs[0]['image']}",
                        title: "${blogs[0]['heading']}",
                        description:
                        "${blogs[0]['description']}",
                        date: "${blogs[0]['back_date']}",
                        tag: "${blogs[0]['category']}",
                        author:"${blogs[0]['author']}"
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildBlogCard(
                        image: "$partyurl/uploads/blogs/${blogs[1]['image']}",
                        title: "${blogs[1]['heading']}",
                        description:
                        "${blogs[1]['description']}",
                        date: "${blogs[1]['back_date']}",
                        tag: "${blogs[1]['category']}",
                        author:"${blogs[1]['author']}"
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // View More Button for Blogs Section
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/blogs");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View More'),
                ),
              ),
              const SizedBox(height: 50),
              BottomSection(),
            ],
          ),
        );
      })
    );
  }
}
