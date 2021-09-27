import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import 'package:flutter_barber_booking_app/screens/home_screen.dart';
import 'package:flutter_barber_booking_app/state/state_management.dart';
import 'package:flutter_barber_booking_app/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
              settings: settings,
              child: HomePage(),
              type: PageTransitionType.fade,
            );
          default:
            return null;
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context, watch) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldState,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/my_bg.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: checkLoginState(context, false),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else {
                          var userState = snapshot.data as LOGIN_STATE;
                          if (userState == LOGIN_STATE.LOGGED) {
                            return Container();
                          } else {
                            return ElevatedButton.icon(
                              onPressed: () => processLogin(context),
                              icon: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              label: Text(
                                'LOGIN WITH PHONE',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                            );
                          }
                        }
                      },
                    ))
              ],
            ),
          )),
    );
  }

  processLogin(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.phone()]).then((firebaseUser) async {
        //refresh state
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;
        // move to next screen
        await checkLoginState(context, true);
      }).catchError((e) {
        if (e is PlatformException) {
          if (e.code == FirebaseAuthUi.kUserCancelledError) {
            ScaffoldMessenger.of(scaffoldState.currentContext!)
                .showSnackBar(SnackBar(content: Text('${e.message}')));
          } else
            ScaffoldMessenger.of(scaffoldState.currentContext!)
                .showSnackBar(SnackBar(content: Text('Unk error')));
        }
      });
    } else {}
  }

  Future<LOGIN_STATE> checkLoginState(
      BuildContext context, bool fromLogin) async {
    await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
        .then((value) => {
              FirebaseAuth.instance.currentUser!.getIdToken().then((token) {
                // if get token then print it
                print(token);
                context.read(userToken).state = token;
                // and because user already login we will start new screen
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              })
            });

    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }
}
