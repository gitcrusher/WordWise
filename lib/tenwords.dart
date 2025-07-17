import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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

  List<Map<String, String>> _wordsWithMeanings = [];

  @override
  void initState() {
    super.initState();
    _fetchWordsFromTrie();
  }

  void _fetchWordsFromTrie() async {
    try {
      final DataSnapshot snapshot = await _dbRef.get();
      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        List<String> allWords = [];
        _traverseTrie(data, "", allWords);

        print("✅ Fetched ${allWords.length} words from trie");

        allWords.shuffle();
        List<Map<String, String>> results = [];

        int index = 0;
        while (results.length < 10 && index < allWords.length) {
          String word = allWords[index];
          String meaning = await _fetchMeaning(word);

          if (!meaning.startsWith(" ")) {
            results.add({"word": word, "meaning": meaning});
          }
          index++;
        }

        setState(() {
          _wordsWithMeanings = results;
        });
      } else {
        print(" No valid data found in trie_data");
      }
    } catch (e) {
      print("🔥 Error fetching from trie_data: $e");
    }
  }

  Future<String> _fetchMeaning(String word) async {
    final url =
        'https://www.dictionaryapi.com/api/v3/references/learners/json/$word?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty && data[0] is Map) {
          final shortdef = data[0]['shortdef'];
          if (shortdef != null && shortdef is List && shortdef.isNotEmpty) {
            return shortdef[0];
          }
        }
        return " Meaning not found";
      } else {
        return " API error";
      }
    } catch (e) {
      print("Error fetching meaning for $word: $e");
      return " Error loading meaning";
    }
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
      if (entry.key != 'isWord' && entry.key != 'end') {
        if (entry.value is Map) {
          _traverseTrie(
            entry.value as Map<dynamic, dynamic>,
            prefix + entry.key,
            words,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.85);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('10 Words a Day'),
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A004F), Color(0xFF4B0082), Color(0xFF8A2BE2)],
          ),
        ),
        child: _wordsWithMeanings.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : PageView.builder(
                controller: controller,
                scrollDirection: Axis.vertical,
                itemCount: _wordsWithMeanings.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      double value = 1.0;
                      if (controller.position.haveDimensions) {
                        value = controller.page! - index;
                        value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                      }
                      return Center(
                        child: Transform.scale(scale: value, child: child),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFCBA4), // Soft Peach
                              Color(0xFFFF5F6D), // Warm Coral
                              Color(0xFF9D50BB), // Purple
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 30,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${index + 1}. ${_wordsWithMeanings[index]["word"]}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pacifico(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                _wordsWithMeanings[index]["meaning"] ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pacifico(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
