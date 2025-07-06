import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadTriePage extends StatefulWidget {
  const UploadTriePage({Key? key}) : super(key: key);

  @override
  State<UploadTriePage> createState() => _UploadTriePageState();
}

class _UploadTriePageState extends State<UploadTriePage> {
  bool isUploading = false;
  String statusMessage = "Upload complete or idle.";

  @override
  void initState() {
    super.initState();
    uploadCSVToFirebase();
  }

  /// Step 1: Load CSV words (filtered)
  Future<List<String>> loadCSVWords() async {
    final raw = await rootBundle.loadString('assets/filtered_words.csv');
    final lines = LineSplitter().convert(raw);

    final words = lines
        .map((line) => line.split(',')[0].trim().toLowerCase())
        .where((word) => word.isNotEmpty && word.length <= 32) // ✅ only <=32
        .toSet()
        .toList();

    return words;
  }

  /// Step 2: Build Trie and upload
  Future<void> uploadCSVToFirebase() async {
    setState(() {
      isUploading = true;
      statusMessage = "Uploading full trie...";
    });

    try {
      final words = await loadCSVWords();
      print("🟡 Total Words: ${words.length}");

      final trie = Trie();
      for (final word in words) {
        trie.insert(word);
      }

      final jsonTrie = trie.toJson(trie.root);
      print("📤 Uploading full trie...");

      final dbRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://wordwiselogin-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref('trie_data');

      await dbRef.set(jsonTrie);

      setState(() => statusMessage = "✅ Full trie uploaded!");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Full trie uploaded!')));
    } catch (e) {
      print("❌ Upload error: $e");
      setState(() => statusMessage = "❌ Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Trie to Firebase")),
      body: Center(
        child: isUploading
            ? const CircularProgressIndicator()
            : Text(
                statusMessage,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

class TrieNode {
  bool isEnd = false;
  Map<String, TrieNode> children = {};
}

class Trie {
  TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode node = root;
    for (final ch in word.split('')) {
      node.children.putIfAbsent(ch, () => TrieNode());
      node = node.children[ch]!;
    }
    node.isEnd = true;
  }

  Map<String, dynamic> toJson(TrieNode node) {
    final map = <String, dynamic>{'end': node.isEnd};
    node.children.forEach((ch, child) {
      map[ch] = toJson(child);
    });
    return map;
  }
}
