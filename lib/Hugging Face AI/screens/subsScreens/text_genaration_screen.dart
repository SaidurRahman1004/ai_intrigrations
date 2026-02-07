import 'package:flutter/material.dart';

import '../../services/huggingface_service.dart';

class TextGenarationScreen extends StatefulWidget {
  final HuggingFaceService huggingFaceService;

  const TextGenarationScreen({super.key, required this.huggingFaceService});

  @override
  State<TextGenarationScreen> createState() => _TextGenarationScreenState();
}

class _TextGenarationScreenState extends State<TextGenarationScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final _textCtrl = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _generateText() async {
    if (_isLoading ||
        _textCtrl.text.trim().isEmpty ||
        !(_formKey.currentState as FormState).validate())
      return;

    try {
      setState(() {
        _isLoading = true;
        _result = '';
      });
      final response = await widget.huggingFaceService.generateText(
        prompt: _textCtrl.text,
      );
      setState(() {
        _result = response;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
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
                  minLines: 2,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a prompt';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your prompt',
                    suffixIcon: IconButton(
                      onPressed: _isLoading ? null : _generateText,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Generated Text',
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
                      : SingleChildScrollView(
                          child: SelectableText(
                            _result.isEmpty
                                ? 'Your generated text will appear here...'
                                : _result,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
