import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autocomplete Search')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type to search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _suggestions.isEmpty
                        ? const Center(child: Text('No suggestions'))
                        : ListView.builder(
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_suggestions[index]),
                                onTap: () =>
                                    _selectSuggestion(_suggestions[index]),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
