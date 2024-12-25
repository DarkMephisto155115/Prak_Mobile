// data.dart
class BookData {
  static final List<Map<String, String>> books = [
    {'title': 'Stuck With Mr. Billionaire', 'author': 'Author A', 'category': 'Romance'},
    {'title': 'Hell University', 'author': 'Author B', 'category': 'Thriller'},
    {'title': 'A Brilliant Plan', 'author': 'Author C', 'category': 'Mystery'},
    {'title': 'The Silent Witness', 'author': 'Author D', 'category': 'Mystery'},
    {'title': 'Enchanted Realms', 'author': 'Author E', 'category': 'Fantasy'},
    {'title': 'Mystery in the Shadows', 'author': 'Author F', 'category': 'Mystery'},
    {'title': 'Beyond the Horizon', 'author': 'Author G', 'category': 'Science Fiction'},
  ];

  static List<Map<String, String>> getBooksByCategory(String category) {
    return books.where((book) => book['category'] == category).toList();
  }
}