import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barber_booking_app/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                        onPressed: step == 5
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
}
