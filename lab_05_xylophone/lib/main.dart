import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: XylophoneApp(),
  ));
}

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({super.key});

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _player.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void playSound(int soundNumber) async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('note$soundNumber.wav'),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      debugPrint('Error playing note $soundNumber: $e');
    }
  }

  Widget buildKey({required Color color, required int soundNumber}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            playSound(soundNumber);
          },
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildKey(color: const Color(0xFFE53935), soundNumber: 1), // Red
            buildKey(color: const Color(0xFFFF9800), soundNumber: 2), // Orange
            buildKey(color: const Color(0xFFFFEB3B), soundNumber: 3), // Yellow
            buildKey(color: const Color(0xFF4CAF50), soundNumber: 4), // Green
            buildKey(color: const Color(0xFF009688), soundNumber: 5), // Teal
            buildKey(color: const Color(0xFF2196F3), soundNumber: 6), // Blue
            buildKey(color: const Color(0xFF9C27B0), soundNumber: 7), // Purple
          ],
        ),
      ),
    );
  }
}
