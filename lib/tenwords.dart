import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';
import 'package:music_player/home_page.dart';
import 'package:music_player/secret.dart';

class TenWordsPage extends StatefulWidget {
  const TenWordsPage({Key? key}) : super(key: key);

  @override
  State<TenWordsPage> createState() => _TenWordsPageState();
}

class _TenWordsPageState extends State<TenWordsPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    'trie_data',
  );
  final String apiKey = Secrets.merriamApiKey;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PageController _controller = PageController(viewportFraction: 0.85);
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
  final today = DateTime.now();
  late ConfettiController _confettiController;

  List<Map<String, String>> _wordsWithData = [];
  bool _showConfetti = false;
  bool _alreadySeen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _fetchWordsFromTrie();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _fetchWordsFromTrie() async {
    try {
      final snapshot = await _dbRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<String> allWords = [];
        _traverseTrie(data, "", allWords);
        allWords.shuffle();

        List<Map<String, String>> results = [];
        int index = 0;

        while (results.length < 10 && index < allWords.length) {
          String word = allWords[index];
          final result = await _fetchMeaningAndAudio(word);
          if (result != null) results.add(result);
          index++;
        }

        setState(() => _wordsWithData = results);
      }
    } catch (e) {
      print(" Error: $e");
    }
  }

  Future<Map<String, String>?> _fetchMeaningAndAudio(String word) async {
    final url =
        'https://www.dictionaryapi.com/api/v3/references/learners/json/$word?key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty && data[0] is Map) {
          final entry = data[0];
          final defs = entry['shortdef'];
          final def = defs != null && defs.isNotEmpty ? defs[0] : null;
          final soundData = entry['hwi']?['prs']?[0]?['sound']?['audio'];

          if (def != null && soundData != null) {
            final subDir = _getSubdirectory(soundData);
            final audioUrl =
                'https://media.merriam-webster.com/audio/prons/en/us/mp3/$subDir/$soundData.mp3';
            return {'word': word, 'meaning': def, 'audio': audioUrl};
          }
        }
      }
    } catch (e) {
      print("Error getting data for $word: $e");
    }
    return null;
  }

  String _getSubdirectory(String soundName) {
    if (soundName.startsWith('bix')) return 'bix';
    if (soundName.startsWith('gg')) return 'gg';
    final ch = soundName[0];
    return RegExp(r'[a-zA-Z]').hasMatch(ch) ? ch : 'number';
  }

  void _traverseTrie(
    Map<dynamic, dynamic> node,
    String prefix,
    List<String> words,
  ) {
    if (node['isWord'] == true || node['end'] == true) {
      words.add(prefix);
    }
    for (var entry in node.entries) {
      if (entry.key != 'isWord' && entry.key != 'end' && entry.value is Map) {
        _traverseTrie(entry.value, prefix + entry.key, words);
      }
    }
  }

  void _playAudio(String url) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _triggerConfettiAndRedirect() {
    if (_showConfetti) return; // Already triggered once

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _showConfetti) return;

      setState(() => _showConfetti = true);
      _confettiController.play();

      await Future.delayed(const Duration(seconds: 4));

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn some Words',
          style: GoogleFonts.pacifico(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HomePage()), // ⬅️ your homepage
            );
          },
        ),
        backgroundColor: const Color(0xFF4B0082),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2A004F),
                  Color(0xFF4B0082),
                  Color(0xFF8A2BE2),
                ],
              ),
            ),
            child: _wordsWithData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    itemCount: _wordsWithData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _wordsWithData.length) {
                        _triggerConfettiAndRedirect();
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Done for the Day!',
                                style: GoogleFonts.pacifico(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ],
                          ),
                        );
                      }

                      final wordData = _wordsWithData[index];
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_controller.position.haveDimensions) {
                            value = _controller.page! - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                          }
                          return Center(
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 40,
                          ),
                          child: SizedBox(
                            height: 550,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFCBA4),
                                    Color(0xFFFF5F6D),
                                    Color(0xFF9D50BB),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(4, 8),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      wordData["word"] ?? '',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pacifico(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white70,
                                      thickness: 2,
                                    ),
                                    const SizedBox(height: 20),
                                    Flexible(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          '- ${wordData["meaning"] ?? ''}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.pacifico(
                                            fontSize: 20,
                                            color: Colors.white.withOpacity(
                                              0.95,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Divider(
                                      color: Colors.white70,
                                      thickness: 2,
                                    ),
                                    const SizedBox(height: 20),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.volume_up,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          _playAudio(wordData['audio'] ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_showConfetti)
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true, // 🔥 Add this line
                colors: const [
                  Colors.deepPurple,
                  Colors.pinkAccent,
                  Colors.orange,
                  Colors.teal,
                  Colors.amber,
                ],
              ),
            ),
        ],
      ),
    );
  }
}
