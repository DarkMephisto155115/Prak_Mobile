// favorites_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  final FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white)), // Title color set to white

        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.black, // Dark background color
      body: StreamBuilder(
        stream: controller.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                color: Colors.grey[850], // Darker card color
                child: ListTile(
                  title: Text(item['title'], style: const TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Author: ${item['author']}", style: const TextStyle(color: Colors.grey)),
                      Text(item['description'], style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          final updatedData = await _showEditDialog(context, item);
                          if (updatedData != null) {
                            controller.updateFavorite(
                              item.id,
                              updatedData['title']!,
                              updatedData['author']!,
                              updatedData['description']!,
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => controller.deleteFavorite(item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newFavorite = await _showAddDialog(context);
          if (newFavorite != null) {
            controller.addFavorite(
              newFavorite['title']!,
              newFavorite['author']!,
              newFavorite['description']!,
            );
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<Map<String, String>?> _showAddDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final descriptionController = TextEditingController();
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Add Favorite', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Story Title',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: authorController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Author Name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop({
              'title': titleController.text,
              'author': authorController.text,
              'description': descriptionController.text,
            }),
            child: const Text('Add', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>?> _showEditDialog(BuildContext context, QueryDocumentSnapshot item) async {
    final titleController = TextEditingController(text: item['title']);
    final authorController = TextEditingController(text: item['author']);
    final descriptionController = TextEditingController(text: item['description']);
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Edit Favorite', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Story Title',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: authorController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Author Name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop({
              'title': titleController.text,
              'author': authorController.text,
              'description': descriptionController.text,
            }),
            child: const Text('Update', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
