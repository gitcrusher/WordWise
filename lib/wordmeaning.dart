import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/secret.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/secret.dart';

class WordMeaningPage extends StatefulWidget {
  final String word;
  const WordMeaningPage({super.key, required this.word});

  @override
  State<WordMeaningPage> createState() => _WordMeaningPageState();
}

class _WordMeaningPageState extends State<WordMeaningPage> {
  String? meaning;
  String? audioUrl;
  String? error;
  bool isLoading = true;
  String? videoId;
  YoutubePlayerController? _youtubeController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final String youTubeApiKey = Secrets.youtubeApiKey;
  final String merriamApiKey = Secrets.merriamApiKey;
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
          flags: const YoutubePlayerFlags(autoPlay: false),
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
      if (data is List && data.isNotEmpty && data[0] is Map) {
        final entry = data[0];
        if (entry['shortdef'] != null && entry['shortdef'].isNotEmpty) {
          meaning = entry['shortdef'][0];
        }
        // Extract audio if available
        final soundData = entry['hwi']?['prs']?[0]?['sound']?['audio'];
        if (soundData != null) {
          final subDir = _getSubdirectory(soundData);
          audioUrl =
              'https://media.merriam-webster.com/audio/prons/en/us/mp3/$subDir/$soundData.mp3';
        }
      } else {
        throw Exception('Unexpected response format.');
      }
    } else {
      throw Exception('Merriam-Webster API error: ${response.statusCode}');
    }
  }

  String _getSubdirectory(String audio) {
    if (audio.startsWith('bix')) return 'bix';
    if (audio.startsWith('gg')) return 'gg';
    final first = audio[0];
    if (RegExp(r'[0-9]').hasMatch(first)) return 'number';
    return first;
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
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCBA4), Color(0xFFFF5F6D), Color(0xFF9D50BB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
            : Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
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
                        '- ${meaning ?? ''}',
                        style: GoogleFonts.pacifico(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 60),
                      if (audioUrl != null)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            await _audioPlayer.play(UrlSource(audioUrl!));
                          },
                          icon: const Icon(Icons.volume_up),
                          label: Text(
                            'Hear Pronunciation',
                            style: GoogleFonts.pacifico(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      Divider(color: Colors.white70, thickness: 2),
                      const SizedBox(height: 30),
                      Text(
                        'Learn with a Video:',
                        style: GoogleFonts.pacifico(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      videoId != null && _youtubeController != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: YoutubePlayer(
                                controller: _youtubeController!,
                                showVideoProgressIndicator: true,
                                progressColors: const ProgressBarColors(
                                  playedColor: Colors.deepPurple,
                                  handleColor: Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              "No video found",
                              style: GoogleFonts.pacifico(color: Colors.white),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                    offset: const Offset(2, 2),
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
