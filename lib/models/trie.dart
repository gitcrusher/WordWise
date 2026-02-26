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
    // yahan pr hum character ke liye list bhejenege
    TrieNode? node = root;
    for (var ch in prefix.split('')) {
      if (!node!.children.containsKey(ch))
        return []; // check karo ki char exist krta hai kya
      node = node.children[ch]; // usi child pr move karo
    }

    List<String> results = []; // store all matching word

    void dfs(TrieNode node, String current) {
      if (node.isEndOfWord) results.add(current); // agar end mil gaya  add it.
      node.children.forEach((char, child) {
        // loop to go deeper into every child
        dfs(child, current + char); // keep building the word.
      });
    }

    dfs(node!, prefix); //  ye krne se dfs search for prefix + anything
    return results;
  }
}
