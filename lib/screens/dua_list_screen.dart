import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/screens/dua_detail_screen.dart';
import 'package:zawiyah/services/api_service.dart';

class DuaListScreen extends StatefulWidget {
  const DuaListScreen({Key? key}) : super(key: key);

  @override
  _DuaListScreenState createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  late Future<List<dynamic>> _duasFuture;

  @override
  void initState() {
    super.initState();
    _duasFuture = ApiService().getDuaList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];
        final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final purpleColor = const Color(0xFF863ED5);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('Duas'),
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : purpleColor,
            foregroundColor: Colors.white,
          ),
          body: FutureBuilder<List<dynamic>>(
            future: _duasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: purpleColor));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Failed to load duas. Error: ${snapshot.error.toString()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700, fontSize: 16),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No duas found.', style: TextStyle(color: textColor)));
              }

              final duas = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemCount: duas.length,
                itemBuilder: (context, index) {
                  final dua = duas[index];
                  final title = dua['title'] as String? ?? 'Untitled Dua';

                  return Card(
                     elevation: 2,
                     margin: const EdgeInsets.only(bottom: 12),
                     color: cardColor,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: CircleAvatar(
                        backgroundColor: purpleColor.withOpacity(0.1),
                        child: Icon(Icons.mosque_outlined, color: purpleColor, size: 24),
                      ),
                      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DuaDetailScreen(dua: dua),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
