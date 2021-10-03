import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barber_booking_app/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barber_booking_app/models/city_model.dart';
import 'package:flutter_barber_booking_app/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';

class BookingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFDF9EE),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            // Stepper
            NumberStepper(
              numbers: [1, 2, 3, 4, 5],
              stepColor: Colors.black,
              numberStyle: TextStyle(color: Colors.white),
              activeStep: step - 1,
              activeStepColor: Colors.grey,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              direction: Axis.horizontal,
            ),
            // Screen
            Expanded(child: step == 1 ? displayCityList() : Container()),
            // Buttons
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: step == 1
                            ? null
                            : () => context.read(currentStep).state--,
                        child: Text('PREVIOUS'),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: context.read(selectedCity).state == ''
                            ? null
                            : step == 5
                                ? null
                                : () => context.read(currentStep).state++,
                        child: Text('NEXT'),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  displayCityList() {
    return FutureBuilder(
      future: getCities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          var cities = snapshot.data as List<CityModel>;
          if (cities.length == 0)
            return Center(child: Text('Cannot load city list'));
          else
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      context.read(selectedCity).state = cities[index].name,
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${cities[index].name}',
                        style: GoogleFonts.robotoMono(),
                      ),
                      leading: Icon(Icons.home_work, color: Colors.black),
                      trailing:
                          context.read(selectedCity).state == cities[index].name
                              ? Icon(Icons.check)
                              : null,
                    ),
                  ),
                );
              },
            );
        }
      },
    );
  }
}
