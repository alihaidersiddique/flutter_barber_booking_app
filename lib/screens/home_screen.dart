import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barber_booking_app/cloud_firestore/user_ref.dart';
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
