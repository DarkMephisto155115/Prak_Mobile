import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
    _initAudioPlayer();
    requestMicrophonePermission();
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

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // Permission denied. Show a dialog or redirect user to settings.
      print("Microphone permission is required for recording.");
    } else {
      print("Microphone permission granted.");
    }
  }

  Future<void> _pickMedia(String type, ImageSource source) async {
    XFile? file;

    if (type == 'image') {
      file = await _picker.pickImage(source: source);
      if (file != null) {
        setState(() {
          _selectedImage = File(file!.path);
          _selectedVideo = null;
          _videoPlayerController?.dispose();
        });
      }
    } else if (type == 'video') {
      file = await _picker.pickVideo(source: source);
      if (file != null) {
        setState(() {
          _selectedVideo = File(file!.path);
          _selectedImage = null;
          _videoPlayerController = VideoPlayerController.file(_selectedVideo!)
            ..addListener(() {
              if (_videoPlayerController!.value.position ==
                  _videoPlayerController!.value.duration) {
                setState(() {
                  _videoPlayerController!.pause();
                });
              }
            })
            ..initialize().then((_) {
              setState(() {});
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

  void _initAudioPlayer() {
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isAudioPlaying = false; // Reset ke state awal setelah selesai
      });
    });
  }

  Future<void> _toggleAudioPlayback() async {
    if (_isAudioPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_recordedAudio != null) {
        await _audioPlayer.play(DeviceFileSource(_recordedAudio!.path));
      }
    }
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
    });
  }

  Widget _imageVideoPreview() {
    if (_selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 30),
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
              },
            ),
          ),
        ],
      );
    } else if (_selectedVideo != null &&
        _videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      return Stack(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: VideoPlayer(_videoPlayerController!),
            ),
          ),
          Center(
            child: IconButton(
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
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 30),
              onPressed: () {
                setState(() {
                  _selectedVideo = null;
                  _videoPlayerController?.dispose();
                  _videoPlayerController = null;
                });
              },
            ),
          ),
        ],
      );
    }
    return const Text(
      'Tap to add an image or video',
      style: TextStyle(color: Colors.grey, fontSize: 16),
    );
  }

  Widget _audioPreview() {
    if (_recordedAudio != null) {
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                const Icon(Icons.audiotrack, color: Colors.orange, size: 30),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Audio Recorded',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isAudioPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: _toggleAudioPlayback,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                  onPressed: () {
                    setState(() {
                      _recordedAudio = null;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: _recordedAudio == null ? _recordAudio : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // decoration: BoxDecoration(
        //   color: Colors.grey[900],
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: Row(
          children: [
            // Icon(Icons.mic, color: Colors.orange, size: 30),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Tap to record audio',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            // GestureDetector(
            // onTap: _recordAudio, // Start or stop recording
            // child:
            Icon(
              _isRecording ? Icons.stop : Icons.mic,
              color: _isRecording ? Colors.red : Colors.orange,
              size: 30,
            ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Write Your Story',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt,
                              color: Colors.deepPurple),
                          title: const Text('Capture Image'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('image', ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.image, color: Colors.deepPurple),
                          title: const Text('Select Image from Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('image', ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.videocam,
                              color: Colors.deepPurple),
                          title: const Text('Capture Video'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickMedia('video', ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.video_library,
                              color: Colors.deepPurple),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.deepPurpleAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(child: _imageVideoPreview()),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurpleAccent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: _audioPreview(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Title your Story Part',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _storyController,
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write your story...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Go Back',
              child: Icon(Icons.arrow_back),
            ),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Add Text',
              child: Icon(Icons.format_align_left),
            ),
            label: 'Text',
          ),
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Add Media',
              child: Icon(Icons.image),
            ),
            label: 'Media',
          ),
        ],
      ),
    );
  }
}
