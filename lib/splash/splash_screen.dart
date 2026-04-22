import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../login/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // 🎬 Animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // 🔊 Play audio (FIXED PATH)
    Future.delayed(const Duration(milliseconds: 300), () async {
      try {
        await _audioPlayer.setVolume(0.8);

        await _audioPlayer.setReleaseMode(ReleaseMode.stop);

        await _audioPlayer.play(
          AssetSource('audio/intro_sound.mp3'), // ✅ FIXED
        );
      } catch (e) {
        debugPrint("Audio error: $e");
      }
    });

    // ⏳ Navigate after splash
    Timer(const Duration(seconds: 3), () async {
      await _fadeOutAudio();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    });
  }

  // 🔉 Smooth fade-out
  Future<void> _fadeOutAudio() async {
    double volume = 0.8;

    for (int i = 0; i < 8; i++) {
      volume -= 0.1;
      if (volume < 0) volume = 0;

      await _audioPlayer.setVolume(volume);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'assets/image/splash.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}