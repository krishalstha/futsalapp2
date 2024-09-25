import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../display_screen/BookedScreen.dart';
import '../display_screen/UserProfile.dart';
import '../display_screen/home.dart';

class UserNavigationMenu extends StatelessWidget {
  final String userId;

  UserNavigationMenu({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 60,
          elevation: 10,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.changeScreen(index),
          backgroundColor: Colors.white,
          indicatorColor: Colors.teal.withOpacity(0.3),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.calendar), label: 'Booked'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    MyHome(),
    BookedScreen(),
    UserProfile(),
  ];

  void changeScreen(int index) {
    selectedIndex.value = index;
  }
}
