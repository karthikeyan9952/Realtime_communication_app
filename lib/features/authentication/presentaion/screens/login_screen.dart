import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:realtime_communication_app/constants/local_images.dart';
import 'package:realtime_communication_app/features/authentication/models/user.dart';
import 'package:realtime_communication_app/features/authentication/presentaion/providers/login_provider.dart';
import 'package:realtime_communication_app/services/route/app_routes.dart';
import 'package:realtime_communication_app/utilities/keys.dart';
import 'package:realtime_communication_app/utilities/providers.dart';
import 'package:realtime_communication_app/widgets/buttons.dart';
import 'package:realtime_communication_app/widgets/space.dart';
import 'package:realtime_communication_app/widgets/text_fields.dart';
import 'package:realtime_communication_app/widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                SvgPicture.asset(LocalImages.login, width: 330),
                const TextAppBarHead(data: "Enter your phone number"),
                const HeightFull(),
                const HeightFull(),
                const HeightHalf(),
                TextFieldMobile(controller: _mobileController),
                const HeightFull(),
                const HeightHalf(),
                provider.isLoading
                    ? const CupertinoActivityIndicator(radius: 16)
                    : ElevatedButton(
                        onPressed: () {
                          provider.mobile = _mobileController.text;
                          provider.phoneSignIn(context);
                        },
                        child: const BtnText(label: "Continue")),
                const HeightFull(),
                const HeightFull(),
                const HeightHalf(),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Text("    Or    "),
                    Expanded(child: Divider()),
                  ],
                ),
                const HeightFull(),
                const HeightHalf(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 7),
                  child: SocialButton(
                    label: "Google",
                    imgPath: LocalImages.google,
                    voidCallback: () => provider.signInWithGoogle(context).then(
                        (GoogleSignInAccount account) => userProvider
                                .addUser(
                                    user: User(
                                        id: account.id,
                                        name: account.displayName,
                                        email: account.email,
                                        profilePicture: account.photoUrl,
                                        fcm: userProvider.fcmToken))
                                .then((value) async {
                              await _handleCameraPermission(Permission.camera);
                              await _handleMicPermission(Permission.microphone);
                              if (!mounted) {
                                return;
                              }
                              context.replace(AppRoutes.chats);
                            })),
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 28),
                  child: SocialButton(
                    label: "Facebook",
                    imgPath: LocalImages.facebook,
                    voidCallback: () {},
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _handleCameraPermission(Permission permission) async {
    final status = await permission.request();
    logger.i(status);
  }

  Future _handleMicPermission(Permission permission) async {
    final status = await permission.request();
    logger.i(status);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }
}
