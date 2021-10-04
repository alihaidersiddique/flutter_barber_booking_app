import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barber_booking_app/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_barber_booking_app/models/barber_model.dart';
import 'package:flutter_barber_booking_app/models/city_model.dart';
import 'package:flutter_barber_booking_app/models/salon_model.dart';
import 'package:flutter_barber_booking_app/state/state_management.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';

class BookingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var barberWatch = watch(selectedBarber).state;

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
            Expanded(
              child: step == 1
                  ? displayCityList()
                  : step == 2
                      ? displaySalon(cityWatch.name!)
                      : step == 3
                          ? displayBarber(salonWatch)
                          : Container(),
            ),
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
                        onPressed: (step == 1 &&
                                    context.read(selectedCity).state.name ==
                                        '') ||
                                (step == 2 &&
                                    context.read(selectedSalon).state.docId ==
                                        '') ||
                                (step == 3 &&
                                    context.read(selectedBarber).state.docId ==
                                        '')
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
                  onTap: () => context.read(selectedCity).state = cities[index],
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${cities[index].name}',
                        style: GoogleFonts.robotoMono(),
                      ),
                      leading: Icon(Icons.home_work, color: Colors.black),
                      trailing: context.read(selectedCity).state.name ==
                              cities[index].name
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

  displaySalon(String cityName) {
    return FutureBuilder(
      future: getSalonByCity(cityName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          var salons = snapshot.data as List<SalonModel>;
          if (salons.length == 0)
            return Center(child: Text('Cannot load salon list'));
          else
            return ListView.builder(
              itemCount: salons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      context.read(selectedSalon).state = salons[index],
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${salons[index].name}',
                        style: GoogleFonts.robotoMono(),
                      ),
                      subtitle: Text(
                        '${salons[index].address}',
                        style:
                            GoogleFonts.robotoMono(fontStyle: FontStyle.italic),
                      ),
                      leading: Icon(Icons.home_outlined, color: Colors.black),
                      trailing: context.read(selectedSalon).state.docId ==
                              salons[index].docId
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

  displayBarber(SalonModel salonModel) {
    return FutureBuilder(
      future: getBarberBySalon(salonModel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          var barbers = snapshot.data as List<BarberModel>;
          if (barbers.length == 0)
            return Center(child: Text('Barber list are empty'));
          else
            return ListView.builder(
              itemCount: barbers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      context.read(selectedBarber).state = barbers[index],
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${barbers[index].name}',
                        style: GoogleFonts.robotoMono(),
                      ),
                      subtitle: RatingBar.builder(
                        allowHalfRating: true,
                        itemSize: 16,
                        initialRating: barbers[index].rating,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemPadding: const EdgeInsets.all(4),
                        onRatingUpdate: (double value) {},
                      ),
                      leading: Icon(Icons.person, color: Colors.black),
                      trailing: context.read(selectedBarber).state.docId ==
                              barbers[index].docId
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
