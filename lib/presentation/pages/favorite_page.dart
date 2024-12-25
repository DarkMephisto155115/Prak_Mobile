import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesController controller = Get.put(FavoritesController());
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening(TextEditingController targetController) async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
          targetController.text = _spokenText; // Update text controller
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition is not available')),
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          'Please log in to view your favorites.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: controller.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                color: Colors.grey[850],
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
            _buildTextFieldWithVoiceInput(
              context: context,
              controller: titleController,
              hint: "Story Title",
            ),
            _buildTextFieldWithVoiceInput(
              context: context,
              controller: authorController,
              hint: "Author Name",
            ),
            _buildTextFieldWithVoiceInput(
              context: context,
              controller: descriptionController,
              hint: "Description",
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

  Widget _buildTextFieldWithVoiceInput({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: Colors.orange,
          ),
          onPressed: () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening(controller);
            }
          },
        ),
      ],
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
            _buildTextFieldWithVoiceInput(
              context: context,
              controller: titleController,
              hint: "Story Title",
            ),
            _buildTextFieldWithVoiceInput(
              context: context,
              controller: authorController,
              hint: "Author Name",
            ),
            _buildTextFieldWithVoiceInput(
              context: context,
              controller: descriptionController,
              hint: "Description",
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