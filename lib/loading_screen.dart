import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:music_player/search_page.dart';
import 'package:music_player/models/trie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  final Trie _trie = Trie();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _rotationController;
  Timer? _timer;
  bool _isActive = true;
  final List<String> messages = [
    'Unfolding words...',
    'Stirring syllables...',
    'Brewing meanings...',
    'Unlocking language...',
    'Weaving wonders...',
  ];
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _startMessageLoop();
    _loadData();
  }

  void _startMessageLoop() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isActive) return;
      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % messages.length;
      });
      _fadeController.forward(from: 0);
    });
  }

  Future<void> _loadData() async {
    final ref = FirebaseDatabase.instance.ref("trie_data");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      _trie.insertFromFirebase(data, _trie.root);
    }

    Future.delayed(const Duration(seconds: 10), () {
      if (!_isActive) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AutocompleteSearchPage(trie: _trie)),
      );
    });
  }

  @override
  void dispose() {
    _isActive = false;
    _fadeController.dispose();
    _rotationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5F6D), Color(0xFF9D50BB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                messages[_currentMessageIndex],
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
