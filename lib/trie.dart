// trie.dart

class TrieNode {
  bool isEndOfWord = false;
  Map<String, TrieNode> children = {};

  TrieNode();

  TrieNode.fromJson(Map<String, dynamic> json) {
    isEndOfWord = json['isEndOfWord'] ?? false;
    if (json['children'] != null) {
      json['children'].forEach((key, value) {
        children[key] = TrieNode.fromJson(Map<String, dynamic>.from(value));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'isEndOfWord': isEndOfWord};
    json['children'] = children.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    return json;
  }
}

class Trie {
  TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode node = root;
    for (var char in word.split('')) {
      node.children.putIfAbsent(char, () => TrieNode());
      node = node.children[char]!;
    }
    node.isEndOfWord = true;
  }

  List<String> autocomplete(String prefix) {
    TrieNode node = root;
    for (var char in prefix.split('')) {
      if (!node.children.containsKey(char)) return [];
      node = node.children[char]!;
    }

    List<String> results = [];

    void dfs(TrieNode current, String path) {
      if (current.isEndOfWord) results.add(path);
      for (var entry in current.children.entries) {
        dfs(entry.value, path + entry.key);
      }
    }

    dfs(node, prefix);
    return results;
  }

  void buildFromJson(Map<String, dynamic> json) {
    root = TrieNode.fromJson(json);
  }
}
