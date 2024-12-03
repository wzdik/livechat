import 'package:flutter/material.dart';
import 'package:kedelai_hub/app/auth/auth_controller.dart';
import 'package:kedelai_hub/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kedelai_hub/app/auth/auth_controller.dart';

class BottomNavigationBarComponent extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavigationBarComponent({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _authController.isPenjual.value == 'Penjual'
                ? const Icon(Icons.chat)
                : const Icon(Icons.shopping_cart),
            label: _authController.isPenjual.value == 'Penjual'
                ? 'Live Chat'
                : 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
