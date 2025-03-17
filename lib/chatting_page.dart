import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';
import 'openai_service.dart'; 

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  final ChatGPTService chatGPTService = ChatGPTService();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  String lastWords = '';
  List<Map<String, String>> messages = [];
  final TextEditingController _textController = TextEditingController();
  Color appBarColor = Colors.transparent;
  bool isTTSEnabled = false; // TTS toggle state
  bool isCurrentlySpeaking = false;
  bool isWaitingForResponse = false; // Block sending while waiting for response
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    _scrollController.addListener(_onScroll);

    flutterTts.setStartHandler(() {
      setState(() {
        isCurrentlySpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isCurrentlySpeaking = false;
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        isCurrentlySpeaking = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.offset > 10) {
      setState(() {
        appBarColor = const Color(0xFFEBDEBE).withOpacity(0.9);
      });
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    speechToText.stop();
    flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
  }

  Future<void> startListening() async {
    if (!await speechToText.hasPermission) {
      await speechToText.initialize();
    }
    if (speechToText.isAvailable) {
      setState(() {
        isListening = true;
      });
      await speechToText.listen(onResult: onSpeechResult);
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      _textController.text = lastWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    if (isCurrentlySpeaking) {
      await flutterTts.stop(); // Stop if already speaking
    }
    await flutterTts.speak(content);
  }

  Future<void> sendMessage() async {
    if (_textController.text.trim().isEmpty || isWaitingForResponse) return;

    final message = _textController.text.trim();
    setState(() {
      messages.add({'role': 'user', 'content': message});
      lastWords = '';
      _textController.clear(); // Clear the text field
      isWaitingForResponse = true; // Block further sending
    });

    try {
      final response = await chatGPTService.chatGPTAPI(
        message,
        webAccess: false,
      );

      setState(() {
        messages.add({'role': 'assistant', 'content': response});
        lastWords = '';
      });

      if (isTTSEnabled) {
        await systemSpeak(response); // Speak only if TTS is enabled
      }
    } finally {
      setState(() {
        isWaitingForResponse = false; // Allow sending again
      });
    }
  }

  Future<void> uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      final imageBytes = await image.readAsBytes();
      final imageUrl = await chatGPTService.uploadImage(imageBytes);
      setState(() {
        messages.add({'role': 'user', 'content': 'Image uploaded: $imageUrl'});
      });
    } catch (e) {
      setState(() {
        messages.add({
          'role': 'system',
          'content': 'Failed to upload image: $e',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/main_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'Discover Palestine',
              style: TextStyle(
                color: Color(0xFF74383F),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: appBarColor,
            centerTitle: true,
            elevation: 0,
          ),
          // Welcome Message Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFEBDEBE).withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              'Welcome! 🍉\nI\'m your guide to the heart of Palestinian heritage. '
              'Let\'s uncover the stories, traditions, and beauty of our culture.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFFB89181),
              ),
            ),
          ),
          // Chat Messages Section
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(
                  text: message['content']!,
                  isUser: message['role'] == 'user',
                );
              },
            ),
          ),
          // Input Section
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 70.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Color(0xFFB89181)),
                  onPressed: uploadImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    enabled: !isWaitingForResponse,
                    onChanged: (value) {
                      lastWords = value;
                    },
                    decoration: InputDecoration(
                      hintText:
                          isWaitingForResponse
                              ? 'Waiting for response...'
                              : 'Type a message...',

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFFB89181),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFFB89181),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isWaitingForResponse ? null : sendMessage,
                  color: const Color(0xFFB89181),
                ),
                IconButton(
                  icon: Icon(
                    isTTSEnabled ? Icons.volume_up : Icons.volume_off,
                    color: const Color(0xFFB89181),
                  ),
                  onPressed: () async {
                    setState(() {
                      isTTSEnabled = !isTTSEnabled;
                    });

                    if (isTTSEnabled) {
                      if (isCurrentlySpeaking) {
                        await flutterTts.stop();
                        setState(() {
                          isCurrentlySpeaking = false;
                        });
                      } else if (messages.isNotEmpty) {
                        final lastMessage = messages.last['content'] ?? '';
                        await systemSpeak(lastMessage);
                      }
                    } else {
                      await flutterTts.stop();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    isListening ? Icons.stop : Icons.mic,
                    color: const Color(0xFFB89181),
                  ),
                  onPressed: () async {
                    if (isListening) {
                      await stopListening();
                      await sendMessage();
                    } else {
                      await startListening();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser)
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/assistant.jpg'),
                radius: 20,
              ),
            if (!isUser) const SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFFB3B3B3) : const Color(0xFFF5F0E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 12 : 0),
                  topRight: Radius.circular(isUser ? 0 : 12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            if (isUser) const SizedBox(width: 8),
            if (isUser)
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.jpg'),
                radius: 20,
              ),
          ],
        ),
      ),
    );
  }
}
