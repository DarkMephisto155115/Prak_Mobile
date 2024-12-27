import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/presentation/pages/components/recomended_stories.dart';
import 'package:terra_brain/presentation/pages/components/story_carousel.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../routes/app_pages.dart';
import 'favorite_page.dart';
import 'package:terra_brain/presentation/controllers/home_controller.dart';
import 'package:terra_brain/presentation/controllers/favorites_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.put(FavoritesController());
    Get.put(HomeController());

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
                backgroundColor: Colors.deepPurple.shade900,
                flexibleSpace: FlexibleSpaceBar(
                    title:
                        const Text('Novelku', style: TextStyle(color: Colors.white)),
                    background: Image.asset(
                      'assets/images/book.jpg',
                      fit: BoxFit.cover,
                    )
                    // Image.network(
                    //   'https://picsum.photos/800/400',
                    //   fit: BoxFit.cover,
                    // ),
                    ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
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
                        CategoryList(
                          onCategoryTap: (String category) {},
                        ),
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
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: const TextStyle(
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
        ),
        color: Color.fromARGB(248, 10, 98, 170),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(255, 190, 29, 253), spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
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
                backgroundColor: Colors.deepPurple),
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
                Get.to(() => const FavoritesPage());
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

class CategoryList extends StatelessWidget {
  CategoryList({super.key, required this.onCategoryTap});

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
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(
                categories[index],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}