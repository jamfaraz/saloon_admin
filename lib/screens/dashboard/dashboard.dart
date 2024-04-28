
import 'package:barbar_app/screens/dashboard/my_posts.dart';
import 'package:barbar_app/screens/dashboard/post_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/data_controller.dart';
import '../../../../controllers/notification.dart';
import '../profile/profile.dart';
import 'home_screen.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  int selectedIndex = 0;
   LocalNotificationService localNotificationService=LocalNotificationService();
   AuthController authController=Get.put(AuthController());
 @override
  void initState() {
    super.initState();
    Get.put(DataController(), permanent: true);

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });
  localNotificationService.requestNotificationPermission();
    localNotificationService.forgroundMessage();
    localNotificationService.firebaseInit(context);
    localNotificationService.setupInteractMessage(context);
    localNotificationService.isTokenRefresh();
    LocalNotificationService.storeToken();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
       onWillPop: () async {
        if (selectedIndex != 0) {
          selectedIndex = 0;
          setState(() {});
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children:const  [
            HomeScreen(),
            PostScreen(),
            MyPostScreen(),
            Profile(),
           
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(0.7),
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          type: BottomNavigationBarType.shifting,
          selectedLabelStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black),
          unselectedLabelStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,size: 30,
                color: selectedIndex == 0 ? Colors.black : Colors.grey.shade400,
              ),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
           
           
            BottomNavigationBarItem(
              icon: Icon(
              Icons.add_box,size: 29,
                color: selectedIndex == 1 ? Colors.black : Colors.grey,
              ),
              label: 'Add',
              backgroundColor: Colors.white,
            ),
             BottomNavigationBarItem(
              icon: Icon(
              Icons.request_page,size: 29,
                color: selectedIndex == 2 ? Colors.black : Colors.grey,
              ),
              label: 'My posts',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,size: 28,
                color: selectedIndex == 3 ? Colors.black : Colors.grey,
              ),
              backgroundColor: Colors.white,
              label: 'Profile',
            ),
          
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
