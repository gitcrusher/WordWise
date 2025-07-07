import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // For ImageFilter.blur
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WordMeaningPage extends StatefulWidget {
  final String word;
  const WordMeaningPage({super.key, required this.word});

  @override
  State<WordMeaningPage> createState() => _WordMeaningPageState();
}

class _WordMeaningPageState extends State<WordMeaningPage> {
  String? meaning;
  String? error;
  bool isLoading = true;
  String? videoId;
  YoutubePlayerController? _youtubeController;

  final String youTubeApiKey = 'AIzaSyAHm2QvAm8ZDNu0Y-HVylpE8Q202V8Z0JA';
  final String merriamApiKey = 'd237d493-2e02-4e54-af72-596e4d614d42';

  @override
  void initState() {
    super.initState();
    fetchData(widget.word);
  }

  Future<void> fetchData(String word) async {
    try {
      await Future.wait([
        fetchMerriamWebsterMeaning(word),
        fetchYouTubeVideo(word),
      ]);

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        error = 'Something went wrong: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchMerriamWebsterMeaning(String word) async {
    final url = Uri.parse(
      'https://www.dictionaryapi.com/api/v3/references/learners/json/$word?key=$merriamApiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List &&
          data.isNotEmpty &&
          data[0] is Map &&
          data[0]['shortdef'] != null) {
        final defs = data[0]['shortdef'];
        if (defs.isNotEmpty) {
          meaning = defs[0]; // First definition
        } else {
          throw Exception('No definitions found.');
        }
      } else {
        throw Exception('Unexpected response format.');
      }
    } else {
      throw Exception('Merriam-Webster API error: ${response.statusCode}');
    }
  }

  Future<void> fetchYouTubeVideo(String word) async {
    final query = Uri.encodeComponent('$word meaning');
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=1&q=$query&key=$youTubeApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        videoId = data['items'][0]['id']['videoId'];
      }
    } else {
      throw Exception('YouTube API error: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5F6D), Color(0xFF9D50BB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4), // Deep shadow
                  offset: Offset(0, 6), // Downward shadow
                  blurRadius: 12, // Soft edges
                  spreadRadius: 1, // Shadow size
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0, // Remove default AppBar shadow
              centerTitle: true,
              title: Text(
                widget.word.toUpperCase() + ' !!',
                style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCBA4), Color(0xFFFF5F6D), Color(0xFF9D50BB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : error != null
                ? Center(
                    child: Text(
                      error!,
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meaning:',
                          style: GoogleFonts.pacifico(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          meaning ?? '',
                          style: GoogleFonts.pacifico(
                            fontSize: 22,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ✅ HR Line
                        Divider(
                          color: Colors.white70,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Learn with a Video:',
                          style: GoogleFonts.pacifico(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        videoId != null && _youtubeController != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: YoutubePlayer(
                                    controller: _youtubeController!,
                                    showVideoProgressIndicator: true,
                                    progressColors: const ProgressBarColors(
                                      playedColor: Colors.deepPurple,
                                      handleColor: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                "No video found",
                                style: GoogleFonts.pacifico(
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
