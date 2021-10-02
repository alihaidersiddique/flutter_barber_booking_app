import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barber_booking_app/cloud_firestore/banner_ref.dart';
import 'package:flutter_barber_booking_app/cloud_firestore/lookbook_ref.dart';
import 'package:flutter_barber_booking_app/cloud_firestore/user_ref.dart';
import 'package:flutter_barber_booking_app/models/image_model.dart';
import 'package:flutter_barber_booking_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFDFDFDF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //UserProfile
              FutureBuilder(
                future: getUserProfiles(
                    FirebaseAuth.instance.currentUser!.phoneNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var userModel = snapshot.data as UserModel;
                    return Container(
                      decoration: BoxDecoration(color: Color(0xFF383838)),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black,
                            maxRadius: 30,
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userModel.name}',
                                  style: GoogleFonts.robotoMono(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${userModel.address}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              // Menu
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.book_online, size: 50),
                              Text(
                                'Booking',
                                style: GoogleFonts.robotoMono(),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart, size: 50),
                              Text(
                                'Cart',
                                style: GoogleFonts.robotoMono(),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 50),
                              Text(
                                'History',
                                style: GoogleFonts.robotoMono(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              // Banner
              FutureBuilder(
                future: getBanners(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var banners = snapshot.data as List<ImageModel>;

                    return CarouselSlider(
                      items: banners
                          .map(
                            (e) => Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(e.image),
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        aspectRatio: 3.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
              // Lookbook
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'LOOKBOOK',
                      style: GoogleFonts.robotoMono(fontSize: 24),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: getLookbook(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var lookbook = snapshot.data as List<ImageModel>;
                    return Column(
                        children: lookbook
                            .map((e) => Container(
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(e.image),
                                  ),
                                ))
                            .toList());
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
