import 'package:flutter/material.dart';
import 'data.dart';

class ShowAllBooksPage extends StatelessWidget {
  final String? category;
  ShowAllBooksPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> books = BookData.books;

    if (category != null && category!.isNotEmpty) {
      books = BookData.getBooksByCategory(category!);
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(category != null && category!.isNotEmpty ? 'Books in $category' : 'All Books'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurpleAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.deepPurple.shade700,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/50.png', // Ganti dengan path gambar thumbnail Anda
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                title: Text(
                  books[index]['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  books[index]['author']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                ),
                onTap: () {
                  // Aksi ketika item buku diklik
                  print('Clicked on ${books[index]['title']}');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}