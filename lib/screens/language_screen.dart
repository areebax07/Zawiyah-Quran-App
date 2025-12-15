import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, String>> _allLanguages;
  List<Map<String, String>> _filteredLanguages = [];

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'nativeName': 'English', 'flag': 'assets/flags/us.png', 'locale': 'en'},
    {'name': 'العربية', 'nativeName': 'Arabic', 'flag': 'assets/flags/saudi.png', 'locale': 'ar'},
    {'name': 'اردو', 'nativeName': 'Urdu', 'flag': 'assets/flags/pak.png', 'locale': 'ur'},
    {'name': 'Bahasa Indonesia', 'nativeName': 'Indonesian', 'flag': 'assets/flags/indonesia.png', 'locale': 'id'},
    {'name': 'Türkçe', 'nativeName': 'Turkish', 'flag': 'assets/flags/turkey.png', 'locale': 'tr'},
    {'name': 'Français', 'nativeName': 'French', 'flag': 'assets/flags/France.png', 'locale': 'fr'},
    {'name': 'Deutsch', 'nativeName': 'German', 'flag': 'assets/flags/germen.png', 'locale': 'de'},
    {'name': 'Español', 'nativeName': 'Spanish', 'flag': 'assets/flags/sapim.png', 'locale': 'es'},
    {'name': 'বাংলা', 'nativeName': 'Bengali', 'flag': 'assets/flags/bangladesh.png', 'locale': 'bn'},
    {'name': 'हिन्दी', 'nativeName': 'Hindi', 'flag': 'assets/flags/ind.png', 'locale': 'hi'},
    {'name': 'Melayu', 'nativeName': 'Malay', 'flag': 'assets/flags/Maley.png', 'locale': 'ms'},
    {'name': 'Svenska', 'nativeName': 'Swedish', 'flag': 'assets/flags/Swedish.png', 'locale': 'sv'},
  ];

  @override
  void initState() {
    super.initState();
    _allLanguages = _languages;
    _filteredLanguages = _allLanguages;
    _searchController.addListener(_filterLanguages);
  }

  void _filterLanguages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLanguages = _allLanguages.where((lang) {
        return lang['name']!.toLowerCase().contains(query) ||
               lang['nativeName']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showSaveLanguageDialog(Map<String, String> language) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Language'),
        content: Text('Set language to ${language['nativeName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newLocale = Locale(language['locale']!);
              Provider.of<SettingsProvider>(context, listen: false).setLocale(newLocale);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: const Color(0xFF8B46D7),
        foregroundColor: Colors.white,
        // Themed AppBar without rounded corners
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a language...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = _filteredLanguages[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(language['flag']!),
                      onBackgroundImageError: (_, __) {},
                      child: language['flag'] == null ? const Icon(Icons.flag) : null,
                    ),
                    title: Text(language['name']!),
                    onTap: () {
                      _showSaveLanguageDialog(language);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
