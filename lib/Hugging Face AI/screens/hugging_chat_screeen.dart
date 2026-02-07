import 'package:ai_intrigrations/Hugging%20Face%20AI/services/huggingface_service.dart';
import 'package:flutter/material.dart';

import 'subsScreens/text_genaration_screen.dart';

class HuggingFaceScreen extends StatefulWidget {
  const HuggingFaceScreen({super.key});

  @override
  State<HuggingFaceScreen> createState() => _HuggingFaceScreenState();
}

class _HuggingFaceScreenState extends State<HuggingFaceScreen>
    with SingleTickerProviderStateMixin {
  final HuggingFaceService _huggingFaceService = HuggingFaceService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppbar(),
            _buildTabBar(),
            Expanded(
              // Filling the empty TabBarView
              child: TabBarView(controller: _tabController, children: [
                TextGenarationScreen(huggingFaceService: _huggingFaceService,),
                Card(child: Text('Translet'),),
                Card(child: Text('Emotion'),),
              ]),
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
