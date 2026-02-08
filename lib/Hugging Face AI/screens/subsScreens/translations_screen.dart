import 'package:flutter/material.dart';

import '../../services/huggingface_service.dart';

class TranslationText extends StatefulWidget {
  final HuggingFaceService huggingFaceService;

  const TranslationText({super.key, required this.huggingFaceService});

  @override
  State<TranslationText> createState() => _TranslationTextState();
}

class _TranslationTextState extends State<TranslationText> {
  final _formKey = GlobalKey<FormState>();
  final _textCtrl = TextEditingController();
  String _translatedText = '';
  String _errorMessage = '';
  bool _isLoading = false;

  //state for language selection
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Bengali';
  final List<String> _languages = ['English', 'Bengali'];

  Future<void> _translate() async {
    if (_isLoading || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _translatedText = '';
      _errorMessage = '';
    });
    try {
      final response = await widget.huggingFaceService.translateText(
        text: _textCtrl.text,
        fromLang: _sourceLanguage == 'English' ? 'en' : 'bn',
        toLang: _targetLanguage  == 'English' ? 'en' : 'bn',
      );
      setState(() {
        _translatedText = response;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  //language Swiping
  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
    });
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
                _buildLanguageSelector(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _textCtrl,
                  minLines: 4,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter Text to Translate';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Text',
                    hintText: 'Type or paste your text here...',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _translate,
                    icon: _isLoading
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.translate_outlined),
                    label: const Text('Translate'),
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
                  'Result',
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
                  child: _buildResultView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Language Selector Widget
  Widget _buildLanguageSelector() {
    return Row(
      mainAxisAlignment: .spaceAround,
      children: [
        Expanded(
          child: _buildLanguageDropdown(
            "From",
            _sourceLanguage,
            (val) => setState(() => _sourceLanguage = val!),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Icon(Icons.swap_horiz, color: Theme.of(context).primaryColor),
            onPressed: _swapLanguages,
          ),
        ),
        Expanded(
          child: _buildLanguageDropdown(
            "To",
            _targetLanguage,
                (val) => setState(() => _targetLanguage = val!),
          ),
        )
      ],
    );
  }

  //Lagguage Dropdown Widget
  Widget _buildLanguageDropdown(
    String label,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        DropdownButton(
          value: value,
          isExpanded: true,
          items: _languages.map((String lang) {
            return DropdownMenuItem(value: lang, child: Text(lang));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  //result Show Widget
  Widget _buildResultView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_translatedText.isEmpty) {
      return Center(
        child: Text(
          'Translated text will appear here...',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }
    return SelectableText(
      _translatedText,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
