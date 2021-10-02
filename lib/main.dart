import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // fix login null
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                      future: checkLoginState(context, false, scaffoldState),
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
        await checkLoginState(context, true, scaffoldState);
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

  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState) async {
    if (!context.read(forceReload).state) {
      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
          .then((value) => {
                FirebaseAuth.instance.currentUser!
                    .getIdToken()
                    .then((token) async {
                  context.read(userToken).state = token;
                  // check user in firestore
                  CollectionReference userRef =
                      FirebaseFirestore.instance.collection('User');
                  DocumentSnapshot snapshotUser = await userRef
                      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                      .get();
                  // force reload state
                  context.read(forceReload).state = true;
                  if (snapshotUser.exists) {
                    // and because user already login we will start new screen
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  } else {
                    // if user info not available show dialog
                    var nameController = TextEditingController();
                    var addressController = TextEditingController();

                    Alert(
                      context: context,
                      title: 'UPDATE PROFILES',
                      content: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                icon: Icon(Icons.account_circle),
                                labelText: 'Name'),
                            controller: nameController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                icon: Icon(Icons.home), labelText: 'Address'),
                            controller: addressController,
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          child: Text('CANCEL'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        DialogButton(
                          child: Text('UPDATE'),
                          onPressed: () {
                            // update to server
                            userRef
                                .doc(FirebaseAuth
                                    .instance.currentUser!.phoneNumber)
                                .set({
                              'name': nameController.text,
                              'address': addressController.text,
                            }).then((value) async {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(
                                      scaffoldState.currentContext!)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                          'PROFILES UPDATED SUCCESSFULLY!')));
                              await Future.delayed(Duration(seconds: 1), () {
                                // and because user already login we will start new screen
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (route) => false);
                              });
                            }).catchError((e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(
                                      scaffoldState.currentContext!)
                                  .showSnackBar(SnackBar(content: Text('$e')));
                            });
                          },
                        ),
                      ],
                    ).show(); // dont forget show()
                  }
                })
              });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }
}
