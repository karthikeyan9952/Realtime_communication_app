import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:realtime_communication_app/constants/local_images.dart';
import 'package:realtime_communication_app/services/route/app_routes.dart';
import 'package:realtime_communication_app/utilities/providers.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      next();
      getToken();
    });
    super.initState();
  }

  getToken() async {
    userProvider.fcmToken = await FirebaseMessaging.instance.getToken();
  }

  void next() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SvgPicture.asset(LocalImages.splashImage),
      )),
    );
  }
}
