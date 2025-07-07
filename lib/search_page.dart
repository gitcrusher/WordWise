import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/wordmeaning.dart';

class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class Trie {
  TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode node = root;
    for (var ch in word.split('')) {
      node = node.children.putIfAbsent(ch, () => TrieNode());
    }
    node.isEndOfWord = true;
  }

  List<String> startsWith(String prefix) {
    TrieNode? node = root;
    for (var ch in prefix.split('')) {
      if (!node!.children.containsKey(ch)) return [];
      node = node.children[ch];
    }

    List<String> results = [];

    void dfs(TrieNode node, String current) {
      if (node.isEndOfWord) results.add(current);
      node.children.forEach((char, child) {
        dfs(child, current + char);
      });
    }

    dfs(node!, prefix);
    return results;
  }

  void insertFromFirebase(Map data, TrieNode node) {
    data.forEach((key, value) {
      print("Inserting key: $key");
      if (key == "end") {
        node.isEndOfWord = value;
      } else if (value is Map) {
        TrieNode child = TrieNode();
        node.children[key] = child;
        insertFromFirebase(value, child);
      } else {
        print("Invalid child for key $key: $value");
      }
    });
  }
}

class AutocompleteSearchPage extends StatefulWidget {
  const AutocompleteSearchPage({Key? key}) : super(key: key);

  @override
  State<AutocompleteSearchPage> createState() => _AutocompleteSearchPageState();
}

class _AutocompleteSearchPageState extends State<AutocompleteSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final Trie _trie = Trie();
  List<String> _suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrieFromFirebase().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    _controller.addListener(() {
      _updateSuggestions(_controller.text);
    });
  }

  Future<void> _loadTrieFromFirebase() async {
    print("Starting Firebase data load...");
    final ref = FirebaseDatabase.instance.ref("trie_data");
    final snapshot = await ref.get();
    print("Firebase snapshot fetched"); // Added to confirm fetch completion

    print("Firebase snapshot.exists: ${snapshot.exists}");

    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      print("Firebase data loaded: $data");
      _trie.insertFromFirebase(data, _trie.root);
      print("Trie data inserted");
    } else {
      print("No data found in Firebase!");
    }
  }

  void _updateSuggestions(String input) {
    final result = _trie.startsWith(input.toLowerCase());
    print("Suggestions for '$input': $result");
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
                color: Colors.black.withOpacity(0.4), // deep shadow
                offset: Offset(0, 6), // down shadow
                blurRadius: 12, // soft edges
                spreadRadius: 1, // size of the shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // remove default shadow
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

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFCBA4), // Soft Peach
                    Color(0xFFFF5F6D), // Warm Coral
                    Color(0xFF9D50BB),
                  ],
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
