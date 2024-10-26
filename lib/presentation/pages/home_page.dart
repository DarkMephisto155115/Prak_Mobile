import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../routes/app_pages.dart';
import 'Webview_page.dart';

class HomePage extends GetView {
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
              label: 'Library / Write',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Write',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              Get.toNamed(Routes.API);
            } else if (index == 2) {
              // Get.toNamed(Routes.WRITE);
            }else if (index == 3) {
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

class RecommendedStories extends GetView {
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
