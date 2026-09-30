import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MiCardPage(),
    );
  }
}

class MiCardPage extends StatelessWidget {
  const MiCardPage({super.key});

  // Theme primary orange color matching the sample interface
  static const Color primaryOrange = Color(0xFFF15B2A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryOrange,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Profile Avatar from images/ asset directory
                const CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('images/avatar.png'),
                ),
                const SizedBox(height: 10.0),

                // 2. Name with Pacifico cursive font
                Text(
                  'ThinkPad E14',
                  style: GoogleFonts.pacifico(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 3. Profession / Title
                Text(
                  'FLUTTER DEVELOPER',
                  style: GoogleFonts.sourceSans3(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 18.0,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 4. Divider Line
                SizedBox(
                  height: 25.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.white.withValues(alpha: 0.7),
                    thickness: 1.0,
                  ),
                ),

                // 5. Phone Number Card
                Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.phone_fill,
                      color: primaryOrange,
                    ),
                    title: Text(
                      '+84 394 281 107',
                      style: GoogleFonts.sourceSans3(
                        color: primaryOrange,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // 6. Email Card
                Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.mail_solid,
                      color: primaryOrange,
                    ),
                    title: Text(
                      'flutter.developer@gmail.com',
                      style: GoogleFonts.sourceSans3(
                        color: primaryOrange,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
