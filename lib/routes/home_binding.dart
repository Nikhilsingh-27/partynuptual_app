import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/profile_image_controller.dart';
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(),fenix: true,);
    Get.lazyPut<AuthenticationController>(() => AuthenticationController());
    Get.lazyPut<ProfileImageController>(() => ProfileImageController());
  }
}
