import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../routes/app_pages.dart';
import 'favorite_page.dart';
import 'package:terra_brain/presentation/controllers/home_controller.dart';
import 'package:terra_brain/presentation/controllers/favorites_controller.dart';

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
                  "@${{ books[index]['author']! }}",
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
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.put(FavoritesController());
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade900, Colors.black],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Novelku', style: TextStyle(color: Colors.white)),
                  background: Image.network(
                    'https://picsum.photos/800/400',
                    fit: BoxFit.cover,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        _buildSectionTitle('Cerita Populer'),
                        StoryCarousel(),
                        _buildSectionTitle('Kategori'),
                        CategoryList(onCategoryTap: (String category) {  },),
                        _buildSectionTitle('Rekomendasi untuk Anda'),
                        RecommendedStories(
                            favoritesController: favoritesController),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
          // color: Colors.white,
          
        ),
        color: Color.fromARGB(248, 139, 22, 22),
        boxShadow: [
          BoxShadow(color: Colors.purple, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
                backgroundColor: Colors.deepPurple
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Perpustakaan',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: 'Tulis',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorit',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 1:
                Get.toNamed(Routes.API);
                break;
              case 2:
                Get.toNamed('/write');
                break;
              case 3:
                Get.to(() => FavoritesPage());
                break;
              case 4:
                Get.toNamed(Routes.PROFILE);
                break;
            }
          },
        ),
      ),
    );
  }
}

class StoryCarousel extends StatelessWidget {
  const StoryCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://picsum.photos/200/300?random=$index'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cerita ${index + 1}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({Key? key, required this.onCategoryTap}) : super(key: key);

  final void Function(String category) onCategoryTap;
  final List<String> categories = [
    'Romansa',
    'Fantasi',
    'Thriller',
    'Fiksi Ilmiah',
    'Misteri',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(categories[index],
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}

class RecommendedStories extends StatelessWidget {
  final FavoritesController favoritesController;
  final HomeController homeController = Get.find<HomeController>();

  RecommendedStories({required this.favoritesController, Key? key})
      : super(key: key);

  final RxList<bool> likedStatus = RxList<bool>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    syncLikedStatus();
    if (likedStatus.isEmpty) {
      likedStatus
          .addAll(List.generate(homeController.stories.length, (_) => false));
    }

    return Obx(() {
      if (homeController.stories.isEmpty) {
        return Center(
            child: CircularProgressIndicator(color: Colors.deepPurple));
      }

      return Obx(() => Column(
        children: homeController.stories.asMap().entries.map((entry) {
          int index = entry.key;
          var story = entry.value;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: story['image'] != null && story['image'].isNotEmpty
                      ? Image.network(
                          story['image'],
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/50.png', fit: BoxFit.cover),
                        )
                      : Image.asset('assets/50.png',
                          width: 60, height: 80, fit: BoxFit.cover),
                ),
                title: Text(story['title'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle:
                    Text("@${story['author']}", style: TextStyle(color: Colors.grey)),
                trailing: Obx(() {
                  return IconButton(
                    icon: Icon(
                      likedStatus[index]
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: likedStatus[index] ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      likedStatus[index] = !likedStatus[index];
                      if (likedStatus[index]) {
                        favoritesController.addFavorite(
                          story['id'],
                          story['title'],
                          story['author'],
                          story['description'],
                        );
                      } else {
                        favoritesController.removeStory(story['id']);
                      }
                    },
                  );
                }),
                onTap: () {
                  // Navigasi ke StoryPage dan mengirimkan ID
                  Get.toNamed(Routes.READ, arguments: {'id': story['id']});
                },
              ),
            ),
          );
        }).toList(),
      ));
    });
  }

  void syncLikedStatus() {
    everAll([homeController.stories, favoritesController.favoriteItems], (_) {
      likedStatus.clear();
      likedStatus.addAll(homeController.stories.map((story) {
        return favoritesController.favoriteItems.any((favorite) {
          return favorite['id'] == story['id'];
        });
      }).toList());
    });
  }
}
