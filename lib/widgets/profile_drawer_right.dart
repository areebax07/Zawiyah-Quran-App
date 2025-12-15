import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class ProfileDrawerRight extends StatelessWidget {
  const ProfileDrawerRight({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final subtleTextColor = isDarkMode ? Colors.white70 : Colors.black54;
        final dividerColor = isDarkMode ? Colors.white24 : Colors.grey[200]!;
        final purpleColor = const Color(0xFF863ED5);

        return Drawer(
          backgroundColor: bgColor,
          // FIX: Use ListView for proper layout and scrolling
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // FIX: Replaced UserAccountsDrawerHeader with a custom DrawerHeader for centering
              DrawerHeader(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : purpleColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // FIX: Avatar color now contrasts with the header
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: isDarkMode ? purpleColor : Colors.white,
                      foregroundColor: isDarkMode ? Colors.white : purpleColor,
                      child: Text(
                        user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.email ?? 'User',
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.email_outlined, color: subtleTextColor),
                title: Text('Email', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                subtitle: Text(user?.email ?? 'No email', style: TextStyle(color: subtleTextColor)),
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              ListTile(
                leading: Icon(Icons.perm_identity, color: subtleTextColor),
                title: Text('User ID', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                subtitle: Text(user?.uid ?? 'No ID', style: TextStyle(color: subtleTextColor, fontSize: 12)),
              ),
              // FIX: Moved Logout tile up and removed Spacer
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade400),
                title: Text('Logout', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
