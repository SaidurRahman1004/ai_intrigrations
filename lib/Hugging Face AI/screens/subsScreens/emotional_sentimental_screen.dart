import 'package:flutter/material.dart';

import '../../services/huggingface_service.dart';

class EmotionalSentimentalScreen extends StatefulWidget {
  final HuggingFaceService huggingFaceService;

  const EmotionalSentimentalScreen({
    super.key,
    required this.huggingFaceService,
  });

  @override
  State<EmotionalSentimentalScreen> createState() =>
      _EmotionalSentimentalScreenState();
}

class _EmotionalSentimentalScreenState
    extends State<EmotionalSentimentalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textCtrl = TextEditingController();
  String _emotion = '';
  String _emoji = '';
  double _confidence = 0.0;
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _analyzeEmotions() async {
    if (_isLoading ||
        _textCtrl.text.trim().isEmpty ||
        !(_formKey.currentState as FormState).validate())
      return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _emotion = '';
      _emoji = '';
      _confidence = 0.0;
    });

    try {
      final response = await widget.huggingFaceService.analyzeSentiment(
        _textCtrl.text,
      );
      setState(() {
        _emotion = response['emotion'] ?? 'N/A';
        _emoji = response['emoji'] ?? '😐';
        _confidence = response['confidence'] ?? 0.0;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                TextFormField(
                  controller: _textCtrl,
                  minLines: 3,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a prompt';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your prompt',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(  child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : ElevatedButton.icon(
                          onPressed: _isLoading ? null : _analyzeEmotions,
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text(
                            'Generate Emotional/Sentimental Text',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Analysis Result',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildResultView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (_errorMessage.isNotEmpty) {
      return Text(
        _errorMessage,
        style: TextStyle(fontSize: 16, color: Colors.red[700]),
      );
    } else if (_emotion.isEmpty) {
      return Text(
        'Your analysis result will appear here...',
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_emoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 8),
        Text(
          _emotion.toUpperCase(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Confidence: ${(_confidence * 100).toStringAsFixed(2)}%',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
