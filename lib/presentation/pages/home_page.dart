import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../routes/app_pages.dart';
import 'webview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[850],
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wattpad'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Popular Stories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const StoryCarousel(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              CategoryList(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Recommended for You',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              RecommendedStories(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Write',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              // Define your route for Library
              Get.toNamed(Routes.API);
            } else if (index == 2) {
              // Define your route for Write
              Get.toNamed('/write');
            } else if (index == 3) {
              Get.to(() => FavoritesPage());
            } else if (index == 4) {
              // Define your route for Profile
              Get.toNamed(Routes.PROFILE);
            }
          },
        ),
      ),
    );
  }
}

class StoryCarousel extends StatefulWidget {
  const StoryCarousel({super.key});

  @override
  _StoryCarouselState createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  final List<String> stories = ['Story 1', 'Story 2', 'Story 3', 'Story 4'];
  List<File?> _selectedImages = [null, null, null, null];

  Future<void> _pickImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImages[index] = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[800],
            child: Container(
              width: 150,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _pickImage(index);
                      },
                      child: _selectedImages[index] != null
                          ? Image.file(
                        _selectedImages[index]!,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      stories[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(index),
                    child: Text("Pick Image"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final List<String> categories = [
    'Romance',
    'Fantasy',
    'Thriller',
    'Science Fiction',
    'Mystery',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text(categories[index], style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey[700],
            ),
          );
        },
      ),
    );
  }
}

class RecommendedStories extends StatelessWidget {
  RecommendedStories({super.key});

  final List<String> recommended = [
    'Stuck With Mr. Billionaire',
    'Hell University',
    'A Brilliant Plan',
  ];

  final List<String> urls = [
    'https://www.wattpad.com/story/243832194-stuck-with-mr-billionaire',
    'https://www.wattpad.com/story/157780928-hell-university',
    'https://www.wattpad.com/story/65808245-a-brilliant-plan',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recommended.map((story) {
        int index = recommended.indexOf(story);
        return ListTile(
          leading: Image.network(
            'https://via.placeholder.com/50',
            fit: BoxFit.cover,
          ),
          title: Text(story, style: TextStyle(color: Colors.white)),
          subtitle: Text('Author Name', style: TextStyle(color: Colors.grey)),
          onTap: () {
            Get.to(WebViewScreen(url: urls[index]));
          },
        );
      }).toList(),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final CollectionReference favorites =
  FirebaseFirestore.instance.collection('favorites');

  Future<void> addFavorite(String storyTitle) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').add({'title': storyTitle});
      Get.snackbar("Sukses", "Data berhasil disimpan ke Firestore");
    } catch (e) {
      Get.snackbar("Gagal", "Gagal menyimpan data ke Firestore: $e");
    }
  }

  Future<void> updateFavorite(String id, String newTitle) async {
    await favorites.doc(id).update({'title': newTitle});
  }

  Future<void> deleteFavorite(String id) async {
    await favorites.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder(
        stream: favorites.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text(item['title']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        String? newTitle = await _showEditDialog(context, item['title']);
                        if (newTitle != null && newTitle.isNotEmpty) {
                          updateFavorite(item.id, newTitle);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteFavorite(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newTitle = await _showAddDialog(context);
          if (newTitle != null && newTitle.isNotEmpty) {
            addFavorite(newTitle);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Favorite'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Story Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentTitle) async {
    TextEditingController controller = TextEditingController(text: currentTitle);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Favorite'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Story Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}


