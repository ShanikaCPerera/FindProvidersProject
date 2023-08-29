import 'package:flutter/material.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryThemeColor,
        title: const Text('User Settings'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              }),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              'Edit User Account',
              style: TextStyle(
                color: AppColor.primaryTextColor,
              ),
            ),
            leading: const Icon(Icons.manage_accounts),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pushNamed(context, '/user_account');
            },
          ),
          Divider(
            color: Colors.grey.withOpacity(0.6),
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            title: const Text(
              'Change Password',
              style: TextStyle(
                color: AppColor.primaryTextColor,
              ),
            ),
            leading: const Icon(Icons.lock),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pushNamed(context, '/change_password');
            },
          ),
          Divider(
            color: Colors.grey.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
