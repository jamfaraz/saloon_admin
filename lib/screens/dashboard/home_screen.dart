import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/profile_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 44,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('barbars')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Column(
                              children: snapshot.data?.docs.map((e) {
                                    return Column(
                                      children: [
                                        e["donorId"] ==
                                                FirebaseAuth
                                                    .instance.currentUser?.uid
                                            ? Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            e['image'],),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Hello ,',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF0C253F),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        e['username'],
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : const SizedBox()
                                      ],
                                    );
                                  }).toList() ??
                                  []);
                        }
                      }),

                  // IconButton(
                  //   onPressed: () {
                  //     Get.to(()=>const UserNotificationScreen());
                  //   },
                  //   icon: const Icon(
                  //     Icons.notification_add,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
              const Divider(),
             22.heightBox,
                   Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                    controller: searchController,
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      hintText: 'Search by names',
                      border: InputBorder.none,
                      prefixIcon: (searchText.isEmpty)
                          ? const Icon(
                              Icons.search,
                              color: Colors.red,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                searchText = '';
                                searchController.clear();
                                setState(() {});
                              },
                            ),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    }),
              ),
                22.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Orders',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.to(() => const AllScheduleScreen());
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                //
                //

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * .4),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * .34),
                      child: const Center(
                        child: Text(
                          'No post available yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                      ),
                    );
                  } else {
                    //

                    return Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length ?? 0,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Card(
                                  shadowColor: Colors.black,
                                  color: Colors.white,
                                  elevation: 13,
                                  child: Container(
                                    // height: 166,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      data['image']),
                                                ),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  data['username'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF474747),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                   Text(
                                                    'Category',
                                                    style: TextStyle(
                                                      color: Colors.red.shade400,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    data['category'],
                                                    style: const TextStyle(
                                                      color: Color(0xFF474747),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                 Text(
                                                  'Address',
                                                  style: TextStyle(
                                                    color: Colors.red.shade400,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  data['address'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF474747),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                         Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                     Text(
                                                      'Contact',
                                                      style: TextStyle(
                                                        color: Colors.red.shade400,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['contact'],
                                                      style: const TextStyle(
                                                        color: Color(0xFF474747),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                 Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                     Text(
                                                      'Price',
                                                      style: TextStyle(
                                                        color: Colors.red.shade400,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['price'],
                                                      style: const TextStyle(
                                                        color: Color(0xFF474747),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                           ],
                                         ),
                                    
                                       
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('userId',
                                                  isEqualTo: data['userId'])
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            return Column(
                                                children:
                                                    snapshot.data?.docs
                                                            .map((e) {
                                                          return Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  // DocumentSnapshot<
                                                                  //         Map<String, dynamic>>
                                                                  //     document =
                                                                  //     await FirebaseFirestore.instance
                                                                  //         .collection('donors')
                                                                  //         .doc(FirebaseAuth.instance
                                                                  //             .currentUser!.uid)
                                                                  //         .get();
                                                                  // final userData = document.data()!;
                                                                  // String userName =
                                                                  //     userData['username'];

                                                                  // dataController.createNotification(
                                                                  //   userId: data['userId'],
                                                                  //   message:
                                                                  //       '$userName accepted your request now you can chat with each other',
                                                                  // );
                                                                  // LocalNotificationService
                                                                  //     .sendNotification(
                                                                  //         title: 'Request Accepted',
                                                                  //         message:
                                                                  //             '$userName accepted your request',
                                                                  //         token: data['fcmToken']);
                                                                  // Get.to(() =>
                                                                  //     ChatScreen(
                                                                  //       fcmToken:
                                                                  //           e['fcmToken'],
                                                                  //       name: e[
                                                                  //           'username'],
                                                                  //       image: e[
                                                                  //           'image'],
                                                                  //       uid: e[
                                                                  //           'userId'],
                                                                  //       groupId: FirebaseAuth
                                                                  //           .instance
                                                                  //           .currentUser!
                                                                  //           .uid,
                                                                      // ));
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: Get
                                                                              .width *
                                                                          .44),
                                                                  height: 34,
                                                                  width:
                                                                      Get.width *
                                                                          .4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .red
                                                                        .shade400,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Accept',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }).toList() ??
                                                        []);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
