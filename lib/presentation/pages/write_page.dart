import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class WriteStoryPage extends StatefulWidget {
  const WriteStoryPage({Key? key}) : super(key: key);

  @override
  _WriteStoryPageState createState() => _WriteStoryPageState();
}

class _WriteStoryPageState extends State<WriteStoryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  File? _selectedImage;
  File? _selectedVideo;
  File? _recordedAudio;
  VideoPlayerController? _videoPlayerController;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    _videoPlayerController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    await _audioRecorder.openRecorder();
  }

  Future<void> _pickMedia(String type, ImageSource source) async {
    XFile? file;

    if (type == 'image') {
      file = await _picker.pickImage(source: source);
      if (file != null) {
        setState(() {
          _selectedImage = File(file!.path);
          _selectedVideo = null; // Reset video when a new image is picked
          _videoPlayerController?.dispose();
        });
      }
    } else if (type == 'video') {
      file = await _picker.pickVideo(source: source);
      if (file != null) {
        setState(() {
          _selectedVideo = File(file!.path);
          _selectedImage = null; // Reset image when a new video is picked
          _videoPlayerController = VideoPlayerController.file(_selectedVideo!)
            ..initialize().then((_) {
              setState(() {});  // Refresh UI once the video is initialized
            }).catchError((e) {
              print("Error initializing video player: $e");
            });
        });
      }
    }
  }

  Future<void> _recordAudio() async {
    if (!_isRecording) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/audio_record.aac';

      await _audioRecorder.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
      });
    } else {
      String? filePath = await _audioRecorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _recordedAudio = filePath != null ? File(filePath) : null;
      });
    }
  }

  Future<void> _toggleAudioPlayback() async {
    if (_isAudioPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_recordedAudio != null) {
        // Use FileSource for local audio files
        await _audioPlayer.play(DeviceFileSource(_recordedAudio!.path));
      }
    }
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
    });
  }

  Widget _mediaPreview() {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover, height: 200);
    } else if (_selectedVideo != null && _videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      return SizedBox(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoPlayerController!),
            IconButton(
              icon: Icon(
                _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                setState(() {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                  }
                });
              },
            ),
          ],
        ),
      );
    } else if (_recordedAudio != null) {
      return Row(
        children: [
          Icon(Icons.audiotrack, color: Colors.orange),
          const SizedBox(width: 10),
          Text('Audio Recorded'),
          IconButton(
            icon: Icon(
              _isAudioPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.orange,
            ),
            onPressed: _toggleAudioPlayback,
          ),
        ],
      );
    }
    return const Text(
      'Tap to add media',
      style: TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('write test',
            style: TextStyle(color: Colors.white)),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     // Handle Publish
          //   },
          //   child: const Text(
          //     'PUBLISH',
          //     style: TextStyle(color: Colors.grey),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Open media selection options
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Capture Image'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('image', ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Select Image from Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('image', ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.videocam),
                          title: const Text('Capture Video'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('video', ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.video_library),
                          title: const Text('Select Video from Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('video', ImageSource.gallery);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: _mediaPreview()),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Title your Story Part',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _storyController,
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Write your story...',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_left),
            label: 'Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: _recordAudio,
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
            ),
            label: _isRecording ? 'Stop' : 'Record',
          ),
        ],
      ),
    );
  }
}
