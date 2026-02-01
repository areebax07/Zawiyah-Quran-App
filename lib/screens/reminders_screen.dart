import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final NotificationService _notificationService = NotificationService();

  // State for each reminder toggle switch
  final Map<String, bool> _reminderStates = {
    'Morning Adhkar': true,
    'Fajr Prayer': true,
    'Quran Reading': true,
    'Dhikr': true,
    'Evening Adhkar': true,
  };

  // Method to show a notification for a specific reminder
  Future<void> _showTestNotification(int id, String title, String body) async {
    await _notificationService.showNotification(id, '🌙 $title', body);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDarkMode = settings.isDarkMode;

    final List<Map<String, dynamic>> reminders = [
      {'id': 0, 'title': 'Morning Adhkar', 'subtitle': '6:00 AM - Start your day with remembrance.', 'body': 'Time for your morning Adhkar. May Allah bless your day!'},
      {'id': 1, 'title': 'Fajr Prayer', 'subtitle': 'Before sunrise - The best of all prayers.', 'body': 'The adhan for Fajr is calling. Prayer is better than sleep.'},
      {'id': 2, 'title': 'Quran Reading', 'subtitle': 'Daily - A chapter a day keeps Shaytan away.', 'body': 'Have you read your portion of the Quran today?'},
      {'id': 3, 'title': 'Dhikr', 'subtitle': 'Throughout the day - Remember Allah.', 'body': 'Take a moment to remember Allah. "SubhanAllah, Alhamdulillah, Allahu Akbar."'},
      {'id': 4, 'title': 'Evening Adhkar', 'subtitle': '6:00 PM - End your day with gratitude.', 'body': 'Time for your evening Adhkar. May Allah grant you a peaceful night.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Reminders'),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFF863ED5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  final title = reminder['title'] as String;
                  bool isEnabled = _reminderStates[title] ?? false;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(reminder['subtitle'] as String),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Switch(
                          //   value: isEnabled,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _reminderStates[title] = value;
                          //     });
                          //   },
                          //   activeColor: isEnabled ? Colors.purple[700] : Colors.red,
                          // ),
                          const SizedBox(width: 70),
                          ElevatedButton(
                            onPressed: () => _showTestNotification(reminder['id'], title, reminder['body'] as String),
                            child: const Text('ON'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: const Text('Show All Notifications'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                for (final reminder in reminders) {
                  await _showTestNotification(reminder['id'], reminder['title'] as String, reminder['body'] as String);
                  await Future.delayed(const Duration(seconds: 2)); // 2-second delay between each notification
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
