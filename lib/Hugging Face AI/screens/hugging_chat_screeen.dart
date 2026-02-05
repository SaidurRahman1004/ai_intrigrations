// lib/Hugging Face AI/screens/hugging_chat_screeen.dart

import 'package:flutter/material.dart';
import '../services/huggingface_service.dart';

class HuggingFacePlaygroundScreen extends StatefulWidget {
  const HuggingFacePlaygroundScreen({super.key});

  @override
  State<HuggingFacePlaygroundScreen> createState() =>
      _HuggingFacePlaygroundScreenState();
}

class _HuggingFacePlaygroundScreenState
    extends State<HuggingFacePlaygroundScreen>
    with SingleTickerProviderStateMixin {
  late final HuggingFaceService _huggingFaceService;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _huggingFaceService = HuggingFaceService();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hugging Face Playground'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.text_fields_sharp), text: 'Generate'),
            Tab(icon: Icon(Icons.translate), text: 'Translate'),
            Tab(icon: Icon(Icons.sentiment_satisfied_alt), text: 'Emotion'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ট্যাব ১: টেক্সট জেনারেশন
          GenerateTextTab(huggingFaceService: _huggingFaceService),
          // ট্যাব ২: অনুবাদ
          TranslateTab(huggingFaceService: _huggingFaceService),
          // ট্যাব ৩: আবেগ বিশ্লেষণ
          EmotionTab(huggingFaceService: _huggingFaceService),
        ],
      ),
    );
  }
}


class GenerateTextTab extends StatefulWidget {
  final HuggingFaceService huggingFaceService;

  const GenerateTextTab({super.key, required this.huggingFaceService});

  @override
  State<GenerateTextTab> createState() => _GenerateTextTabState();
}

class _GenerateTextTabState extends State<GenerateTextTab> {
  final TextEditingController _controller = TextEditingController();
  String _generatedText = 'AI response will appear here...';
  bool _isLoading = false;

  void _generateText() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedText = 'Generating...';
    });

    try {
      final result =
      await widget.huggingFaceService.generateText(prompt: _controller.text);
      setState(() {
        _generatedText = result;
      });
    } catch (e) {
      setState(() {
        _generatedText = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter your prompt here',
              hintText: 'e.g., "Once upon a time..."',
              border: const OutlineInputBorder(),
              suffixIcon: _isLoading
                  ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
                  : IconButton(
                icon: const Icon(Icons.send),
                onPressed: _generateText,
              ),
            ),
            onSubmitted: (_) => _generateText(),
          ),
          const SizedBox(height: 24),
          Text('Generated Text:',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SelectableText( // Using SelectableText to allow copying
              _generatedText,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// অনুবাদ ট্যাবের জন্য UI
// ==========================================================
class TranslateTab extends StatefulWidget {
  final HuggingFaceService huggingFaceService;

  const TranslateTab({super.key, required this.huggingFaceService});

  @override
  State<TranslateTab> createState() => _TranslateTabState();
}

class _TranslateTabState extends State<TranslateTab> {
  final TextEditingController _controller = TextEditingController();
  String _translatedText = 'Translated text will appear here...';
  bool _isLoading = false;
  String _fromLang = 'en';
  String _toLang = 'bn';

  void _translateText() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _translatedText = 'Translating...';
    });

    try {
      final result = await widget.huggingFaceService.translateText(
        text: _controller.text,
        fromLang: _fromLang,
        toLang: _toLang,
      );
      setState(() {
        _translatedText = result;
      });
    } catch (e) {
      setState(() {
        _translatedText = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLanguageSelector('From:', _fromLang, (val) =>
                  setState(() => _fromLang = val!)),
              IconButton(
                icon: const Icon(
                    Icons.swap_horiz, size: 30, color: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    final tempLang = _fromLang;
                    _fromLang = _toLang;
                    _toLang = tempLang;
                  });
                },
              ),
              _buildLanguageSelector(
                  'To:', _toLang, (val) => setState(() => _toLang = val!)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Enter text to translate',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _translateText,
            icon: _isLoading
                ? Container()
                : const Icon(Icons.translate),
            label: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
                : const Text('Translate'),
          ),
          const SizedBox(height: 24),
          Text('Result:', style: Theme
              .of(context)
              .textTheme
              .titleLarge),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SelectableText(
              _translatedText,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(String title, String value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        DropdownButton<String>(
          value: value,
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'bn', child: Text('Bengali')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ==========================================================
// আবেগ বিশ্লেষণ ট্যাবের জন্য UI
// ==========================================================
class EmotionTab extends StatefulWidget {
  final HuggingFaceService huggingFaceService;

  const EmotionTab({super.key, required this.huggingFaceService});

  @override
  State<EmotionTab> createState() => _EmotionTabState();
}

class _EmotionTabState extends State<EmotionTab> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _analysisResult;
  bool _isLoading = false;

  void _analyzeSentiment() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      final result = await widget.huggingFaceService.analyzeSentiment(
          _controller.text);
      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Enter text for sentiment analysis',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _analyzeSentiment,
            icon: _isLoading ? Container() : const Icon(Icons.analytics),
            label: _isLoading
                ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
                : const Text('Analyze Emotion'),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_analysisResult != null)
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _analysisResult!['emoji'],
                      style: const TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Detected Emotion: ${_analysisResult!['emotion']
                          ?.toString()
                          .toUpperCase()}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${(_analysisResult!['confidence'] * 100)
                          .toStringAsFixed(1)}%',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}