import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/profile_controller.dart';
import 'all_schedule.dart';

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
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('barbars')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                        children: snapshot.data?.docs.map((e) {
                              return Column(
                                children: [
                                  e["donorId"] ==
                                          FirebaseAuth.instance.currentUser?.uid
                                      ? Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundImage: NetworkImage(
                                                e['image'],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Hello ,',
                                                  style: TextStyle(
                                                    color: Color(0xFF0C253F),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  e['username'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF5A5A5A),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      contentPadding: EdgeInsets.only(top: 12),
                      hintText: 'Search by name',
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
                      Get.to(() => const AllScheduleScreen());
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
              const SizedBox(height: 8),
              _buildAppointmentsStream(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsStream() {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'pending')
          .where('barberId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('time', descending: true)
         
          .where(
            'date',
            isEqualTo: date,
          )
          .snapshots(),
      //
      //

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 188),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 188),
            child: Center(
              child: Text(
                'No booking for today.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
            ),
          );
        } else {
//

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length ?? 0,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final appointment = snapshot.data!.docs[index];
                  final orderTime =
                      (appointment['orderTime'] as Timestamp).toDate();
                  final currentTime = DateTime.now();
                  final difference = currentTime.difference(orderTime);

                  String timerText = '';
                  if (appointment['status'] == 'pending') {
                    final minutesLeft = 30 - difference.inMinutes;
                    final secondsLeft = 60 - difference.inSeconds % 60;
                    timerText = '${minutesLeft}m ${secondsLeft}s';
                  } else {
                    timerText = appointment['status'];
                  }
                    if (appointment["name"]
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase())) {

                  return Column(
                    children: [
                      Card(
                        shadowColor: Colors.black,
                        color: Colors.white,
                        elevation: 13,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: 0,
                            leading: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                appointment['image'],
                              ),
                            ),
                            title: Text(
                              appointment['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Time left: ${_formatTimer(orderTime)} \n${appointment['date']} ',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            trailing: appointment['status'] == 'pending'
                                ? ElevatedButton(
                                    onPressed: () =>
                                        _acceptOrder(appointment['caseId']),
                                    child: const Text('Accept',style: TextStyle(color: Colors.red)),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                 } },
              ),
            ],
          );
        }
      },
    );
  }

  Timer? _timer;

  void _acceptOrder(String orderId) {
    FirebaseFirestore.instance.collection('appointments').doc(orderId).update({
      'status': 'completed',
    }).then((_) {
      _timer?.cancel();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(DateTime orderTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(orderTime);
    final minutesLeft = 30 - difference.inMinutes;
    final secondsLeft = 59 - difference.inSeconds % 60;

    if (minutesLeft < 0) {
      return '0m 0s';
    } else {
      return '${minutesLeft}m ${secondsLeft}s';
    }
  }
}
