import 'package:ai_intrigrations/Hugging%20Face%20AI/services/huggingface_service.dart';
import 'package:flutter/material.dart';

class HuggingFaceScreen extends StatefulWidget {
  const HuggingFaceScreen({super.key});

  @override
  State<HuggingFaceScreen> createState() => _HuggingFaceScreenState();
}

class _HuggingFaceScreenState extends State<HuggingFaceScreen>
    with SingleTickerProviderStateMixin {
  final HuggingFaceService _huggingFaceService = HuggingFaceService();
  late TabController _tabController;
  final _textCtrl = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _selectedTab) {
        setState(() {
          _selectedTab = _tabController.index;
          _result = '';
          _textCtrl.clear();
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  // API Call Logic
  Future<void> _performAction() async {
    if (_textCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    try {
      String response;
      switch (_selectedTab) {
        case 0:
          response = await _huggingFaceService.generateText(
            prompt: _textCtrl.text,
          );
          break;
        case 1:
          response = await _huggingFaceService.translateText(
            text: _textCtrl.text,
          );
          break;
        case 2:
          final sentiment = await _huggingFaceService.analyzeSentiment(
            _textCtrl.text,
          );
          response =
              'Emotion: ${sentiment['emoji']} ${sentiment['emotion']}\nConfidence: ${(sentiment['confidence'] * 100).toStringAsFixed(1)}%';
          break;
        default:
          response = "Please select a tab.";
      }
      setState(() => _result = response);
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppbar(),
            _buildTabBar(),
            Expanded(
              // Filling the empty TabBarView
              child: TabBarView(controller: _tabController, children: []),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Widgets ---

  // Appbar - Refined version of your code
  Widget _buildAppbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HuggingFace AI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Open Source AI Models',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TabBar - Refined version of your code
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20), // Using withAlpha
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          // Indicator
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Colors.blueAccent],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          // Makes indicator fit the tab
          labelColor: Colors.white,
          unselectedLabelColor: Theme.of(context).primaryColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.edit, size: 20), text: 'Generate'),
            Tab(icon: Icon(Icons.translate, size: 20), text: 'Translate'),
            Tab(icon: Icon(Icons.emoji_emotions, size: 20), text: 'Emotion'),
          ],
        ),
      ),
    );
  }



}
