import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Unknown User';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              email,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 40),
            
            // Dark Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppTheme.primaryColor),
                value: isDark,
                activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.5),
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (val) {
                  MyApp.switchTheme(context, val);
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // Logout Button
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                onTap: () async {
                  // WIPE LOCAL DATA FIRST!
                  await DatabaseService.clearLocalData();
                  // THEN LOGOUT OF FIREBASE
                  await FirebaseAuth.instance.signOut();
                  
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
