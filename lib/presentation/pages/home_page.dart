import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import '../routes/app_pages.dart';
import 'favorite_page.dart';
import 'webview_page.dart';
import 'package:terra_brain/presentation/controllers/home_controller.dart';

// Dummy data for books
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
        title: Text(
            category != null && category!.isNotEmpty ? 'Books in $category' : 'All Books'),
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
                    'assets/50.png',
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


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openGoogleMaps() async {
    try {
      // Cek izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      // Pastikan lokasi aktif
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak secara permanen.';
      }

      // Dapatkan lokasi pengguna
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Format URL untuk Google Maps
      final Uri googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}');

      print('Generated URL: $googleMapsUrl');

      // Luncurkan URL di aplikasi eksternal atau fallback ke browser
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Cannot open Google Maps, fallback to browser');
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.inAppWebView,
        );
      }
    } catch (e) {
      // Tampilkan pesan kesalahan
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConnectivityController connectivityController = Get.put(ConnectivityController());
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Stories',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowAllBooksPage()),
                        );
                      },
                      child: const Text(
                        'Show All',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
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
              CategoryList(onCategoryTap: (category) {
                // Navigasi ke halaman ShowAllBooksPage dengan filter kategori
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAllBooksPage(category: category),
                  ),
                );
                print('Category Tapped: $category');
              }),
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
              Get.toNamed(Routes.API);
            } else if (index == 2) {
              Get.toNamed('/write');
            } else if (index == 3) {
              Get.to(() => FavoritesPage());
            } else if (index == 4) {
              Get.toNamed(Routes.PROFILE);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openGoogleMaps,
          backgroundColor: Colors.orange,
          child: const Icon(Icons.map),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                          : Image.asset('assets/150.png', fit: BoxFit.cover),
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
  CategoryList({super.key, required this.onCategoryTap});

  final void Function(String category) onCategoryTap;
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
              child: InkWell(
                onTap: () => onCategoryTap(categories[index]),
                child: Chip(
                  label: Text(categories[index], style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.grey[700],
                ),
              )
          );
        },
      ),
    );
  }
}

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Connection'),
      ),
      body: Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
    );
  }
}

class RecommendedStories extends StatefulWidget {
  RecommendedStories({super.key});

  @override
  _RecommendedStoriesState createState() => _RecommendedStoriesState();
}

class _RecommendedStoriesState extends State<RecommendedStories> {
  late List<Map<String, String>> _recommended;
  List<Map<String, String>> initialRecommended = [
    {'title': 'Stuck With Mr. Billionaire', 'author': 'Author A', 'category': 'Romance','url': 'https://www.wattpad.com/story/243832194-stuck-with-mr-billionaire'},
    {'title': 'Hell University', 'author': 'Author B', 'category': 'Thriller','url':'https://www.wattpad.com/story/157780928-hell-university'},
    {'title': 'A Brilliant Plan', 'author': 'Author C', 'category': 'Mystery','url':'https://www.wattpad.com/story/65808245-a-brilliant-plan'},
  ];

  @override
  void initState() {
    super.initState();
    _recommended = initialRecommended;
  }

  void _updateRecommended(String category) {
    setState(() {
      List<Map<String, String>> filteredBooks = BookData.getBooksByCategory(category);
      _recommended = filteredBooks.isNotEmpty ? filteredBooks : initialRecommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ConnectivityController connectivityController = Get.put(ConnectivityController());
    return Column(
      children: _recommended.map((book) {
        return ListTile(
          leading: Image.asset('assets/50.png', fit: BoxFit.cover),
          title: Text(book['title']!, style: TextStyle(color: Colors.white)),
          subtitle: Text(book['author']!, style: TextStyle(color: Colors.grey)),
          onTap: () {
            if (connectivityController.isConnected.value) {
              _updateRecommended(book['category']!);
            } else {
              connectivityController.setTargetUrl(book['url']!);
              Get.to(NoConnectionPage());
            }
          },
        );
      }).toList(),
    );
  }
}