import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String email;
  final String donorId;
  final String image;
  final String username;
  final String password;
  final String city;
  final String contact;
  final double latitude;
  final double longitude;
  const AccountModel({
    required this.email,
    required this.donorId,
    required this.image,
    required this.username,
    required this.password,
    required this.city,
    required this.contact,
    required this.latitude,
    required this.longitude,
  });

  static AccountModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final snapshot = document.data()!;

    return AccountModel(
      email: snapshot["email"],
      donorId: snapshot["donorId"],
      image: snapshot["image"],
      username: snapshot["username"],
      password: snapshot["password"],
      city: snapshot["city"],
      contact: snapshot["contact"],
      longitude: snapshot["longitude"],
      latitude: snapshot["latitude"],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'donorId': donorId,
        'image': image,
        'username': username,
        'password': password,
        'city': city,
        'contact': contact,
        "latitude": latitude,
        "longitude": longitude,
      };
}
