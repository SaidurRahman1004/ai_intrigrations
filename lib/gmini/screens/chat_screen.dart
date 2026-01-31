import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GeminiService _geminiService;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();
  }

  // ChatUser Object for the current user and Gemini
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You');
  final ChatUser _geminiUser = ChatUser(
    id: '2',
    firstName: 'HiruAi',
    profileImage: 'https://i.postimg.cc/50Pwm3XV/logo.png',
  );

  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HiruAi'),
        centerTitle: true,
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.deepPurple,
          containerColor: Color.fromRGBO(0, 0, 0, 0.05),
          textColor: Colors.black,
        ),
        onSend: _sendMessage,
        messages: _messages,
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              onPressed: _sendMediaMessage,
              icon: const Icon(Icons.image),
              tooltip: 'Send Image',
            ),
          ],
        ),
      ),
    );
  }
  //show text Functions
  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      _messages.insert(0, chatMessage);
      _typingUsers.add(_geminiUser); // loading
    });

    try {
      final response = await _geminiService.sendMessage(chatMessage.text);

      final geminiResponse = ChatMessage(
        user: _geminiUser,
        createdAt: DateTime.now(),
        text: response,
      );

      setState(() {
        _messages.insert(0, geminiResponse);
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _typingUsers.remove(_geminiUser);
      });
    }
  }

  // pic and Text
  Future<void> _sendMediaMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await File(pickedFile.path).readAsBytes();

      final chatMessage = ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now(),
        text: 'Analyze this image',
        medias: [
          ChatMedia(
            url: pickedFile.path,
            fileName: 'image.jpg',
            type: MediaType.image,
          )
        ],
      );

      setState(() {
        _messages.insert(0, chatMessage);
        _typingUsers.add(_geminiUser);
      });

      try {
        final response = await _geminiService.analyzeImage(
            imageBytes, chatMessage.text);

        final geminiResponse = ChatMessage(
          user: _geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );

        setState(() {
          _messages.insert(0, geminiResponse);
        });
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() {
          _typingUsers.remove(_geminiUser);
        });
      }
    }
  }

  // error  SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}