import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/wordmeaning.dart';
import 'package:music_player/models/trie.dart';

class AutocompleteSearchPage extends StatefulWidget {
  final Trie trie; // ✅ Receive Trie from outside
  const AutocompleteSearchPage({Key? key, required this.trie})
    : super(key: key);

  @override
  State<AutocompleteSearchPage> createState() => _AutocompleteSearchPageState();
}

class _AutocompleteSearchPageState extends State<AutocompleteSearchPage> {
  late Trie _trie;
  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _trie = widget.trie;
    _controller.addListener(() {
      _updateSuggestions(_controller.text);
    });
  }

  void _updateSuggestions(String input) {
    final result = widget.trie.startsWith(input.toLowerCase());
    setState(() => _suggestions = result);
  }

  void _selectSuggestion(String word) {
    _controller.text = word;
    setState(() => _suggestions = []);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordMeaningPage(word: word)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
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
                offset: Offset(0, 6),
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
              'Are you curious?',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCBA4), Color(0xFFFF5F6D), Color(0xFF9D50BB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type to search...',
                    hintStyle: GoogleFonts.pacifico(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _suggestions.isEmpty
                    ? Center(
                        child: Text(
                          'No suggestions',
                          style: GoogleFonts.pacifico(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white.withAlpha(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ListTile(
                              title: Center(
                                child: Text(
                                  _suggestions[index],
                                  style: GoogleFonts.pacifico(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              onTap: () =>
                                  _selectSuggestion(_suggestions[index]),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
