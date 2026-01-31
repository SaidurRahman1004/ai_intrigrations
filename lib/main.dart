import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'Simulation/ai_semolatiom_demo.dart';
import 'core/constant.dart';
import 'gmini/screens/chat_screen.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(const AiPractise());
}

class AiPractise extends StatelessWidget {
  const AiPractise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4.0,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
        ),

        cardTheme: CardThemeData(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const AiProjects(),
    );
  }
}

//show all project
class AiProjects extends StatelessWidget {
  const AiProjects({super.key});

  Future<void> listMyAvailableModels() async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models?key=${AppConst.gminiApi}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Avilable models for you:");
      print(response.body);
    } else {
      print("error: ${response.statusCode}, messege: ${response.body}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Projects'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ProjectCard(
            icon: Icons.model_training,
            name: 'AI Simulation',
            description: 'Simulate On-device, Cloud, and Hybrid AI methods.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIMethodsDemo()),
              );
            },
          ),

          ProjectCard(
            icon: Icons.air,
            name: 'Gmini Intrigration',
            description: 'Gmini gemini-2.5-flash',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),

          ProjectCard(
            icon: Icons.tab,
            name: 'Gmini Avilable Models Test',
            description: 'Gmini Models',
            onTap: () {
              listMyAvailableModels();

            },
          ),
        ],
      ),
    );
  }
}

// custom CArd
class ProjectCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
    required this.onTap,
  });




  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        // বর্ডারের সাথে মিল রেখে ট্যাপ ইফেক্ট
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
