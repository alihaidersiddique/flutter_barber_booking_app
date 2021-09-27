import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                label: Text(
                  'LOGIN WITH PHONE',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
