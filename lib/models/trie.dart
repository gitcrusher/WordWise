// lib/models/trie.dart
class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class Trie {
  TrieNode root = TrieNode();

  void insertFromFirebase(Map data, TrieNode node) {
    data.forEach((key, value) {
      if (key == "end") {
        node.isEndOfWord = value;
      } else if (value is Map) {
        TrieNode child = TrieNode();
        node.children[key] = child;
        insertFromFirebase(value, child);
      }
    });
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
}
