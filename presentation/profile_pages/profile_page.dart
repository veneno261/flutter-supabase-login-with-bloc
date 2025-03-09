import 'package:flutter/material.dart';

import '../../repositories/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // get auth service
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // logout button
          IconButton(onPressed: logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        //child: MaterialButton(onPressed: getRules, child: const Text('get !'),),
      ),
    );
  }
}
