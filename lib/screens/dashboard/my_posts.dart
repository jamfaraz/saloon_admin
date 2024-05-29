// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/profile_controller.dart';

// class MyPostScreen extends StatefulWidget {
//   const MyPostScreen({super.key});

//   @override
//   State<MyPostScreen> createState() => _MyPostScreenState();
// }

// class _MyPostScreenState extends State<MyPostScreen> {
//   String searchText = "";
//   TextEditingController searchController = TextEditingController();
//   ProfileController profileController = Get.put(ProfileController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, centerTitle: true,
//          title: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:  [

//             Text(
//               'My Posts',
//               style: TextStyle(
//                 color: Color(0xFF1A1A1A),
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         elevation: 1,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('posts')
//                     .where('userId',
//                         isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                     .orderBy('time', descending: true)
//                     .snapshots(),
//                 //
//                 //

//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Padding(
//                       padding: EdgeInsets.only(top: Get.height * .4),
//                       child: const Center(child: CircularProgressIndicator()),
//                     );
//                   } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Padding(
//                       padding: EdgeInsets.only(top: Get.height * .4),
//                       child: const Center(
//                         child: Text(
//                           'You have not any post yet.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.redAccent),
//                         ),
//                       ),
//                     );
//                   } else {
//                     //

//                     return Column(
//                       children: [
//                         ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data?.docs.length ?? 0,
//                           physics: const BouncingScrollPhysics(),
//                           padding: EdgeInsets.zero,
//                           itemBuilder: (context, index) {
//                             final data = snapshot.data!.docs[index];

//                             return Column(
//                               children: [
//                                 const SizedBox(
//                                   height: 4,
//                                 ),
//                                   Card(
//                                   shadowColor: Colors.black,
//                                   color: Colors.white,
//                                   elevation: 13,
//                                   child: Container(
//                                     // height: 166,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 14, vertical: 12),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Row(children: [
//                                           const Text(
//                                             'Barbar name :',
//                                             style: TextStyle(
//                                               color: Colors.green,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           Text(
//                                             data['username'],
//                                             style: const TextStyle(
//                                               color: Color(0xFF474747),
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                         ]),
//                                         const SizedBox(
//                                           height: 6,
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Text(
//                                               'Price:',
//                                               style: TextStyle(
//                                                 color: Colors.green,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 73,
//                                             ),
//                                             Text(
//                                               'Rs.${data['price']}',
//                                               style: const TextStyle(
//                                                 color: Color(0xFF474747),
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           height: 6,
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Text(
//                                               'Address:',
//                                               style: TextStyle(
//                                                 color: Colors.green,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 51,
//                                             ),
//                                             Text(
//                                               data['address'],
//                                               style: const TextStyle(
//                                                 color: Color(0xFF474747),
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           height: 6,
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Text(
//                                               'Category:',
//                                               style: TextStyle(
//                                                 color: Colors.green,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 44,
//                                             ),
//                                             Flexible(
//                                               child: Text(
//                                                 data['category'],
//                                                 style: const TextStyle(
//                                                   color: Color(0xFF474747),
//                                                   fontSize: 14,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                              showDialog(
//                                                     context: context,
//                                                     builder:
//                                                         (context) =>
//                                                             AlertDialog(
//                                                               title: const Text(
//                                                                   "Are you sure ?"),
//                                                               content: const Text(
//                                                                   "Click Confirm if you want to delete this item"),
//                                                               actions: [
//                                                                 TextButton(
//                                                                     onPressed:
//                                                                         () {
//                                                                       Navigator.pop(
//                                                                           context);
//                                                                     },
//                                                                     child: const Text(
//                                                                         "Cancel")),
//                                                                 TextButton(
//                                                                     onPressed:
//                                                                         ()  {
//                                                                        profileController
//                                                                           .deletePost(
//                                                                               data.id);
//                                                                       Get.back();
//                                                                     },
//                                                                     child:
//                                                                         const Text(
//                                                                       "Delete",
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color: Colors
//                                                                             .red,
//                                                                       ),
//                                                                     ))
//                                                               ],
//                                                             ));
//                                           ;},
//                                           child: Container(
//                                             margin: EdgeInsets.only(
//                                                 left: Get.width * .44),
//                                             height: 34,
//                                             width: Get.width * .4,
//                                             decoration: BoxDecoration(
//                                               color: Colors.red.shade400,
//                                               borderRadius:
//                                                   BorderRadius.circular(6),
//                                             ),
//                                             child: const Center(
//                                               child: Text(
//                                                 'Delete',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),

//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';

import '../../controllers/profile_controller.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Posts',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                      padding: EdgeInsets.only(top: Get.height * .4),
                      child: const Center(
                        child: Text(
                          'You have not any post yet.',
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
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length ?? 0,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: Get.height * .32,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                GridTile(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        // Image.network(data['itemImage']),
                                        Container(
                                          height: Get.height * .12,
                                          width: Get.size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      topLeft: Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      data['itemImage']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_pin,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(child: Text(data['address']))
                                          ],
                                        ),
                                  
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.numbers,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(data['price'])
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.category,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(
                                                child: Text(data['category']))
                                          ],
                                        ),
                                  
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                "Are you sure ?"),
                                                            content: const Text(
                                                                "Click Confirm if you want to delete this item"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      "Cancel")),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    profileController
                                                                        .deletePost(
                                                                            data.id);
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Delete",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ))
                                                            ],
                                                          ));
                                                },
                                                child: const Text(
                                                  'delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ],
                                        )
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
