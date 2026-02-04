import 'package:get/get.dart';
import 'package:new_app/screens/about_screen.dart';
import 'package:new_app/screens/addlisting_screen.dart';
import 'package:new_app/screens/addmyidea_screen.dart';
import 'package:new_app/screens/blogcomplete_screen.dart';
import 'package:new_app/screens/blogs_screen.dart';
import 'package:new_app/screens/contactus_screen.dart';
import 'package:new_app/screens/conversatin_screen.dart';
import 'package:new_app/screens/disclamer_screen.dart';
import 'package:new_app/screens/forgotpassword_screen.dart';
import 'package:new_app/screens/fqa_screen.dart';
import 'package:new_app/screens/home_page.dart';
import 'package:new_app/screens/inquiries_screen.dart';
import 'package:new_app/screens/myidea_screen.dart';
import 'package:new_app/screens/myinbox_screen.dart';
import 'package:new_app/screens/mylisting_screen.dart';
import 'package:new_app/screens/myprofile_screen.dart';
import 'package:new_app/screens/ourvideos_screen.dart';
import 'package:new_app/screens/plan_screen.dart';
import 'package:new_app/screens/privacy_policy_screen.dart';
import 'package:new_app/screens/tems_screen.dart';
import 'package:new_app/screens/topcategory_page.dart';
import 'package:new_app/screens/viewideas_screen.dart';
import 'package:new_app/screens/widgets/guest_sign_in.dart';
import 'package:new_app/screens/widgets/guest_sign_up_dart.dart';
import 'package:new_app/screens/widgets/map.dart';
import 'package:new_app/screens/widgets/vendor_sign_in.dart';
import 'package:new_app/screens/widgets/vendor_sign_up.dart';
import './app_routes.dart';
import './home_binding.dart';
class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    // AUTH
    GetPage(
      name: AppRoutes.vsigin,
      page: () => const VendorSignIn(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.vsignup,
      page: () => const VendorSignUp(),
      // binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.gsigin,
      page: () => const GuestSignIn(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.gsigup,
      page: () => const GuestSignUp(),
      // binding: AuthBinding(),
    ),

    // HOME
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),


    // BLOG
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutScreen(),
      // binding: BlogBinding(),
    ),
    GetPage(
      name: AppRoutes.blogs,
      page: () => const BlockScreen(),
    ),
    GetPage(
      name: AppRoutes.topcategory,
      page: () => const TopCategoryScreen(),
    ),
    GetPage(
      name: AppRoutes.contactus,
      page: () => const ContactUsScreen(),
    ),
    GetPage(
        name: AppRoutes.ourvideo,
        page:()=> OurVideoScreen()
    ),
    GetPage(
      name:AppRoutes.forgotpassword,
      page:()=>ForgotPasswordScreen(),
    ),
    GetPage(
      name:AppRoutes.myprofile,
      page:()=>MyProfileScreen(),
    ),
    GetPage(
      name:AppRoutes.myideas,
      page:()=>MyIdeaScreen(),
    ),
    GetPage(
      name:AppRoutes.addmyidea,
      page:()=>AddMyIdeaScreen()
    ),
    GetPage(
      name:AppRoutes.addlistings,
      page:()=>AddListingScreen()
    ),
    GetPage(
        name: AppRoutes.mylisting,
        page: ()=>MyListingScreen()
    ),
    GetPage(
      name:AppRoutes.myinbox,
      page:()=>MyInboxScreen()
    ),
    GetPage(
      name:AppRoutes.conversation,
      page:()=>ChatScreen()
    ),
    GetPage(
      name:AppRoutes.plan,
      page: ()=>PricingScreen()
    ),
    GetPage(
        name:AppRoutes.viewideas ,
        page:()=>ViewIdeasScreen()
    ),
    GetPage(
      name:AppRoutes.terms,
      page:()=>TermScreen()
    ),
    GetPage(
      name:AppRoutes.privacypolicy,
      page:()=>PrivacyPolicyScreen()
    ),
    GetPage(
      name:AppRoutes.disclaimer,
      page:()=>DisclaimerScreen()
    ),
    GetPage(
      name:AppRoutes.faq,
      page:()=>FAQScreen()
    ),
    GetPage(
      name:AppRoutes.inquirie,
      page:()=>InquiriesScreen()
    ),
    GetPage(
      name:AppRoutes.blogcomplete,
      page:()=>BlogcompleteScreen()
    ),

  ];
}
