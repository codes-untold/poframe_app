import 'package:flutter/material.dart';
import 'package:poframer/widgets/my_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(seconds: 3),
              pageBuilder: (_, __, ___) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(tag: "DemoTag", child: Image.asset("images/lp_icon.png")),
      ),
    );
  }
}
